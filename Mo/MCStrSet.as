// ��؂蕶����N���X

#ifndef __MODULECLASS_STRSET_AS__
#define __MODULECLASS_STRSET_AS__

#include "strutil.as"

#module MCStrSet mString, mStrLen, mStrSize, mChar, mCharLen, mIdxptrList, mcntIdxptr, mLastErr, mIterVar
#undef split
// ��`
#define FIRST_ALLOC_SIZE  0xFFFF
#define EXPAND_ALLOC_SIZE 0xFF
#define mv modvar MCStrSet@

#define mNow mIdxptrList(mcntIdxptr)

// �}�N��
#define ctype ErrReturn(%1,%2) mLastErr = (%1) : return (%2)
#define ctype ErrReturn2(%1)   mLastErr = (%1) : return (%1)

// �G���[�萔�̒�`
#enum global STRSET_ERR_NONE      = 0		// ���Ȃ�
#enum global STRSET_ERR_UNKNOWN   = -1		// ���炩�̃G���[ (�댯�x:��)
#enum global STRSET_ERR_DANGEROUS = -2		// ���炩�̃G���[ (�댯�x:��)
#enum global STRSET_ERR_NOMEMORY  = -3		// �������s��
#enum global STRSET_ERR_ARGMENT   = -4		// �������ُ� (�֐��Ȃ玸�s)
#enum global STRSET_ERR_EOS       = -5		// �Ō�܂œǂݐ؂���

// ����֐��}�N��
#define global StrSet_new(%1,%2="",%3) newmod %1, MCStrSet@, %2, %3
#define global StrSet_delete(%1) delmod %1

//##############################################################################
//        ���������o�֐��̒�`
//##############################################################################

//------------------------------------------------
// mString �͋�؂蕶���ŏI����Ă��邩�H
//------------------------------------------------
#define ctype _StrSet_IsLastChar(%1,%2=mString,%3=mStrLen) __StrSet_IsLastChar(%1,%2,%3)
#defcfunc    __StrSet_IsLastChar mv, var p2, int lenOf_p2
	if ( lenOf_p2 < mCharLen ) { return false }
	return ( StrCompNum(p2, mChar, mCharLen, lenOf_p2 - mCharLen) )
	
//------------------------------------------------
// mString �̍Ō�ɘA������
//------------------------------------------------
#define _StrSet_strcat(%1,%2,%3) _StrSet_strins %1,%2,%3,mStrLen

//------------------------------------------------
// mString �̓r���ɑ}������
//------------------------------------------------
#modfunc _StrSet_strins str p2, int p3, int offset
	if ( mStrSize <= mStrLen + p3 ) {
		mStrSize += EXPAND_ALLOC_SIZE	// �T�C�Y��傫������
		memexpand mString, mStrSize		// �m��
	}
	StrInsert mString, offset, p2, mStrLen, p3
	mStrLen = stat
	return
	
//------------------------------------------------
// p2 �` p3 ���폜����
//------------------------------------------------
#modfunc _StrSet_DeleteBetween int p2, int p3,  local iA, local iB
	if ( p2 == p3 ) { return }
	if ( p2 <  p3 ) {
		iA = p2 : iB = p3
	} else {
		iA = p3 : iB = p2
	}
	
	// �폜����
	StrDelete mString, iA, iB - iA, mStrLen
	mStrLen = stat
	
	// �|�C���^���폜�N�_����ɂ���Ȃ�A��������
	repeat mcntIdxptr
		if ( mIdxptrList(cnt) > iA ) {
			mIdxptrList(cnt) -= (iB - iA)
		}
	loop
	return
	
//------------------------------------------------
// ������̌�ɋ�؂蕶����t�����ĕԂ�
//------------------------------------------------
#modfunc _StrSet_addchar var p2, int p3,  local len
	if ( p3 ) { len = p3 } else { len = strlen(p2) }
	
	// ��ɋ�؂蕶����t������
	if ( _StrSet_IsLastChar(thismod, p2, len) == false ) {
		memexpand p2, len + mCharlen + 1	// �m��
		memcpy p2, mChar, mCharLen, len		// ��Ԍ��ɒǉ�
		len += mCharLen
		poke   p2, len, 0
	}
	return len
	
//------------------------------------------------
// n �Ԗڂ̃A�C�e���ւ̃C���f�b�N�X�l���擾
//------------------------------------------------
#defcfunc _StrSet_SearchByNum mv, int no, int iFrom,  local i, local n, local c, local c2
	i  = iFrom
	n  = 0
	c2 = peek(mChar)
	while ( n < no )
		c = peek(mString, i)
		if ( c == c2 ) {	// �擪�݂̂̔�r�ō�������}��
			
			if ( StrCompNum( mString, mChar, mCharLen, i ) ) {
				// ����
				n ++			// �J�E���g�A�b�v
				i += mCharLen	// ��΂�
				_continue
			}
			
		} else : if ( c == 0 ) {
			ErrReturn2(STRSET_ERR_ARGMENT)
		}
		i ++
	wend
	if ( n != no ) { ErrReturn2(STRSET_ERR_ARGMENT) }
	return i
	
//------------------------------------------------
// �w�蕶����̍��ڂ܂ł̃C���f�b�N�X�l�����߂�
//------------------------------------------------
#define global ctype _StrSet_FindStr(%1,%2,%3=0,%4=-1) __StrSet_FindStr(%1,%2,%3,%4)
#defcfunc __StrSet_FindStr mv, str p2, int iFrom, int lenOf_p2,  local stmp, local len
	if ( lenOf_p2 < 0 ) { len = strlen(p2) } else { len = lenOf_p2 }
	
	sdim stmp, len + mCharLen + 1
	stmp = p2
	
;	logmes logv(stmp)
	
	// �O�̋�؂蕶������������
	if ( StrCompNum(stmp, mChar, mCharLen) ) {
		StrDelete  stmp, 0, mCharLen, len : len = stat
	}
	// ��ɋ�؂蕶����t������
	_StrSet_addchar thismod, stmp, len : len = stat
	
;	logmes logv(stmp)
	
	// �ŏ��̍��ڂ����ꂩ�H ( ��p2�̍Ō�� mChar �������Ă��A�ǂ�����r���Ȃ��̂Ŗ��Ȃ� )
	if ( iFrom <= 0 ) : if ( StrCompNum(mString, stmp, len) ) {
		return 0
	}
	
	// ���Ԃ̍��ڂɃ}�b�`������̂����邩�T��
	return ( instr(mString, iFrom, mChar + stmp) )	// �u��؂� ���� ��؂�v��T��
	
//------------------------------------------------
// ���łɍ��ڂƂ��đ��݂��邩
//------------------------------------------------
#defcfunc _StrSet_IsInserted mv, str p2
	
	if ( instr(mString, 0, mChar) < 0 ) {	// ��؂蕶�����Ȃ�
		return ( mString == p2 )			// �B��̍��ڂ�����Ȃ�^
	}
	
	return ( _StrSet_FindStr(thismod, p2) >= 0 )
	
//------------------------------------------------
// �Ō�̍��ڂ܂ł̃C���f�b�N�X�l�����߂�
//------------------------------------------------
#defcfunc _StrSet_IdxOfLast mv, local i
	// �Ō��T��
	i = instrb( mString, 0, mChar, mStrLen, mCharLen )
	
	// �����ł��Ȃ�������A�擪����S���ɂȂ�
	if ( i < 0 ) {
		return 0	// ��؂蕶�����Ȃ�
		
	// �Ōオ��؂蕶���ŏI����Ă�����
	} else : if ( i == (mStrLen - mCharLen) ) {
		// ������x��������
		i = instrb( mString, mCharLen, mChar, mStrLen, mCharLen )
		
		// �����ł��Ȃ�������A�󕶎���ɂȂ�
		if ( i < 0 ) {
			return mStrLen
		}
		
	// �Ōオ��؂蕶���ł͂Ȃ�
	} ;else {}		// �K�v�ȏ����͂Ȃ�
	
	// ��؂蕶���̕����X�L�b�v������
	return i + mCharLen
	
//##############################################################################
//                �R���X�g���N�^�E�f�X�g���N�^
//##############################################################################
//------------------------------------------------
// �R���X�g���N�^
//------------------------------------------------
;#deffunc StrSet_Init modinit MCStrSet@, str p2, str p3
#modinit str p2, str p3
	sdim mString, FIRST_ALLOC_SIZE
	sdim mChar
	sdim mIterVar
	
	mString     = p2
	mChar       = p3
	mStrLen     = strlen(mString)
	mCharLen    = strlen(mChar)
	mStrSize    = FIRST_ALLOC_SIZE
	mNow        = 0
	mLastErr    = STRSET_ERR_NONE
	mcntIdxptr  = 0
	mIdxptrList = 0
	
	// mString �̍Ō�� mChar ��ǉ�����
	if ( mStrLen ) {
		_StrSet_addchar thismod, mString, mStrLen : mStrLen = stat
	}
	
	return
	
//------------------------------------------------
// �f�X�g���N�^
//------------------------------------------------
;#modterm
;	return

//##############################################################################
//                �����o�֐�
//##############################################################################

//##########################################################
//        �擾�|�C���^����n�֐��Q
//##########################################################
//------------------------------------------------
// �擪�ɖ߂�
//------------------------------------------------
#modfunc StrSet_gotop
	mNow = 0
	return
	
//------------------------------------------------
// �I�[�܂ŃW�����v
//------------------------------------------------
#modfunc StrSet_gobtm
	mNow = mStrLen
	return
	
//------------------------------------------------
// n �߂�
//------------------------------------------------
#modfunc StrSet_back int num, local offset, local i
	if ( num <= 0 ) { return }
	
	i      = mNow - mCharLen	// �ŏ��̃I�t�Z�b�g ( mNow �̎�O�ɂ��� mChar �ւ̃I�t�Z�b�g )
	mNow   = -1
	repeat num
		// �������Ɍ���( num�񔭌�����܂� )
		i = instrb(mString, mStrLen - i, mChar, mStrLen, mCharLen)
		
		if ( i < 0 ) { mNow = 0 : break }	// �擪
	loop
	
	if ( mNow < 0 ) { mNow = i + mCharLen }
	return
	
//------------------------------------------------
// n ��΂�
//------------------------------------------------
#modfunc StrSet_skip int num
	i = _StrSet_SearchByNum(thismod, num, mNow)
	
	if ( i < 0 ) {
		mLastErr = STRSET_ERR_ARGMENT
		i        = mStrLen			// �I�[
	}
	mNow = i		// �V�����擾�|�C���^
	return
	
//------------------------------------------------
// n �ԖڂɈړ� (�����_���A�N�Z�X)
//------------------------------------------------
#modfunc StrSet_jump int no
	StrSet_gotop thismod		// ��U�擪�ɖ߂���
	StrSet_skip  thismod, no	// no ��΂�
	return
	
	
//------------------------------------------------
// �擾�|�C���^���v�b�V��
//------------------------------------------------
#modfunc StrSet_pushIdxptr int p2
	mcntIdxptr ++
	mNow = 0
	if ( p2 ) { StrSet_jump thismod, p2 }
	return
	
//------------------------------------------------
// �擾�|�C���^���|�b�v
//------------------------------------------------
#modfunc StrSet_popIdxptr
	if ( mcntIdxptr > 0 ) {
		mcntIdxptr --
	}
	return
	
//##########################################################
//        �ǉ��n�֐��Q
//##########################################################
// ���K�� mString �̍Ōオ mChar �ŏI���悤�ɔz������

//------------------------------------------------
// �Ō�ɉ�����
//------------------------------------------------
#modfunc StrSet_add str p2
	
	len = strlen(p2)
	sdim stmp, len + 1
	stmp = p2
	
	// ������̍Ō�ɋ�؂蕶����t��
	_StrSet_addchar thismod, stmp, len : len = stat
	
	// �Ō�ɘA������
	_StrSet_strcat thismod, stmp, len
	return
	
//------------------------------------------------
// ���݂̈ʒu�ɒǉ�����
// 
// @ ���� getnext �Ŏ擾�����
//------------------------------------------------
#modfunc StrSet_insnow str p2
	
	// ���ɋ�؂蕶����ǉ����Ă���
	_StrSet_strins thismod, p2 + mChar, strlen(p2) + mCharLen, mNow
	
	return
	
//------------------------------------------------
// n �Ԗڂ̈ʒu�ɒǉ�����
// 
// @return int : �}���ʒu�̃C���f�b�N�X�l
//------------------------------------------------
#modfunc StrSet_insert str p2, int no
	
	// ������
	i = _StrSet_SearchByNum(thismod, no, 0)
	if ( i < 0 ) { return stat }
	
	// str �̌��ɋ�؂蕶����t�����āA�}��
	len = strlen(p2) + mCharLen
	
	_StrSet_strins thismod, p2 + mChar, len, i
	
	// mNow ���O�Ȃ�AmNow �����Z���Ă���
	repeat mcntIdxptr
		if ( i < mIdxptrList(cnt) ) { mIdxptrList(cnt) += len }
	loop
	return i
	
//------------------------------------------------
// �r���I�n
//------------------------------------------------
#modfunc StrSet_xadd str p2
	if ( _StrSet_IsInserted(thismod, p2) ) { return false }
	StrSet_add thismod, p2
	return true
	
#modfunc StrSet_xinsnow str p2
	if ( _StrSet_IsInserted(thismod, p2) ) { return false }
	StrSet_insnow thismod, p2
	return true
	
#modfunc StrSet_xinsert str p2, int no
	if ( _StrSet_IsInserted(thismod, p2) ) { return -1 }
	StrSet_insert thismod, p2, no
	return stat
	
//##########################################################
//        �擾�n�֐��Q
//##########################################################
//------------------------------------------------
// �ŏ��̃��m���擾
//------------------------------------------------
#defcfunc StrSet_gettop mv
	sdim   stmp, mStrLen	// ��mChar �܂ł�؂�o��
	StrCut stmp, mString, 0, mChar, mStrLen, mCharLen
	return stmp
	
//------------------------------------------------
// ���̃��m���擾
//------------------------------------------------
#defcfunc StrSet_getnext mv
	sdim   stmp, mStrLen
	StrCut stmp, mString, mNow, mChar, mStrLen, mCharLen
	
	mNow += stat + mCharLen			// �擾�|�C���^��i�߂�
	if ( mNow >= mStrLen ) {
		mLastErr = STRSET_ERR_EOS
	}
	return stmp
	
//------------------------------------------------
// ���O�Ɏ擾�������m���擾
//------------------------------------------------
#defcfunc StrSet_getprev mv
	StrSet_back thismod, 1
	return StrSet_getnext(thismod)
	
//------------------------------------------------
// �Ō�̃��m���擾
//------------------------------------------------
#defcfunc StrSet_getlast mv
	// �؂�o���ĕԂ�
	sdim   stmp, mStrLen
	StrCut stmp, mString, _StrSet_IdxOfLast(thismod), mChar, mStrLen, mCharLen
	return stmp
	
//------------------------------------------------
// n �Ԗڂ̃��m���擾
// 
// @ �����_���A�N�Z�X
//------------------------------------------------
#defcfunc StrSet_getone mv, int no
	
	// ������
	i = _StrSet_SearchByNum(thismod, no, 0)
	if ( i < 0 ) : ErrReturn(STRSET_ERR_ARGMENT, "")
	
	// �؂�o���ĕԂ�
	sdim   stmp, mStrLen
	StrCut stmp, mString, i, mChar, mStrLen, mCharLen
	return stmp
	
//------------------------------------------------
// ���ׂĎ擾
//------------------------------------------------
#defcfunc StrSet_getall mv
	return mString
	
//------------------------------------------------
// ���ׂĎ擾
// 
// @ �o�b�t�@�ɃR�s�[
//------------------------------------------------
#modfunc StrSet_getall_tobuf var outbuf
	memexpand outbuf, mStrLen + 1
	memcpy    outbuf, mString, mStrLen
	poke      outbuf, mStrLen, 0
	return
	
//##########################################################
//        �폜�n�֐��Q
//##########################################################
//------------------------------------------------
// ���Ɏ擾�������̂��폜
//------------------------------------------------
#modfunc StrSet_delnow
	// ���̍��ڂ̃C���f�b�N�X���擾
	iNext = _StrSet_SearchByNum(thismod, 1, mNow)
	if ( iNext < 0 ) { return true }
	
	// �폜����
	_StrSet_DeleteBetween thismod, mNow, iNext
	return false
	
//------------------------------------------------
// �O��̃��m���폜
// 
// @ �O��� getnext() �Ŏ擾�������̂��폜
//------------------------------------------------
#modfunc StrSet_delback
	StrSet_back   thismod, 1	// ��߂���
	StrSet_delnow thismod		// �u���v�̂��폜����
	return stat
	
//------------------------------------------------
// n �Ԗڂ��폜����
// 
// @ �����_���A�N�Z�X
//------------------------------------------------
#modfunc StrSet_delone int no
	// no �Ԗڂ̃C���f�b�N�X���擾
	iPos = _StrSet_SearchByNum(thismod, no, 0)
	if ( iPos < 0 ) { return true }
	
	// ���̍��ڂ̃C���f�b�N�X���擾
	iNext = _StrSet_SearchByNum(thismod, 1, iPos)
	if ( iNext < 0 ) { return true }
	
	// iPos �` iNext ���폜
	_StrSet_DeleteBetween thismod, iPos, iNext
	return false
	
//------------------------------------------------
// ��̍��ڂ��폜
//------------------------------------------------
#modfunc StrSet_delvoid  local word
	// ��؂蕶������A���ɂȂ��Ă���Ƃ����T���č폜
	len    = mCharLen * 2
	offset = 0
	
	sdim   word, len + 1
	memcpy word, mChar, mCharLen
	memcpy word, mChar, mCharLen, mCharLen
	// �� word = mChar + mChar
	
	i = 0
	while ( mStrLen > 0 )
		// ����
		i = instr(mString, 0, word)
		if ( i < 0 ) { _break }
		
		// 1�����폜����
		_StrSet_DeleteBetween thismod, i, i + mCharLen
	wend
	return false
	
//------------------------------------------------
// �w�蕶����̍��ڂ��폜
//------------------------------------------------
#modfunc StrSet_delstr str p2, int bGlobal
	
	len = strlen(p2) + mCharLen
	
	// stmp �ɋ�؂蕶����t��
	sdim stmp, len
	stmp = p2 + mChar
	
	// bGlobal ���^�Ȃ�J��Ԃ�
	do
		i = _StrSet_FindStr(thismod, stmp, 0, len)	// ����
		if ( i < 0 ) { _break }			// ������ΏI������
		
		// �폜����
		_StrSet_DeleteBetween thismod, i, i + len
		
	until ( bGlobal )
	
	return
	
//##########################################################
//        �����n�֐��Q
//##########################################################
// ���Ȃ���Ε�����Ԃ��̂ŁA( �Ԃ�l < 0 ) ���U�̂Ƃ��A�����B

//------------------------------------------------
// �����񂩂猟��
//------------------------------------------------
#define global StrSet_findStr _StrSet_FindStr

//------------------------------------------------
// �w�蕶����̍��ڂ����݂��邩�ǂ���
//------------------------------------------------
#define global ctype StrSet_exists(%1,%2="") ( StrSet_findStr(%1,%2) >= 0 )

//##########################################################
//        �J�Ԏq�n�֐��Q
//##########################################################
//------------------------------------------------
// �����J�n�̐ݒ�
//------------------------------------------------
#modfunc StrSet_iter int p2
	StrSet_pushIdxptr thismod, p2
	return
	
//------------------------------------------------
// �����J�n�̐ݒ�
// 
// @ �O���̕ϐ����g���ꍇ
//------------------------------------------------
#modfunc StrSet_iterVar int p2, var p3
	StrSet_iter thismod, p2
	dup mIt, p3					// mIt ���N���[���ɂ���
	return
	
//------------------------------------------------
// ���̍��ڂɈړ�����
// @private
// @ mIt �̍X�V
//------------------------------------------------
#modfunc StrSet_iterCheckCore
	mIt = StrSet_getnext(thismod)
	return
	
//------------------------------------------------
// while �̔��������Ɏg��
//------------------------------------------------
#defcfunc StrSet_iterCheck mv, local bool
	bool = ( mLastErr != STRSET_ERR_EOS )
	StrSet_IterCheckCore thismod	// �X�V�����
	if ( bool == false ) {
		StrSet_popIdxptr thismod
	}
	return bool
	
//------------------------------------------------
// ���݂̍��ڂ��擾���� ( �����ϐ� mIt ���g���ꍇ )
//------------------------------------------------
#defcfunc StrSet_it mv
	return mIt
	
//------------------------------------------------
// [i] �J�Ԏq������
//------------------------------------------------
#modfunc StrSet_iterInit var iterData
	StrSet_iter thismod
	iterData = false
	return
	
//------------------------------------------------
// [i] �J�Ԏq�X�V
//------------------------------------------------
#defcfunc StrSet_iterNext mv, var vIt, var iterData
	if ( iterData == false ) {
		dup vIt, mIt
		iterData = true
	}
	return StrSet_iterCheck(thismod)
	
//##########################################################
//        �֗����[�`���֐��Q
//##########################################################
//------------------------------------------------
// �S���ڂ�z��ɂ��ĕԂ�
//------------------------------------------------
#ifdef split
#modfunc StrSet_toArray array strlist
	split mString, mChar, strlist
	return stat - 1
#else
#modfunc StrSet_toArray array strlist, local count
	count = 0
	StrSet_iter thismod
	while ( StrSet_iterCheck(thismod) )
		strlist(count) = StrSet_it(thismod)
		count ++
	wend
	return count
#endif
	
//------------------------------------------------
// �w�肵���ʒu�œ񓙕�����
// 
// @ inPosItem �́A�ʒu�̍��ڂ��ǂ���ɓ��邩
//   0 �Ȃ疳���A1 �͑O�A2 �͌�
//------------------------------------------------
#modfunc StrSet_divByPos array str2, int p, int inPosItem
	sdim str2, mStrLen, 2
	i = _StrSet_SearchByNum( thismod, p + (inPosItem == 1), 0 )
	
	// ��
	memcpy str2(0), mString, i
	if ( inPosItem == 0 ) { i = _StrSet_SearchByNum( thismod, 1, i ) }
	
	// �E
	memcpy str2(1), mString, mStrLen - i, 0, i
	
	// mChar ����������
	repeat 2
		len = strlen(str2(cnt))
		if ( StrCompNum(str2(cnt), mChar, mCharLen, len - mCharLen) ) {
			poke str2(cnt), len - mCharLen, 0		// mChar �̐擪�� NULL �ɂ��āA��������~�߂�
		}
	loop
	
	return
	
//##########################################################
//        ���̑��֐��Q
//##########################################################
//------------------------------------------------
// �R�s�[���쐬����
//------------------------------------------------
#modfunc StrSet_copy var v_copy
	StrSet_new v_copy, mString, mChar
	return stat
	
//------------------------------------------------
// ���ڐ��̎擾
//------------------------------------------------
#defcfunc StrSet_cntItems mv
	offset = 0
	repeat
		// ���̍��ڂ̈ʒu
		offset = _StrSet_SearchByNum(thismod, 1, offset)
		if ( offset < 0 ) {
			i = cnt
			// �Ōオ��؂蕶���łȂ���΁A+1 ���Ē���
			if ( _StrSet_IsLastChar(thismod) == false ) {
				i ++
			}
			break
		}
	loop
	
	// STRSET_ERR_ARGMENT ���i�[����Ă���̂ŁA�㏑������
	mLastErr = STRSET_ERR_NONE
	return i
	
//------------------------------------------------
// ��؂蕶����ϊ�
//------------------------------------------------
#modfunc StrSet_chgChar str newChar
	len = strlen(newChar)
	
	// ���v�Ȃ悤�ɍĊm��
	if ( len > mCharLen ) {
		memexpand mString, mStrSize + (mCharLen - len) * StrSet_CntItems(thismod)
	}
	
	// ��؂蕶���̑S�u��
	StrReplace mString, mChar, newChar
	mStrLen = strlen(mString)
	
	// �K�v�Ȃ�g������
	if (mStrSize <= mStrLen) {
		mStrSize += mStrLen + EXPAND_ALLOC_SIZE
		memexpand   mString, mStrSize
	}
	
	// mChar �u������
	mChar    = newChar
	mCharLen = len
	return
	
//------------------------------------------------
// ��؂蕶����ϊ����Ă���擾
//------------------------------------------------
#defcfunc StrSet_getall_byChar mv, str newChar, local copy
	StrSet_copy    thismod, copy
	StrSet_chgChar copy, newChar
	return StrSet_getall(copy)
	
//------------------------------------------------
// ��؂蕶�����擾
//------------------------------------------------
#defcfunc StrSet_char mv
	return mChar
	
//------------------------------------------------
// ���݂̎擾�|�C���^�̈ʒu
//------------------------------------------------
#defcfunc StrSet_now mv
	return mNow
	
//------------------------------------------------
// �Ō�ɋN�����G���[
//------------------------------------------------
#defcfunc StrSet_getLastErr mv
	return mLastErr
	
#ifdef _DEBUG
#modfunc ss_check
	logmes logv(strlen(mString))
	logmes logv(mStrLen        )
	return
#endif

#global

#module
//##############################################################################
//        �O�t�����[�`��
//##############################################################################

#global

//##############################################################################
//        �T���v���E�X�N���v�g
//##############################################################################
#if 0

#define write(%1="") if ( bufsize - iWrote <= 300 ) { bufsize += 320 : memexpand buf, bufsize } poke buf, iWrote, ""+ (%1) +"\n" : iWrote += strsize
#define writeAll write StrSet_getall(ss)
	
	bufsize = 320
	sdim buf, bufsize
	
	StrSet_new ss, "��,��,��", ","
	
	write "mString = "+ StrSet_getall(ss)
	write
	
	write "�Eadd()"
	StrSet_add ss, "addition,two,"
	writeAll
	
	write "\n�Einsnow(str);"
	StrSet_insnow ss, "insert str"
	writeAll
	
	write "\n�Einsert(str, int);"
	StrSet_insert ss, "bcc", 2
	writeAll
	
	write "\n�Exadd(str);"
	StrSet_xadd ss, "bcc,"
	writeAll
	
	write "\n�Eget�n();"
	write StrSet_gettop(ss)    +"\t(top) "
	write StrSet_getlast(ss)   +"\t(last)"
	write StrSet_getone(ss, 2) +"\t(2)"
	
	write "\n�Egetnext();"
	write StrSet_getnext(ss)
	write StrSet_getnext(ss)
	write StrSet_getnext(ss)
	
	write "\n�Edel�n();"
	StrSet_delone ss, 1
	write "delone(1) : "+ StrSet_getall(ss)
	StrSet_gobtm   ss
	StrSet_delback ss
	write "delback() : "+ StrSet_getall(ss) +"\t(delete at last)"
	
	write "\n�Ejump(1);"
	StrSet_jump ss, 1
	
	write "\n�Egetnext(); �� now(); "
	write StrSet_getnext(ss) +"\t("+ StrSet_now(ss) +")"
	write StrSet_getnext(ss) +"\t("+ StrSet_now(ss) +")"
	
	write "\n�Eskip();"
	StrSet_skip ss, 9
	
	write StrSet_now(ss)
	write StrSet_getnext(ss)
	
	write "\n�E�󍀖ڂ��ʂɒǉ�"
	StrSet_add ss, ",,,,,,d,,,d,,s,a,,,,gg,g"
	writeAll
	
	write "\n�Edelvoid();"
	StrSet_delvoid ss
	writeAll
	
	write "\n�E���ڐ����擾 CntItems();"
	write "���ڐ� = "+ StrSet_cntItems(ss)
	
	write "\n�E��؂蕶����ύX ChgChar();"
	StrSet_chgChar ss, "[��]"
	writeAll
	
	StrSet_xadd ss, "new[]"
	writeAll
	
	StrSet_chgChar ss, "><"
	writeAll
	
;	string = StrSet_getall(ss)
	
	// �C�e���[�^�̃T���v�� ( �S���ڂ��o�͂��� )
	write "\n�EIterator Sample ( output all items )"
	
;	StrSet_iter  ss, 0				// p2 �ɁA���ڂ̍��ڂ���n�߂邩��ݒ�ł���
;	while ( StrSet_iterCheck(ss) )	// �X�V
;		write StrSet_it(ss)			// ���݂̒l�͊֐��Ŏ擾����
;	wend
	StrSet_toArray ss, slist
	repeat stat						// foreach �̓_��
		write slist(cnt)
	loop
	
	// �o��
	objmode 2, 0
	mesbox buf, ginfo(12), ginfo(13)
	
;	delmod ss
	stop
	
#endif

#endif
