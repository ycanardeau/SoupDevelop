// HSP parse module - GetToken

#ifndef __HSP_PARSE_MODULE_GET_TOKEN_AS__
#define __HSP_PARSE_MODULE_GET_TOKEN_AS__

#include "HPM_cutToken.as"	// 識別子取り出し
#include "HPM_sub.as"		// モジュール

// 主要モジュール
#module hpm_getToken

#include "HPM_header.as"

#uselib "user32.dll"
#func   CharLower@hpm_getToken "CharLowerA" int

//------------------------------------------------
// マクロ
//------------------------------------------------
#define ctype IsWOp(%1) ((%1) == '<' || (%1) == '=' || (%1) == '>' || (%1) == '&' || (%1) == '|' || (%1) == '+' || (%1) == '-')

#define NULL 0

//------------------------------------------------
// 次のトークンを取得する
//------------------------------------------------
#deffunc hpm_getNextToken var result, var sSrc, int index, int p_befTT, int bPreLine
	c = peek(sSrc, index)
	
	// 空白 (Blank)
	if ( IsSpace(c) ) {
		result = CutSpace(sSrc, index)
		return TKTYPE_BLANK
	}
	
	// 識別子 (Identifier)
	if ( IsIdentTop(c) || c == '`' || IsSJIS1st(c) ) {
		result = CutName(sSrc, index)
		return TKTYPE_NAME
	}
	
	// プリプロセッサ命令 (Preprocessor)
	if ( c == '#' ) {
		iFound = 1 + CntSpaces(sSrc, index + 1)		// 空白
		result = strmid(sSrc, index, iFound) + CutName(sSrc, index + iFound)
		return TKTYPE_PREPROC
	}
	
	// 文字列定数 (Single-line String Literal)
	if ( c == '"' ) {
		result = CutStr(sSrc, index)			// 文字列を取り出す (""を含む)
		return TKTYPE_STRING
	}
	
	// 複数行文字列定数 (Multi-line String Literal)
	if ( wpeek(sSrc, index) == 0x227B ) {		// {"
		result = CutStrMulti(sSrc, index)		// 複数行文字列を取り出す ({" "} 含む)
		return TKTYPE_STRING
	}
	
	// 終了記号
	if ( c == ':' || c == '{' || c == '}' || IsNewLine(c) || c == 0 ) {
		result = strf("%c", c)
		if ( c == 0x0D ) {		// CRLF
			if ( peek(sSrc, index + 1) == 0x0A ) {
				result = "\n"
			}
		} else : if ( c == 0x0A ) {
			result = "\r"
		}
		return TKTYPE_END
	}
	
	// 記号 (Sign)
	if ( c == ',' ) { result = "," : return TKTYPE_COMMA    }
	if ( c == '(' ) { result = "(" : return TKTYPE_CIRCLE_L }
	if ( c == ')' ) { result = ")" : return TKTYPE_CIRCLE_R }
	if ( c == '.' ) { result = "." : return TKTYPE_PERIOD   }
	
	// ラベル (Label) := * から始まり、次が「文の終端、カンマ、')'」のどれか
	if ( c == '*' ) {
		if ( IsLabel(sSrc, index, p_befTT, bPreline) ) {
			c2 = peek(sSrc, index + 1)
			if ( c2 == '@' ) {
				result = "*@"+ CutName(sSrc, index + 2)		// *@ の後は好きなだけ取り出す
			} else : if ( c2 == '%' ) {						// *%
				result = "*%"+ CutName(sSrc, index + 2)
			} else {
				result = "*"+ CutName(sSrc, index + 1)		// 切り出す
			}
			return TKTYPE_LABEL
		}
	}
	
	// 行末コメント (Single-line Comment)
	if ( c == ';' || wpeek(sSrc, index) == 0x2F2F ) {
		getstr result, sSrc, index			// 改行まで取り出す
		return TKTYPE_COMMENT
	}
	
	// 複数行コメント (Multi-line Comment)
	if ( wpeek(sSrc, index) == 0x2A2F ) {
		iFound = instr(sSrc, index + 2, "*/")
		if ( iFound < 0 ) {
			result = strmid(sSrc, index, strlen(sSrc) - index)	// 以降すべてコメント
		} else {
			result = strmid(sSrc, index, iFound + 4)			// 開始・終了も含む
		}
		return TKTYPE_COMMENT
	}
	
	// 演算子 (Operator)
	if ( IsOperator(c) ) {
		
		// 2 バイトの演算子の時もある ( ?= か、&& || などの二重 )
		c2 = peek(sSrc, index + 1)
		if ( c2 == '=' || ( IsWOp(c) && c == c2 ) ) {
			result = strmid(sSrc, index, 2)	// 2 byte
		} else {
			wpoke result, , c			// 1 byte
		}
		if ( c == '\\' && bPreLine ) {	// 改行回避の可能性
			if ( IsNewLine(c2) ) {
				if ( c2 == 0x0D && peek(sSrc, index + 2) == 0x0A ) {
					lpoke result,, MAKELONG2('\\', 0x0D, 0x0A, 0)	// "\\\n"
				} else {
					lpoke result,, MAKEWORD('\\', c2)
				}
				return TKTYPE_ESC_LINEFEED
			}
		}
		return TKTYPE_OPERATOR
	}
	
	// 文字定数 (Charactor Literal)
	if ( c == '\'' ) {
		result = CutCharactor(sSrc, index)
		return TKTYPE_CHAR
	}
	
	// 整数値定数( 2 or 16 進数 ) (Binary or Hexadigimal Number)
	if ( c == '$' ) {
		result = "$"+ CutNum_Hex(sSrc, index + 1)
		return TKTYPE_NUMBER
	}
	if ( c == '%' ) {
		c2 = peek(sSrc, index + 1)
		
		if ( bPreLine ) {
			// 二進数表記 ( %%010101 ... etc )
			if ( c2 == '%' && IsBin(peek(sSrc, index + 2)) ) {
				result = "%"+ CutNum_Bin(sSrc, index + 1)
				return TKTYPE_NUMBER
				
			// マクロ引数 ( %1, %2, %3 ... etc )
			} else : if ( IsDigit(c2) && c2 != '0' ) {
				result = "%"+ CutNum_Dgt(sSrc, index + 1)
				return TKTYPE_MACRO_PRM
				
			// 特殊展開マクロ ( %i, %s1 ... etc )
			} else : if ( IsAlpha(c2) ) {
				result = "%"+ CutName(sSrc, index + 1)
				return TKTYPE_MACRO_SP
			}
		}
		
		// 二進数表記
		result = "%"+ CutNum_Bin(sSrc, index + 1)
		return TKTYPE_NUMBER
	}
	
	if ( c == '0' ) {
		c2 = peek(sSrc, index + 1)
		if ( c2 == 'x' || c2 == 'X' ) {
			result = strmid(sSrc, index, 2) + CutNum_Hex(sSrc, index + 2)
			
		} else : if ( c2 == 'b' || c2 == 'B' ) {
			result = strmid(sSrc, index, 2) + CutNum_Bin(sSrc, index + 2)
			
		} else {
			gosub *LGetToken_Digit
			return stat
		}
		return TKTYPE_NUMBER
	}
	
	// 整数値定数(10進数) (Digimal Number)
	if ( IsDigit(c) || c == '.' ) {
		gosub *LGetToken_Digit
		return stat
	}
	
	// スコープ解決 (scope solver)
	if ( c == '@' ) {
		result = "@"+ CutName(sSrc, index + 1)
		return TKTYPE_SCOPE
	}
	
	// 謎な場合
*LUnknownToken
	if ( IsSJIS1st(c) ) {
		logmes "ERROR! SJIS code!"
		wpoke result, 0, wpeek(sSrc, index)	// 書き込む
		poke  result, 3, NULL
		return TKTYPE_ERROR
	}
	
	// ？？？
	result = strf("%c", c)
	logmes "ERROR !! Can't Pop a Token! [ "+ index + strf(" : %c : ", c) + c +" ]"
	return TKTYPE_ERROR
	
// 10進数を切り出す
*LGetToken_Digit
	result = CutNum_Dgt(sSrc, index)
	len    = strlen(result)
	c      = peek( sSrc, index + len )		// 数の次の文字
	switch ( c )
		case 'f'
		case 'd'
			result += strf("%c", c)
			swbreak
			
		case 'e'
			result += "e"
			
			c2 = peek( sSrc, index + len + 1 )
			if ( c2 == '-' ) {
				result += "-"
				len ++
			}
			
			// 指数を足しておく
			result += CutNum_Dgt( sSrc, index + len + 1 )
			swbreak
	swend
	
	return TKTYPE_NUMBER
	
#global

#endif
