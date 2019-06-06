// �ėp�����񑀍샂�W���[��

#ifndef __STRING_UTILITY_AS__
#define __STRING_UTILITY_AS__

/**+
 * strutil
 * String utility module
 * @ author Ue-dai
 * @date 2008/09/29
 * @ver 1.0.0
 * @type ���ߊg�����W���[��
 * @group �����񑀍�֐�
 */

#include "mod_replace.as"
#define global StrReplace replace

#module strutil

// �����߁E�֐� �Ԃ̕ϐ��̏Փ˂͋C�ɂ��Ȃ��B
// �@�ʂ̊֐��́A�Փ˂��Ă����Ȃ��ꍇ�������A�Ăяo���Ă͂����Ȃ��B

#include "ctype.as"

#define true  1
#define false 0

// ���������֐�

// �����p�}�N��
#define MPROC_DoUntil(%1=cntvar,%2=cond,%3=break,%4) repeat : if (%2) { break } %4 : if ( %1 < 0 ) { %3 } : loop

// p1 �̕ϐ����Ap2 �����藧�܂� �����E���� ������}�N��
#define MPROC_IncUntil(%1=cntvar,%2=cond,%3=break) MPROC_DoUntil %1,%2,%3,%1 ++
#define MPROC_DecUntil(%1=cntvar,%2=cond,%3=break) MPROC_DoUntil %1,%2,%3,%1 --

//##################################################################################################
//        �����񑀍�n
//##################################################################################################
/**
 * �������}������
 * p1 �̓r���ɕ������}�����܂��B
 * @prm p1 = var	: ������^�ϐ�
 * @prm p2 = int(0)	: �I�t�Z�b�g
 * @prm p3 = str	: �}�����镶����
 * @prm p4 = int(-1): p1 �̒����B�ȗ��\�B
 * @prm p5 = int(-1): p3 �̒����B�ȗ��\�B
 * @return = int	: ������̒���
 */
#define global StrInsert(%1,%2=0,%3,%4=-1,%5=-1) _StrInsert %1,%2,%3,%4,%5
#deffunc _StrInsert var p1, int p2, str p3, int p4, int p5
	
	if ( p4 < 0 ) { len(0) = strlen(p1) } else { len(0) = p4 }
	if ( p5 < 0 ) { len(1) = strlen(p3) } else { len(1) = p5 }
	if ( len(1) == 0 ) {           return len(0) }
	if ( len(0) == 0 ) { p1 = p3 : return len(1) }
	
	sdim stmp, len(1) + 1
	stmp = p3
	
	memexpand p1,       len(0) + len(1) + 1				// p1 ���L���� ( BufferOverflow ������邽�� )
	memcpy    p1,   p1, len(0) - p2, len(1) + p2, p2	// �S�̂����ɓ������Ap1 �̑O�ɋ�Ԃ����
	memcpy    p1, stmp, len(1)     ,          p2,  0	// �o������ԂɃR�s�[����
	poke      p1,       len(0) + len(1), 0				// �Ō�� NULL �Ŏ~�߂�
	
	return ( len(0) + len(1) )
	
/**
 * ��������폜����
 * p1 ����A�w��o�C�g�̕�������폜���܂��B
 * @prm p1 = var	: ������^�ϐ�
 * @prm p2 = int(0)	: �I�t�Z�b�g
 * @prm p3 = int	: �폜���钷��
 * @prm p4 = int(-1): p1 �̒����B�ȗ��\�B
 * @return = int	: ������̒���
 */
#define global StrDelete(%1,%2=0,%3,%4=-1) _StrDelete %1,%2,%3,%4
#deffunc _StrDelete var p1, int offset, int size, int p4
	
	if ( p4   < 0 ) { len = strlen(p1) } else { len = p4 }
	if ( size < 0 ) { return len }
	
	iSpace = len - (offset + size)					// ���ɏo����󔒂̑傫��
	
	memcpy p1, p1, iSpace, offset, offset + size	// �㏑�����R�s�[����
	memset p1,  0,   size, offset + iSpace			// ���ɏo�����󔒂𖄂߂�
	return (len - size)
	
/**
 * �����񂩂�O��̃X�y�[�X��^�u�A���s���������
 * ������^�ϐ� p1 ����O��̃X�y�[�X�ނ��폜���܂��B
 * 
 * ��stripstr �Ƃ������O�ł��g�p�ł��܂��B
 * @+ Blank �́A�X�y�[�X�A�^�u�A���s���w���B
 * @+ 2 �o�C�g������ 2 �o�C�g�ڂ��X�y�[�X�ނ̕����R�[�h�ɂȂ邱�Ƃ͂��肦�Ȃ�
 * @prm p1 = var	: ������^�ϐ�
 * @prm p2 = int(-1): p1 �̒����B�ȗ��\�B
 * @return = int	: ������������ p1 �̒���
 */
#define global StripBlanks(%1,%2=-1) _StripBlanks %1,%2
#deffunc _StripBlanks var p1, int p2
	
	if ( p2 < 0 ) { len = strlen(p1) } else { len = p2 }
	
	// �����̃u�����N
	p = len				// �`�F�b�N���镶���C���f�b�N�X
	repeat len
		p --
		c = peek(p1, p)
		if ( IsBlank(c) == false ) {
			p ++
			break	// �󔒂łȂ���ΏI���
		}
	loop
	
	memset p1, 0, len - p, p	// NULL �����ɂ���
	len  = p					// �����C���f�b�N�X�́A�u�擪 �` ��O�̕����v�̕�����̒����Ɠ���
	
	// �擪�̃u�����N
	for p, 0, len
		c = peek(p1, p)
		if ( IsBlank(c) == false ) { _break }
	next
	
	StrDelete p1, 0, p, len	// �O���̋󔒂��폜
	return stat				// �폜��̕����񒷂�Ԃ�
	
#define global stripstr StripBlanks

/**
 * �����񂩂�O��̈��p�����������
 * ������^�ϐ� p1 ����O��̈��p�����A�ʏ�͈���폜���܂��B
 * ''xxx'' �̂悤�ȕ�����́A'xxx' �ɂȂ�܂��B(������폜����̂�)
 * p3 ���^(0�ȊO)�̏ꍇ�A�O��̈��p�������ׂč폜���܂��B
 * 
 * ���̖��߂́A�O��̈��p���̐�������Ă��Ă��C�ɂ��܂���B
 * 
 * @prm p1 = var	: ������^�ϐ�
 * @prm p2 = int(-1): p1 �̒����B�ȗ��\�B
 * @prm p3 = bool(0): ���p����S���폜���邩
 * @return = int	: ������������ p1 �̒���
 */
#deffunc StripQuote var p1, int p2, int p3
	if ( p2 < 0 ) { len = strlen(p1) } else { len = p2 }
	
	if ( len <= 0 ) { return 0 }
	
	// �����̈��p��
	repeat ( p3 == 0 ) - ( p3 != 0 )	// p3 ���^�Ȃ疳�����[�v
		c = peek(p1, len - 1)
		if ( IsQuote(c) ) { len -- : poke p1, len, 0 } else { break }
	loop
	
	// �擪�̈��p��
	repeat ( p3 == 0 ) - ( p3 != 0 )	// p3 ���^�Ȃ疳�����[�v
		c = peek(p1)
		if ( IsQuote(c) ) { StrDelete p1, 0, 1, len : len = stat } else { break }
	loop
	return len
	
/**
 * ������𔽕�����
 * ��������w�肵���񐔔������܂��B
 * 0�ȉ��Ȃ�A�󕶎��񂪕Ԃ�܂��B
 * @prm p1 = str	: �Ώۂ̕�����
 * @prm p2 = int	: ��
 * @prm p3 = int	: p1 �̒���( �ȗ��\ )
 * @return = str	: p1 * p2
 */
#define global ctype strmul(%1="",%2=0,%3=-1) _strmul(%1,%2,%3)
#defcfunc _strmul str p1, int p2, int p3
	if ( p2 <= 0 ) { return "" }
	if ( p3 <  0 ) { len = strlen(p1) } else { len = p3 }
	
	sdim stmp, len + 1
	sdim sRet, len * p2 + 1
	stmp = p1
	
	repeat p2
		memcpy sRet, stmp, len, len * cnt
	loop
	return sRet
	
//##################################################################################################
//        ������ �����擾�n
//##################################################################################################
/**
 * ������؂���
 * ���������� p4 ���������Ap2 �� p3 ���炻�ꂪ����Ƃ���܂ł�؂�o���A�Ԃ��܂��B
 * �Ȃ������ꍇ�́Ap2 �́up3 �` �I�[�v��Ԃ��܂��B
 * @prm p1 = var	: �؂�������������󂯎��ϐ�
 * @prm p2 = var	: ������^�ϐ�
 * @prm p3 = int(0)	: �I�t�Z�b�g
 * @prm p4 = str	: �������镶����
 * @prm p5 = int(-1): p2 �̒����B�ȗ��\�B
 * @prm p6 = int(-1): p4 �̒����B�ȗ��\�B
 * @return = int	: �؂�����������̒���
 */
#define global StrCut(%1,%2,%3=0,%4,%5=-1,%6=-1) _StrCut %1,%2,%3,%4,%5,%6
#deffunc _StrCut var p1, var p2, int p3, str p4, int p5, int p6
	if ( p5 < 0 ) { len(0) = strlen(p2) } else { len(0) = p5 }
	if ( p6 < 0 ) { len(1) = strlen(p4) } else { len(1) = p6 }
	
	// ����
	i = instr(p2, p3, p4)
	if ( i < 0 ) {
		i = len(0) - p3		// ���ׂ�
	}
	
	// ���ʂ� p1 �ɃR�s�[����
	memexpand p1, i + 1			// �m�ۂł���T�C�Y�܂Ŋg������
	memcpy    p1, p2, i, 0, p3	// �R�s�[
	poke      p1, i, 0			// NULL�ŏI���
	return i
	
/**
 * n �o�C�g��̕�������擾
 * ������ p1 �́An byte ��΂����Ƃ��납��n�܂镶�����Ԃ��܂��B
 * @prm p1 = str	: ������
 * @prm p2 = int	: ���炷�o�C�g��
 * @prm p3 = int(-1): p1 �̒����B�ȗ��\
 * @return = str	: ���ʕ�����
 */
#define global ctype StrShift(%1,%2,%3=-1) _StrShift(%1,%2,%3)
#defcfunc _StrShift str p1, int nShift, int p3
	if ( p3 < 0 ) { len = strlen(p1) } else { len = p3 }
	sdim stmp, len + 1
	stmp = p1
	
	iSpace = len - nShift
	memcpy stmp, stmp, iSpace, 0, nShift
	memset stmp,    0, nShift, iSpace
	return stmp
	
/**
 * �����񂩂环�ʎq�����o��
 * ������ p2 �̃C���f�b�N�X p3 ���环�ʎq(�P�P��)�����o���܂��B
 * ���o�������ʎq��ϐ� p1 �Ɋi�[���A���̒�����Ԃ��܂��B
 * 
 * �擪�ɂ́A���p�A���t�@�x�b�g�� _ �ƑS�p�����A
 * �񕶎��ڈȍ~�͔��p�����������܂��B
 * 
 * ��scanident(p3, p1, p2) �Ƃ����`�̃}�N�����p�ӂ���Ă��܂��B
 * @prm p1 = var	: ���ʎq�̕�������i�[����ϐ�
 * @prm p2 = var	: ������^�ϐ�
 * @prm p3 = int	: ������̃C���f�b�N�X
 * @return = int	: ���ʎq�̒���(bytes)
 * 
 * @TODO : @ �ɂ��X�R�[�v�����͂ǂ�����H
 */
#defcfunc CutIdent var p1, var p2, int offset
	if ( vartype(p1) != vartype("str") ) { sdim p1, 64 }
	
	c = peek(p2, offset)
	if ( IsIdentTop(c) == false && IsSJIS1st(c) == false ) {
		poke p1
		return 0
	}
	repeat , offset + 1 + IsSJIS1st(c)
		// �񕶎��ڂ����
		c = peek(p2, cnt)
		if ( IsSJIS1st(c) ) { continue (cnt + 2) }	// �S�p����
		if ( IsIdent(c) == false ) {
			i = cnt - offset
			break
		}
	loop
	
	// �Ԓl�o�b�t�@�ɃR�s�[
	memcpy p1, p2, i, 0, offset
	poke   p1,  i, 0			// NULL�I�[�Ŏ~�߂�
;	p1 = strmid(p2, offset, i)
	return i
	
#define global ctype scanident(%1,%2=0,%3) TookIdent(%3,%1,%2)

// ���ʎq�̐擪�܂Ŗ߂�
#defcfunc BackToIdentTop var p1, int offset, int bIsLineSpace
	if ( offset <= 0 ) { return -1 }
	i = offset - 1
	
	// �󔒂��΂�( �O�ɂ���󔒗�̐擪�܂ňړ����� )
	MPROC_DecUntil i, IsSpace2(peek(p1, i), bIsLineSpace) == false
	if ( i < 0 ) { return -1 }
;	i ++
	
	if ( IsSpace2(peek(p1, i), bIsLineSpace) ) { i -- }
	
	// ���ʎq���΂�( ���ʎq�̐擪�܂� i �𓮂��� )
	MPROC_DecUntil i, IsIdent(peek(p1, i)) == false
	if ( i < 0 ) { i = 0 }
	i ++
	
	// ���l���X�L�b�v����( �擪�Ƃ��ĕs�K�؂Ȃ��΂� )
	MPROC_IncUntil i, IsIdentTop(peek(p1, i)) || peek(p1, i) == 0
	
	return offset - i
	
/**
 * ���̎��ʎq���擾����
 * ������̎w�肵���I�t�Z�b�g�̒��O�ɂ��鎯�ʎq�����o���܂��B
 * �I�t�Z�b�g�̂Ȃ��Ɏ��ʎq������ꍇ�́A��������o���܂��B
 * 
 * �s���܂��͕�����̓��܂ŁA���ʎq�������ł��Ȃ������ꍇ�A
 * �܂��́A�I�t�Z�b�g�ʒu����O�ɁA���ʎq�ł͂Ȃ��L����
 * ���������ꍇ�́A�󕶎���� p1 �ɕԂ��܂��B
 * 
 * ��scanidentb(p2, p3, p1, p4=0) �Ƃ����}�N�����g�p�ł��܂��B
 * @prm p1 = var	: ���ʎq�̕�������i�[����ϐ�
 * @prm p2 = var	: ������^�ϐ�
 * @prm p3 = int	: �I�t�Z�b�g�l
 * @prm p4 = bool	: ���s���󔒂Ƃ݂Ȃ���
 * @return = int	: ���ʎq�̒���(bytes)
 */
#defcfunc CutIdentBack var p1, var p2, int offset, int bIsLineSpace
	if ( offset <= 0 ) {
		poke p1
		return 0
	}
	return CutIdent( p1, p2, offset - BackToIdentTop(p2, offset, bIsLineSpace) )
	
//##################################################################################################
//        �������Ԏ擾�n
//##################################################################################################
/**
 * ������̎w��ʒu����󔒂ƃ^�u�̑����񐔂𐔂���
 * ������ p1 �̃C���f�b�N�X p2 ����󔒂ƃ^�u�̑����񐔂𐔂��܂��B
 * �������񐔂�Ԃ��܂��B
 * 
 * ��spnspace �Ƃ������O�ł��g�p�ł��܂��B
 * @prm p1 = var		: ������^�ϐ�
 * @prm p2 = int(0)		: ������̃C���f�b�N�X
 * @prm p3 = bool(0)	: ���s���󔒂ƌ��Ȃ���
 * @return = int		: �󔒂ƃ^�u�̑�����
 */
#defcfunc CntSpaces var p1, int p2, int bIsLineSpace
	i = p2
	while ( IsSpace(peek(p1, i)) || IsNewLine(peek(p1, i)) * (bIsLineSpace != 0) )
		i ++
	wend
	return i - p2
	
#define global spnspace CntSpaces		// �ʖ��œo�^
	
// �������ɋ󔒂̑�������Ԃ�
#defcfunc CntSpacesBack var p1, int p2
	if ( p2 == 0 ) { return 0 }
	i = p2 - 1
	MPROC_DecUntil i, IsSpace(peek(p1, i)) == false
	return p2 - i - 1
	
/**
 * �Q������̎w��ʒu���瓯�����e�̑����o�C�g���𐔂���
 * ������^�ϐ� p1 �̃C���f�b�N�X p3 �ƕ�����^�ϐ� p2 �̃C���f�b�N�X p4 ���瓯�����e�̑����o�C�g���𐔂��܂��B
 * @prm p1 = var	: ������^�ϐ�
 * @prm p2 = var	: ������^�ϐ�
 * @prm p3 = int(0)	: p1 �̃C���f�b�N�X
 * @prm p4 = int(0)	: p3 �̃C���f�b�N�X
 * @return = int	: �������e�̑����o�C�g��
 */
#defcfunc StrSameBytes var p1, var p2, int p3, int p4
	i = 0
	repeat
		c = peek(p1, p3 + i)
		if ( c != peek(p2, p4 + i) || c == 0 ) {
			break
		}
		i ++
	loop
	return i
	
/**
 * �Q������̎w��ʒu����w��o�C�g���������񂪑�����
 * ������^�ϐ� p1 �̃C���f�b�N�X p4 �ƕ�����^�ϐ� p2 �̃C���f�b�N�X p5 ����Ap3 �o�C�g�������e�����������ׂ܂��B
 * @prm p1 = var	: ������^�ϐ�
 * @prm p2 = var	: ������^�ϐ�
 * @prm p3 = int	: �o�C�g��
 * @prm p4 = int(0)	: p1 �̃C���f�b�N�X
 * @prm p5 = int(0)	: p3 �̃C���f�b�N�X
 * @return = bool	: �����Ȃ�^
 */
#defcfunc StrCompNum var p1, var p2, int p3, int p4, int p5
	ret = 1		// �^�ɐݒ�
	repeat p3
		c = peek(p1, p4 + cnt)
		if ( c != peek(p2, p5 + cnt) ) {
			ret = 0
			break
		}
	loop
	return ret
	
/**
 * �w�ʕ�����T��(���j�A�T�[�`)
 * �������ɕ�������������܂��B
 * �g�����͂قƂ�� instr() �֐��Ɠ����ł����A
 * instrb()�֐����Ԃ��C���f�b�N�X�l�́A�I�t�Z�b�g�Ɗ֌W�Ȃ��̂�
 * �C�����Ă��������B
 * 
 * �I�t�Z�b�g�́A�ʏ�ʂ�O���琔���܂��B
 * ��납��̃I�t�Z�b�g�́A(�S�̂̒��� - �O����̃I�t�Z�b�g - 1)
 * �ŎZ�o�ł��܂��B
 * @prm p1 = var	: �����Ώە�����^�ϐ�
 * @prm p2 = int(0)	: �I�t�Z�b�g
 * @prm p3 = str	: �������镶����
 * @prm p4 = int(-1): p1 �̒����B�ȗ��\
 * @prm p5 = int(-1): p3 �̒����B�ȗ��\
 * @return = int	: ���������ʒu�̃C���f�b�N�X���A����
 * @algorithm		: Linear Search
 */
#define global ctype instrb(%1,%2=0,%3,%4=-1,%5=-1) _instrb(%1,%2,%3,%4,%5)
#defcfunc _instrb var p1, int offset, str p3, int p4, int p5
	if ( p4 < 0 ) { len(0) = strlen(p1) } else { len(0) = p4 }
	if ( p5 < 0 ) { len(1) = strlen(p3) } else { len(1) = p5 }
	
	// ��납��T��
	sdim stmp, len(1) + 1
	stmp = p3
	i    = len(0) - offset - 1
	c    = peek(stmp)
	
	while ( i >= 0 )
		// �擪�����̔�r�ō���������
		if ( peek(p1, i) == c ) {
			// ����?
			if ( strmid(p1, i, len(1)) == stmp ) {
				return i
			}
		}
		i --
	wend
	
	// �����ł��Ȃ�����
	return -1
	
#global

//######## �T���v���E�v���O���� ################################################
#if 0

#undef        print
#define ctype print(%1=s) mes "[%1] = ["+ (%1) +"]"

	t = "01234567890123456789012345678901234567890"
	s = "0123456789ABCDEF"
	print(t)
	print(s)
	
	StrDelete s, 2, 4
	mes "length : stat = "+ stat +", strlen = "+ strlen(s)
	print(s)
	
	stop
	
#endif

#endif

#if 0
	t = "01234567890123456789012345678901234567890"
	s = "/* */    UINT WINAPI func(argument_type) { ...; }"
	
	i = 15
	m = BackToIdentTop(s, i)
	mes m
	mes i - m
	mes CutIdentBack(v, s, i)
	mes v
#endif
