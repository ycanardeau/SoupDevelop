// 汎用文字列操作モジュール

#ifndef __STRING_UTILITY_AS__
#define __STRING_UTILITY_AS__

/**+
 * strutil
 * String utility module
 * @ author Ue-dai
 * @date 2008/09/29
 * @ver 1.0.0
 * @type 命令拡張モジュール
 * @group 文字列操作関数
 */

#include "mod_replace.as"
#define global StrReplace replace

#module strutil

// ※命令・関数 間の変数の衝突は気にしない。
// 　別の関数は、衝突しても問題ない場合を除き、呼び出してはいけない。

#include "ctype.as"

#define true  1
#define false 0

// 内部処理関数

// 内部用マクロ
#define MPROC_DoUntil(%1=cntvar,%2=cond,%3=break,%4) repeat : if (%2) { break } %4 : if ( %1 < 0 ) { %3 } : loop

// p1 の変数を、p2 が成り立つまで 増加・減少 させるマクロ
#define MPROC_IncUntil(%1=cntvar,%2=cond,%3=break) MPROC_DoUntil %1,%2,%3,%1 ++
#define MPROC_DecUntil(%1=cntvar,%2=cond,%3=break) MPROC_DoUntil %1,%2,%3,%1 --

//##################################################################################################
//        文字列操作系
//##################################################################################################
/**
 * 文字列を挿入する
 * p1 の途中に文字列を挿入します。
 * @prm p1 = var	: 文字列型変数
 * @prm p2 = int(0)	: オフセット
 * @prm p3 = str	: 挿入する文字列
 * @prm p4 = int(-1): p1 の長さ。省略可能。
 * @prm p5 = int(-1): p3 の長さ。省略可能。
 * @return = int	: 文字列の長さ
 */
#define global StrInsert(%1,%2=0,%3,%4=-1,%5=-1) _StrInsert %1,%2,%3,%4,%5
#deffunc _StrInsert var p1, int p2, str p3, int p4, int p5
	
	if ( p4 < 0 ) { len(0) = strlen(p1) } else { len(0) = p4 }
	if ( p5 < 0 ) { len(1) = strlen(p3) } else { len(1) = p5 }
	if ( len(1) == 0 ) {           return len(0) }
	if ( len(0) == 0 ) { p1 = p3 : return len(1) }
	
	sdim stmp, len(1) + 1
	stmp = p3
	
	memexpand p1,       len(0) + len(1) + 1				// p1 を広げる ( BufferOverflow を避けるため )
	memcpy    p1,   p1, len(0) - p2, len(1) + p2, p2	// 全体を後ろに動かし、p1 の前に空間を作る
	memcpy    p1, stmp, len(1)     ,          p2,  0	// 出来た空間にコピーする
	poke      p1,       len(0) + len(1), 0				// 最後に NULL で止める
	
	return ( len(0) + len(1) )
	
/**
 * 文字列を削除する
 * p1 から、指定バイトの文字列を削除します。
 * @prm p1 = var	: 文字列型変数
 * @prm p2 = int(0)	: オフセット
 * @prm p3 = int	: 削除する長さ
 * @prm p4 = int(-1): p1 の長さ。省略可能。
 * @return = int	: 文字列の長さ
 */
#define global StrDelete(%1,%2=0,%3,%4=-1) _StrDelete %1,%2,%3,%4
#deffunc _StrDelete var p1, int offset, int size, int p4
	
	if ( p4   < 0 ) { len = strlen(p1) } else { len = p4 }
	if ( size < 0 ) { return len }
	
	iSpace = len - (offset + size)					// 後ろに出来る空白の大きさ
	
	memcpy p1, p1, iSpace, offset, offset + size	// 上書きしつつコピーする
	memset p1,  0,   size, offset + iSpace			// 後ろに出来た空白を埋める
	return (len - size)
	
/**
 * 文字列から前後のスペースやタブ、改行を取っ払う
 * 文字列型変数 p1 から前後のスペース類を削除します。
 * 
 * ※stripstr という名前でも使用できます。
 * @+ Blank は、スペース、タブ、改行を指す。
 * @+ 2 バイト文字の 2 バイト目がスペース類の文字コードになることはありえない
 * @prm p1 = var	: 文字列型変数
 * @prm p2 = int(-1): p1 の長さ。省略可能。
 * @return = int	: 取っ払った後の p1 の長さ
 */
#define global StripBlanks(%1,%2=-1) _StripBlanks %1,%2
#deffunc _StripBlanks var p1, int p2
	
	if ( p2 < 0 ) { len = strlen(p1) } else { len = p2 }
	
	// 末尾のブランク
	p = len				// チェックする文字インデックス
	repeat len
		p --
		c = peek(p1, p)
		if ( IsBlank(c) == false ) {
			p ++
			break	// 空白でなければ終わり
		}
	loop
	
	memset p1, 0, len - p, p	// NULL 文字にする
	len  = p					// 文字インデックスは、「先頭 ～ 一つ前の文字」の文字列の長さと同じ
	
	// 先頭のブランク
	for p, 0, len
		c = peek(p1, p)
		if ( IsBlank(c) == false ) { _break }
	next
	
	StrDelete p1, 0, p, len	// 前方の空白を削除
	return stat				// 削除後の文字列長を返す
	
#define global stripstr StripBlanks

/**
 * 文字列から前後の引用符を取っ払う
 * 文字列型変数 p1 から前後の引用符を、通常は一つずつ削除します。
 * ''xxx'' のような文字列は、'xxx' になります。(一つだけ削除するので)
 * p3 が真(0以外)の場合、前後の引用符をすべて削除します。
 * 
 * この命令は、前後の引用符の数が違っていても気にしません。
 * 
 * @prm p1 = var	: 文字列型変数
 * @prm p2 = int(-1): p1 の長さ。省略可能。
 * @prm p3 = bool(0): 引用符を全部削除するか
 * @return = int	: 取っ払った後の p1 の長さ
 */
#deffunc StripQuote var p1, int p2, int p3
	if ( p2 < 0 ) { len = strlen(p1) } else { len = p2 }
	
	if ( len <= 0 ) { return 0 }
	
	// 末尾の引用符
	repeat ( p3 == 0 ) - ( p3 != 0 )	// p3 が真なら無限ループ
		c = peek(p1, len - 1)
		if ( IsQuote(c) ) { len -- : poke p1, len, 0 } else { break }
	loop
	
	// 先頭の引用符
	repeat ( p3 == 0 ) - ( p3 != 0 )	// p3 が真なら無限ループ
		c = peek(p1)
		if ( IsQuote(c) ) { StrDelete p1, 0, 1, len : len = stat } else { break }
	loop
	return len
	
/**
 * 文字列を反復する
 * 文字列を指定した回数反復します。
 * 0以下なら、空文字列が返ります。
 * @prm p1 = str	: 対象の文字列
 * @prm p2 = int	: 回数
 * @prm p3 = int	: p1 の長さ( 省略可能 )
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
//        文字列 部分取得系
//##################################################################################################
/**
 * 文字列切り取り
 * 部分文字列 p4 を検索し、p2 の p3 からそれがあるところまでを切り出し、返します。
 * なかった場合は、p2 の「p3 ～ 終端」を返します。
 * @prm p1 = var	: 切り取った文字列を受け取る変数
 * @prm p2 = var	: 文字列型変数
 * @prm p3 = int(0)	: オフセット
 * @prm p4 = str	: 検索する文字列
 * @prm p5 = int(-1): p2 の長さ。省略可能。
 * @prm p6 = int(-1): p4 の長さ。省略可能。
 * @return = int	: 切り取った文字列の長さ
 */
#define global StrCut(%1,%2,%3=0,%4,%5=-1,%6=-1) _StrCut %1,%2,%3,%4,%5,%6
#deffunc _StrCut var p1, var p2, int p3, str p4, int p5, int p6
	if ( p5 < 0 ) { len(0) = strlen(p2) } else { len(0) = p5 }
	if ( p6 < 0 ) { len(1) = strlen(p4) } else { len(1) = p6 }
	
	// 検索
	i = instr(p2, p3, p4)
	if ( i < 0 ) {
		i = len(0) - p3		// すべて
	}
	
	// 結果を p1 にコピーする
	memexpand p1, i + 1			// 確保できるサイズまで拡張する
	memcpy    p1, p2, i, 0, p3	// コピー
	poke      p1, i, 0			// NULLで終わる
	return i
	
/**
 * n バイト先の文字列を取得
 * 文字列 p1 の、n byte 飛ばしたところから始まる文字列を返します。
 * @prm p1 = str	: 文字列
 * @prm p2 = int	: ずらすバイト数
 * @prm p3 = int(-1): p1 の長さ。省略可能
 * @return = str	: 結果文字列
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
 * 文字列から識別子を取り出す
 * 文字列 p2 のインデックス p3 から識別子(１単語)を取り出します。
 * 取り出した識別子を変数 p1 に格納し、その長さを返します。
 * 
 * 先頭には、半角アルファベットと _ と全角文字、
 * 二文字目以降は半角数字も許可します。
 * 
 * ※scanident(p3, p1, p2) という形のマクロも用意されています。
 * @prm p1 = var	: 識別子の文字列を格納する変数
 * @prm p2 = var	: 文字列型変数
 * @prm p3 = int	: 文字列のインデックス
 * @return = int	: 識別子の長さ(bytes)
 * 
 * @TODO : @ によるスコープ解決はどうする？
 */
#defcfunc CutIdent var p1, var p2, int offset
	if ( vartype(p1) != vartype("str") ) { sdim p1, 64 }
	
	c = peek(p2, offset)
	if ( IsIdentTop(c) == false && IsSJIS1st(c) == false ) {
		poke p1
		return 0
	}
	repeat , offset + 1 + IsSJIS1st(c)
		// 二文字目からは
		c = peek(p2, cnt)
		if ( IsSJIS1st(c) ) { continue (cnt + 2) }	// 全角文字
		if ( IsIdent(c) == false ) {
			i = cnt - offset
			break
		}
	loop
	
	// 返値バッファにコピー
	memcpy p1, p2, i, 0, offset
	poke   p1,  i, 0			// NULL終端で止める
;	p1 = strmid(p2, offset, i)
	return i
	
#define global ctype scanident(%1,%2=0,%3) TookIdent(%3,%1,%2)

// 識別子の先頭まで戻る
#defcfunc BackToIdentTop var p1, int offset, int bIsLineSpace
	if ( offset <= 0 ) { return -1 }
	i = offset - 1
	
	// 空白を飛ばす( 前にある空白列の先頭まで移動する )
	MPROC_DecUntil i, IsSpace2(peek(p1, i), bIsLineSpace) == false
	if ( i < 0 ) { return -1 }
;	i ++
	
	if ( IsSpace2(peek(p1, i), bIsLineSpace) ) { i -- }
	
	// 識別子を飛ばす( 識別子の先頭まで i を動かす )
	MPROC_DecUntil i, IsIdent(peek(p1, i)) == false
	if ( i < 0 ) { i = 0 }
	i ++
	
	// 数値をスキップする( 先頭として不適切なら飛ばす )
	MPROC_IncUntil i, IsIdentTop(peek(p1, i)) || peek(p1, i) == 0
	
	return offset - i
	
/**
 * 後ろの識別子を取得する
 * 文字列の指定したオフセットの直前にある識別子を取り出します。
 * オフセットのなかに識別子がある場合は、それを取り出します。
 * 
 * 行頭または文字列の頭まで、識別子が発見できなかった場合、
 * または、オフセット位置より手前に、識別子ではなく記号が
 * 見つかった場合は、空文字列を p1 に返します。
 * 
 * ※scanidentb(p2, p3, p1, p4=0) というマクロも使用できます。
 * @prm p1 = var	: 識別子の文字列を格納する変数
 * @prm p2 = var	: 文字列型変数
 * @prm p3 = int	: オフセット値
 * @prm p4 = bool	: 改行を空白とみなすか
 * @return = int	: 識別子の長さ(bytes)
 */
#defcfunc CutIdentBack var p1, var p2, int offset, int bIsLineSpace
	if ( offset <= 0 ) {
		poke p1
		return 0
	}
	return CutIdent( p1, p2, offset - BackToIdentTop(p2, offset, bIsLineSpace) )
	
//##################################################################################################
//        文字列状態取得系
//##################################################################################################
/**
 * 文字列の指定位置から空白とタブの続く回数を数える
 * 文字列 p1 のインデックス p2 から空白とタブの続く回数を数えます。
 * 数えた回数を返します。
 * 
 * ※spnspace という名前でも使用できます。
 * @prm p1 = var		: 文字列型変数
 * @prm p2 = int(0)		: 文字列のインデックス
 * @prm p3 = bool(0)	: 改行を空白と見なすか
 * @return = int		: 空白とタブの続く回数
 */
#defcfunc CntSpaces var p1, int p2, int bIsLineSpace
	i = p2
	while ( IsSpace(peek(p1, i)) || IsNewLine(peek(p1, i)) * (bIsLineSpace != 0) )
		i ++
	wend
	return i - p2
	
#define global spnspace CntSpaces		// 別名で登録
	
// 後ろ向きに空白の続く数を返す
#defcfunc CntSpacesBack var p1, int p2
	if ( p2 == 0 ) { return 0 }
	i = p2 - 1
	MPROC_DecUntil i, IsSpace(peek(p1, i)) == false
	return p2 - i - 1
	
/**
 * ２文字列の指定位置から同じ内容の続くバイト数を数える
 * 文字列型変数 p1 のインデックス p3 と文字列型変数 p2 のインデックス p4 から同じ内容の続くバイト数を数えます。
 * @prm p1 = var	: 文字列型変数
 * @prm p2 = var	: 文字列型変数
 * @prm p3 = int(0)	: p1 のインデックス
 * @prm p4 = int(0)	: p3 のインデックス
 * @return = int	: 同じ内容の続くバイト数
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
 * ２文字列の指定位置から指定バイト同じ文字列が続くか
 * 文字列型変数 p1 のインデックス p4 と文字列型変数 p2 のインデックス p5 から、p3 バイト同じ内容が続くか調べます。
 * @prm p1 = var	: 文字列型変数
 * @prm p2 = var	: 文字列型変数
 * @prm p3 = int	: バイト数
 * @prm p4 = int(0)	: p1 のインデックス
 * @prm p5 = int(0)	: p3 のインデックス
 * @return = bool	: 続くなら真
 */
#defcfunc StrCompNum var p1, var p2, int p3, int p4, int p5
	ret = 1		// 真に設定
	repeat p3
		c = peek(p1, p4 + cnt)
		if ( c != peek(p2, p5 + cnt) ) {
			ret = 0
			break
		}
	loop
	return ret
	
/**
 * 背面文字列探索(リニアサーチ)
 * 後ろ向きに文字列を検索します。
 * 使い方はほとんど instr() 関数と同じですが、
 * instrb()関数が返すインデックス値は、オフセットと関係ないので
 * 気をつけてください。
 * 
 * オフセットは、通常通り前から数えます。
 * 後ろからのオフセットは、(全体の長さ - 前からのオフセット - 1)
 * で算出できます。
 * @prm p1 = var	: 検索対象文字列型変数
 * @prm p2 = int(0)	: オフセット
 * @prm p3 = str	: 検索する文字列
 * @prm p4 = int(-1): p1 の長さ。省略可能
 * @prm p5 = int(-1): p3 の長さ。省略可能
 * @return = int	: 発見した位置のインデックスか、負数
 * @algorithm		: Linear Search
 */
#define global ctype instrb(%1,%2=0,%3,%4=-1,%5=-1) _instrb(%1,%2,%3,%4,%5)
#defcfunc _instrb var p1, int offset, str p3, int p4, int p5
	if ( p4 < 0 ) { len(0) = strlen(p1) } else { len(0) = p4 }
	if ( p5 < 0 ) { len(1) = strlen(p3) } else { len(1) = p5 }
	
	// 後ろから探索
	sdim stmp, len(1) + 1
	stmp = p3
	i    = len(0) - offset - 1
	c    = peek(stmp)
	
	while ( i >= 0 )
		// 先頭だけの比較で高速化する
		if ( peek(p1, i) == c ) {
			// 発見?
			if ( strmid(p1, i, len(1)) == stmp ) {
				return i
			}
		}
		i --
	wend
	
	// 発見できなかった
	return -1
	
#global

//######## サンプル・プログラム ################################################
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
