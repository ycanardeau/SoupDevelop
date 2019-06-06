// HSP parse module - split

#ifndef __HSP_PARSE_MODULE_SPLIT_AS__
#define __HSP_PARSE_MODULE_SPLIT_AS__

#include "strutil.as"
#include "HPM_sub.as"
#include "HPM_getToken.as"

#module hpmod_split

#include "HPM_header.as"

#define true  1
#define false 0

#define global HPM_SPLIT_FLAG_NONE			0x0000		// 
#define global HPM_SPLIT_FLAG_NO_BLANK		0x0001		// TKTYPE_BLANK を無視する
#define global HPM_SPLIT_FLAG_NO_COMMENT	0x0002		// TKTYPE_BOMMENT を無視する
#define global HPM_SPLIT_FLAG_NO_RESERVED	0x0004		// TKTYPE_NAME が予約語かどうかの判定をしない
;#define global HPM_SPLIT_FLAG_
;#define global HPM_SPLIT_FLAG_
;#define global HPM_SPLIT_FLAG_

//------------------------------------------------
// スクリプト分解
// 
// @prm tktypelist = int[] : TKTYPE の配列
// @prm tkstrlist  = str[] : トークン文字列の配列
// @prm script     = str   : スクリプト
//------------------------------------------------
#deffunc hpm_split array tktypelist, array tkstrlist, str prm_script, int fSplit,  local script, local lenScript, local cntToken, local tkstr, local tktype, local bPreprocLine, local index, local befTkType, local bNoBlank, local bNoComment, local bNoReserved
	sdim tkstr
	dim  tktype
	
	dim tktypelist
	sdim tkstrlist
	
	bPreprocLine  = false
	script    = prm_script
	lenScript = strlen(script)
	index     = 0
	tktype    = TKTYPE_END
	befTkType = TKTYPE_END
	cntToken  = 0
	
	bNoBlank    = ( fSplit & HPM_SPLIT_FLAG_NO_BLANK    ) != false
	bNoComment  = ( fSplit & HPM_SPLIT_FLAG_NO_COMMENT  ) != false
	bNoReserved = ( fSplit & HPM_SPLIT_FLAG_NO_RESERVED ) != false
	
	repeat
		// 最後まで取得したら終了する
		if ( lenScript <= index ) { break }
		
		// 次のトークンを取得
		hpm_getNextToken tkstr, script, index, befTkType, bPreprocLine
		tktype = stat
		index += strlen(tkstr)
		
		if ( ( bNoBlank && tktype == TKTYPE_BLANK ) || ( bNoComment && tktype == TKTYPE_COMMENT ) ) {
			continue
		}
		
		cntToken ++
		
;		if ( tktype == TKTYPE_ERROR ) {
;			cntToken = -1
;			break
;		}
		
;		logmes "type\t= "+ tktype
;		logmes "str\t= "+  tkstr
;		logmes "beftype\t= "+ befTkType
;		logmes "index\t= "+ index
;		logmes ""
		
		tktypelist(cntToken) = tktype
		tkstrlist (cntToken) = tkstr
		
		// トークンごとに必須の処理
		gosub *LProcToken
		
		// 更新
		befTkType = tktype
	loop
	
	return cntToken
	
*LProcToken
	switch ( tktype )
		
		// 空白 or コメント
		case TKTYPE_BLANK
		case TKTYPE_COMMENT
			tktype = befTkType
			swbreak
			
		// 文の終了
		case TKTYPE_END
			if ( bPreprocLine && IsNewLine( peek(tkstr) ) ) {	// 改行なら
				bPreprocLine = false
			}
			swbreak
			
		// プリプロセッサ命令
		case TKTYPE_PREPROC
			if ( IsPreproc(tkstr) ) {
				bPreprocLine = true
			} else {
				tktype               = TKTYPE_PREPROC_DISABLE
				tktypelist(cntToken) = tktype
			}
			swbreak
			
		// 識別子
		case TKTYPE_NAME
			if ( bNoReserved ) { swbreak }
			
			// プリプロセッサ行キーワードか
			if ( bPreprocLine ) {
				if ( IsPreprocWord( tkstr ) ) {
					tktype = TKTYPE_EX_PREPROC_KEYWORD
					goto *LChangeTkTypeList
				}
			}
			
			// 標準命令
			if ( IsStatement( tkstr ) ) {
				tkType = TKTYPE_EX_STATEMENT
				
			// 標準関数
			} else : if ( IsFunction( tkstr ) ) {
				tkType = TKTYPE_EX_FUNCTION
				
			// システム変数
			} else : if ( IsSysvar( tkstr ) ) {
				tktype = TKTYPE_EX_SYSVAR
				
			// 標準マクロ
			} else : if ( IsMacro( tkstr ) ) {
				tktype = TKTYPE_EX_MACRO
				
			// それ以外
			} else {
;				tktype = TKTYPE_NAME
			}
			
			// 配列に指定した値を変更する
		:*LChangeTkTypeList
			tktypelist(cntToken) = tktype
			swbreak
			
	swend
	
	return
	
#global

//##############################################################################
//                テスト
//##############################################################################
#if 0

#include "MCLongString.as"

	s = {"
		// 識別子を切り出して返す
		#defcfunc CutName var sSrc, int iOffset,  local n
			FTM_CutToken ( IsIdent(c) || IsSJIS1st(c) || c == '`' ), IsSJIS1st(c)
			return
	"}
	
	LongStr_new ls
	
	hpm_split tktypelist, tkstrlist, s
	foreach tktypelist
		
		LongStr_add ls, "type\t= "+ tktypelist(cnt) +"\n"
		LongStr_add ls, "str\t= "+  tkstrlist (cnt)  +"\n"
		LongStr_add ls, "\n"
		
	loop
	
	LongStr_toBuf  ls, buf
	LongStr_delete ls
	
	objmode 2
	font msgothic, 12
	mesbox buf, ginfo(12), ginfo(13)
	stop
	
#endif
