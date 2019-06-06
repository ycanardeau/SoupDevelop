// HSP parse module - CutToken

#ifndef __HSP_PARSE_MODULE_CUT_TOKEN_AS__
#define __HSP_PARSE_MODULE_CUT_TOKEN_AS__

//##############################################################################
//                ���ʎq�؂�o�����W���[��
//##############################################################################
#module hpmod_cutToken

#include "HPM_header.as"

//------------------------------------------------
// �G�X�P�[�v�V�[�P���X�t���؂�o��
//------------------------------------------------
#define FTM_CutTokenInEsqSec(%1,%2,%3) /* %1 = �I�t�Z�b�g, %2 = �I������ */\
	i = (%1) :\
	repeat :\
		c = peek(sSrc, iOffset + i) : i ++ :\
		if ( c == '\\' || IsSJIS1st(c) ) {		/* �����m���ɏ������� */\
			i ++ :\
		}\
		if ( %2 ) { break }/* �I�� */\
	loop :\
	return strmid(sSrc, iOffset, i)
	
//------------------------------------------------
// �����񂩕����萔��؂�o��
//------------------------------------------------
#defcfunc CutStr_or_Char var sSrc, int iOffset, int p3
	FTM_CutTokenInEsqSec 1, ( c == p3 || IsNewLine(c) || c == 0 )
	
//------------------------------------------------
// �@�������؂�o���ĕԂ�
// �������萔��؂�o���ĕԂ�
//------------------------------------------------
#define global ctype CutStr(%1,%2=0) CutStr_or_Char(%1,%2,'"')
#define global ctype CutCharactor(%1,%2=0) CutStr_or_Char(%1,%2,'\'')

//------------------------------------------------
// �����s�������؂�o���ĕԂ�
//------------------------------------------------
#defcfunc CutStrMulti var sSrc, int iOffset
	FTM_CutTokenInEsqSec 2, ( peek(sSrc, iOffset + i - 2) == '"' && c == '}' || c == 0 )
	
//------------------------------------------------
// �����񂩕����萔�̒��g��؂�o��
//------------------------------------------------
#define _c2 peek(sSrc, iOffset + i)
#defcfunc CutStr_or_Char_inner var sSrc, int prm_iOffset, int p3,  local iOffset
	iOffset = prm_iOffset + 1
	FTM_CutTokenInEsqSec 1, ( _c2 == p3 || IsNewLine(_c2) || c == 0 )
	
//------------------------------------------------
// �@������̒��g��؂�o���ĕԂ�
// �������萔�̒��g��؂�o���ĕԂ�
//------------------------------------------------
#define global ctype CutStrInner(%1,%2=0) CutStr_or_Char_inner(%1,%2,'"')
#define global ctype CutCharactorInner(%1,%2=0) CutStr_or_Char_inner(%1,%2,'\'')

#undef _c2

//------------------------------------------------
// �͈͂̈Ⴄ�u�g�[�N���v��؂�o���ĕԂ�
//------------------------------------------------
#define FTM_CutToken(%1,%2=0) \
	i = iOffset :\
	repeat :\
		c = peek(sSrc, i) :\
		if ((%1) == false || c == 0) { break } \
		if (%2) { i ++ }\
		i ++ :\
	loop :\
	return strmid(sSrc, iOffset, i - iOffset)
	
//------------------------------------------------
// �󔒂�؂�o���ĕԂ�
//------------------------------------------------
#defcfunc CutSpace var sSrc, int iOffset
	FTM_CutToken ( IsSpace(c) )
	
//------------------------------------------------
// ���ʎq��؂�o���ĕԂ�
//------------------------------------------------
#defcfunc CutName var sSrc, int iOffset
	FTM_CutToken ( IsIdent(c) || IsSJIS1st(c) || c == '`' ), IsSJIS1st(c)
	
//------------------------------------------------
// 16�i����؂�o���ĕԂ�
//------------------------------------------------
#defcfunc CutNum_Hex var sSrc, int iOffset
	FTM_CutToken ( IsHex(c) || c == '_' )
	
//------------------------------------------------
// 2�i����؂�o���ĕԂ�
//------------------------------------------------
#defcfunc CutNum_Bin var sSrc, int iOffset
	FTM_CutToken ( IsBin(c) || c == '_' )
	
//------------------------------------------------
// 10�i����؂�o���ĕԂ�
//------------------------------------------------
#defcfunc CutNum_Dgt var sSrc, int iOffset
	FTM_CutToken ( IsDigit(c) || c == '.' || c == '_' )
	
#global

#endif
