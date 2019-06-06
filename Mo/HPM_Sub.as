// HSP parse module - Sub

#ifndef __HSP_PARSE_MODULE_SUB_AS__
#define __HSP_PARSE_MODULE_SUB_AS__

#include "strutil.as"

//##############################################################################
//                サブ・モジュール
//##############################################################################
#module hpm_sub

#include "HPM_header.as"		// ヘッダファイルを読み込む

//------------------------------------------------
// 初期化関数
//------------------------------------------------
#deffunc hpm_sub_initialize@hpm_sub
	keylist_all       = ","+ KEYWORDS_ALL
	keylist_statement = ","+ KEYWORDS_STATEMENT
	keylist_function  = ","+ KEYWORDS_FUNCTION
	keylist_sysvar    = ","+ KEYWORDS_SYSVAR
	keylist_preproc   = ","+ KEYWORDS_PREPROC
	keylist_macro     = ","+ KEYWORDS_MACRO
	keylist_modname   = ","+ KEYWORDS_MODNAME
	keylist_ppword    = ","+ KEYWORDS_PPWORD
	return
	
//------------------------------------------------
// 次はラベルか？
// 
// @ 条件 :=
//   　 * から始まり、
//   　その次が「文の終端 or ',' or ')'」のどれか
//------------------------------------------------
#defcfunc IsLabel var p1, int p2, int p_befTT, int bPreLine,  local c, local c2, local stmp, local i
	
	// 最低限のチェック
	if ( peek(p1, p2    ) != '*' ) { return false }		// もはやラベルではない
	if ( peek(p1, p2 + 1) == '@' ) { return true  }		// ローカルラベル
	if ( peek(p1, p2 + 1) == '%' && bPreLine ) {
		c2 = peek(p1, p2 + 2)
		switch ( c2 )
			// 特殊展開マクロ
			case 'n' : case 'i' : case 'p' : case 'o'
				swbreak
			default
				// または マクロ引数
				if ( IsDigit(c2) && c2 != '0' ) {
					swbreak
				}
				return false
		swend
		return true
	}
	
	// ラベルの前を調べる
	switch p_befTT
		case TKTYPE_END
		case TKTYPE_OPERATOR
		case TKTYPE_CIRCLE_L
		case TKTYPE_KEYWORD
		case TKTYPE_COMMA
		case TKTYPE_MACRO_PRM
		case TKTYPE_MACRO_SP
			// 無条件に OK
			swbreak
			
		case TKTYPE_VARIABLE
		case TKTYPE_NAME
			// ラベルの前の識別子が、文頭にある or goto / gosub ならＯＫ
			i  = p2
			i -= CntSpacesBack( p1, i )
			m  = BackToIdentTop(p1, p2)
			if ( m < 0 ) { return false }	// 前が識別子ではない (異常？)
			i -= m
			
;			// ここで、goto gosub なら OK
;			stmp = getpath( CutName(p1, i + 1), 16 )
;			if ( stmp == "gosub" || stmp == "goto" ) {
;				swbreak
;			}
			
			i -= CntSpacesBack( p1, i )		// 空白 ignore
			i --							// ラベルの前の前
			if ( i < 0 ) { swbreak }
			c  = peek(p1, i)
			if ( IsNewLine(c) || c == ':' || c == '{' || c == '}' ) {
				swbreak
			}
			return false
			
		default
			// 予約語も OK
			if ( IsTkTypeReserved(p_befTT) ) {
				swbreak
			}
			
			// その他ならダメ
			return false
	swend
	
	// ラベル名を飛ばす
	c = peek(p1, p2 + 1)
	if ( IsIdentTop(c) == false ) { return false }	// 次が識別子の先頭でなければ×
	i = p2 + 2
	repeat
		c = peek(p1, i)
		if ( IsIdent(c) == false ) {
			break
		}
		i ++
	loop
	
	// ラベルの後を調べる
	while
		i += CntSpaces(p1, i)	// 空白をスキップ
		c  = peek(p1, i)		// ラベルの次
		
		if ( c == '/' ) {
			c2 = peek(p1, i + 1)
			if ( c2 == '/' ) { return true }		// ダブル・スラッシュのコメント
			if ( c2 == '*' ) {						// 複数行コメント開始
				iFound = instr(p1, i + 2, "*/")		// 終了地点を探す
				if ( iFound >= 0 ) {
					i += 4 + iFound					// /**/ + 距離
					_continue						// もう一度「ラベルの次」をチェックする
				}
			}
		} else : if ( c == '@' ) {
			// スコープ名をスキップ
			do
				i ++
				c = peek(p1, i)
			until ( IsIdent(c) == false )
			_continue
		}
		_break
	wend
	
	// ;:{}), 改行文字 NULL でなければ×
	if ( c != NULL && (c == ';' || c == ':' || c == '{' || c == '}' || c == ')' || c == ',' || c == 0x0D || c == 0x0A) == false ) {
		return false
	}
	return true
	
//------------------------------------------------
// 命令か？ ( p1 に無駄な記号や空白があると、偽 )
//------------------------------------------------
#defcfunc IsStatement str p1
	return ( instr( keylist_statement, 0, ","+ getpath(p1, 16) +"," ) >= 0 )
	
//------------------------------------------------
// 関数か？ ( p1 に無駄な文字があると、偽 )
//------------------------------------------------
#defcfunc IsFunction str p1
	return ( instr( keylist_function, 0, ","+ getpath(p1, 16) +"," ) >= 0 )
	
//------------------------------------------------
// システム変数か？
//------------------------------------------------
#defcfunc IsSysvar str p1
	return ( instr( keylist_sysvar, 0, ","+ getpath(p1, 16) +"," ) >= 0 )
	
//------------------------------------------------
// マクロか？
//------------------------------------------------
#defcfunc IsMacro str p1
	return ( instr( keylist_macro, 0, ","+ getpath(p1, 16) +"," ) >= 0 )
	
//------------------------------------------------
// プリプロセッサ命令か？
//------------------------------------------------
#defcfunc IsPreproc str p1
	return ( instr( keylist_preproc, 0, ","+ CutPreprocIdent(p1) +"," ) >= 0 )
	
//------------------------------------------------
// プリプロセッサ行キーワードか？
//------------------------------------------------
#defcfunc IsPreprocWord str p1
	return ( instr( keylist_ppword, 0, ","+ getpath(p1, 16) +"," ) >= 0 )
	
//------------------------------------------------
// プリプロセッサ命令の識別子の部分を取り出す
//------------------------------------------------
#defcfunc CutPreprocIdent str p1,  local stmp
	stmp = getpath(p1, 16)
	stmp = strmid( stmp, 1 + CntSpaces( stmp, 1 ), strlen(stmp) )
	return stmp
	
#global
hpm_sub_initialize@hpm_sub

#endif

//##################################################################################################
#if 0
/*
#deffunc _init
	sSings = SIGN
	return
	
//------------------------------------------------
// 区切り文字か？
//------------------------------------------------
#defcfunc IsSign int p1
	return ( instr(sSigns, 0, strf("%c", p1)) >= 0 )
	
//------------------------------------------------
// 単語単位で分けられているか？
//------------------------------------------------
#defcfunc IsIndependentWord var p1, int p2, int wordlen
	// 前はＯＫか？
	if ( p2 ) {
		if ( IsSign( peek(p1, p2 - 1) ) == false ) { return false }
	}
	// 後ろはＯＫか？
	if ( IsSign(peek(p1, p2 + wordlen)) == false ) { return false }
	return true
	
//------------------------------------------------
// 完全一致か？
//------------------------------------------------
#defcfunc IsCompleteLength var p1, int p2
	if (         p2 !=        0 ) { return false }
	if ( strlen(p1) != MatchLen ) { return false }
	return true
	
//------------------------------------------------
// 命令か？ ( p1 に無駄な記号や空白があると失敗 )
//------------------------------------------------
#defcfunc IsStatement var p1, local stmp
	n = instrCom( p1, 0, STATE1, 1 ) : if ( IsCompleteLength(p1, n) ) { return true }
	n = instrCom( p1, 0, STATE2, 1 ) : if ( IsCompleteLength(p1, n) ) { return true }
	n = instrCom( p1, 0, STATE3, 1 ) : if ( IsCompleteLength(p1, n) ) { return true }
	n = instrCom( p1, 0, STATE4, 1 ) : if ( IsCompleteLength(p1, n) ) { return true }
	return false
	
//------------------------------------------------
// 関数か？ ( p1 に無駄な文字があると失敗 )
//------------------------------------------------
#defcfunc IsFunction var p1
	n = instrCom( p1, 0, FUNC, 1 )		// 大文字・小文字を厭(いと)わない
	return IsCompleteLength(p1, n)
	
//------------------------------------------------
// システム変数か？
//------------------------------------------------
#defcfunc IsSysvar var p1
	n = instrCom( p1, 0, SYSVAR, 1 )
	return IsCompleteLength(p1, n)
	
//------------------------------------------------
// マクロか？
//------------------------------------------------
#defcfunc IsMacro var p1
	n = instrCom( p1, 0, MACRO1, 1 ) : if ( IsCompleteLength(p1, n) ) { return true }
	n = instrCom( p1, 0, MACRO2, 1 ) : if ( IsCompleteLength(p1, n) ) { return true }
	return false
	
//------------------------------------------------
// プリプロセッサ命令か？
//------------------------------------------------
#defcfunc IsPreproc var p1
	n = instrCom( p1, 0, PRE )
	return IsCompleteLength(p1, n)
	
//------------------------------------------------
// プリプロセッサ行キーワードか？
//------------------------------------------------
#defcfunc IsPreprocWord var p1
	n = instrCom( p1, 0, FUNCWORD, 1 )
	return IsCompleteLength(p1, n)
	
*/
#endif
