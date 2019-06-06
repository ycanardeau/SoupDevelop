// HSP parse module - CutToken

#ifndef __HSP_PARSE_MODULE_CUT_TOKEN_AS__
#define __HSP_PARSE_MODULE_CUT_TOKEN_AS__

//##############################################################################
//                識別子切り出しモジュール
//##############################################################################
#module hpmod_cutToken

#include "HPM_header.as"

//------------------------------------------------
// エスケープシーケンス付き切り出し
//------------------------------------------------
#define FTM_CutTokenInEsqSec(%1,%2,%3) /* %1 = オフセット, %2 = 終了条件 */\
	i = (%1) :\
	repeat :\
		c = peek(sSrc, iOffset + i) : i ++ :\
		if ( c == '\\' || IsSJIS1st(c) ) {		/* 次も確実に書き込む */\
			i ++ :\
		}\
		if ( %2 ) { break }/* 終了 */\
	loop :\
	return strmid(sSrc, iOffset, i)
	
//------------------------------------------------
// 文字列か文字定数を切り出す
//------------------------------------------------
#defcfunc CutStr_or_Char var sSrc, int iOffset, int p3
	FTM_CutTokenInEsqSec 1, ( c == p3 || IsNewLine(c) || c == 0 )
	
//------------------------------------------------
// 　文字列を切り出して返す
// ＆文字定数を切り出して返す
//------------------------------------------------
#define global ctype CutStr(%1,%2=0) CutStr_or_Char(%1,%2,'"')
#define global ctype CutCharactor(%1,%2=0) CutStr_or_Char(%1,%2,'\'')

//------------------------------------------------
// 複数行文字列を切り出して返す
//------------------------------------------------
#defcfunc CutStrMulti var sSrc, int iOffset
	FTM_CutTokenInEsqSec 2, ( peek(sSrc, iOffset + i - 2) == '"' && c == '}' || c == 0 )
	
//------------------------------------------------
// 文字列か文字定数の中身を切り出す
//------------------------------------------------
#define _c2 peek(sSrc, iOffset + i)
#defcfunc CutStr_or_Char_inner var sSrc, int prm_iOffset, int p3,  local iOffset
	iOffset = prm_iOffset + 1
	FTM_CutTokenInEsqSec 1, ( _c2 == p3 || IsNewLine(_c2) || c == 0 )
	
//------------------------------------------------
// 　文字列の中身を切り出して返す
// ＆文字定数の中身を切り出して返す
//------------------------------------------------
#define global ctype CutStrInner(%1,%2=0) CutStr_or_Char_inner(%1,%2,'"')
#define global ctype CutCharactorInner(%1,%2=0) CutStr_or_Char_inner(%1,%2,'\'')

#undef _c2

//------------------------------------------------
// 範囲の違う「トークン」を切り出して返す
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
// 空白を切り出して返す
//------------------------------------------------
#defcfunc CutSpace var sSrc, int iOffset
	FTM_CutToken ( IsSpace(c) )
	
//------------------------------------------------
// 識別子を切り出して返す
//------------------------------------------------
#defcfunc CutName var sSrc, int iOffset
	FTM_CutToken ( IsIdent(c) || IsSJIS1st(c) || c == '`' ), IsSJIS1st(c)
	
//------------------------------------------------
// 16進数を切り出して返す
//------------------------------------------------
#defcfunc CutNum_Hex var sSrc, int iOffset
	FTM_CutToken ( IsHex(c) || c == '_' )
	
//------------------------------------------------
// 2進数を切り出して返す
//------------------------------------------------
#defcfunc CutNum_Bin var sSrc, int iOffset
	FTM_CutToken ( IsBin(c) || c == '_' )
	
//------------------------------------------------
// 10進数を切り出して返す
//------------------------------------------------
#defcfunc CutNum_Dgt var sSrc, int iOffset
	FTM_CutToken ( IsDigit(c) || c == '.' || c == '_' )
	
#global

#endif
