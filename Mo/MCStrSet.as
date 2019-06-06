// 区切り文字列クラス

#ifndef __MODULECLASS_STRSET_AS__
#define __MODULECLASS_STRSET_AS__

#include "strutil.as"

#module MCStrSet mString, mStrLen, mStrSize, mChar, mCharLen, mIdxptrList, mcntIdxptr, mLastErr, mIterVar
#undef split
// 定義
#define FIRST_ALLOC_SIZE  0xFFFF
#define EXPAND_ALLOC_SIZE 0xFF
#define mv modvar MCStrSet@

#define mNow mIdxptrList(mcntIdxptr)

// マクロ
#define ctype ErrReturn(%1,%2) mLastErr = (%1) : return (%2)
#define ctype ErrReturn2(%1)   mLastErr = (%1) : return (%1)

// エラー定数の定義
#enum global STRSET_ERR_NONE      = 0		// 問題なし
#enum global STRSET_ERR_UNKNOWN   = -1		// 何らかのエラー (危険度:低)
#enum global STRSET_ERR_DANGEROUS = -2		// 何らかのエラー (危険度:高)
#enum global STRSET_ERR_NOMEMORY  = -3		// メモリ不足
#enum global STRSET_ERR_ARGMENT   = -4		// 引数が異常 (関数なら失敗)
#enum global STRSET_ERR_EOS       = -5		// 最後まで読み切った

// 統一関数マクロ
#define global StrSet_new(%1,%2="",%3) newmod %1, MCStrSet@, %2, %3
#define global StrSet_delete(%1) delmod %1

//##############################################################################
//        内部メンバ関数の定義
//##############################################################################

//------------------------------------------------
// mString は区切り文字で終わっているか？
//------------------------------------------------
#define ctype _StrSet_IsLastChar(%1,%2=mString,%3=mStrLen) __StrSet_IsLastChar(%1,%2,%3)
#defcfunc    __StrSet_IsLastChar mv, var p2, int lenOf_p2
	if ( lenOf_p2 < mCharLen ) { return false }
	return ( StrCompNum(p2, mChar, mCharLen, lenOf_p2 - mCharLen) )
	
//------------------------------------------------
// mString の最後に連結する
//------------------------------------------------
#define _StrSet_strcat(%1,%2,%3) _StrSet_strins %1,%2,%3,mStrLen

//------------------------------------------------
// mString の途中に挿入する
//------------------------------------------------
#modfunc _StrSet_strins str p2, int p3, int offset
	if ( mStrSize <= mStrLen + p3 ) {
		mStrSize += EXPAND_ALLOC_SIZE	// サイズを大きくする
		memexpand mString, mStrSize		// 確保
	}
	StrInsert mString, offset, p2, mStrLen, p3
	mStrLen = stat
	return
	
//------------------------------------------------
// p2 ～ p3 を削除する
//------------------------------------------------
#modfunc _StrSet_DeleteBetween int p2, int p3,  local iA, local iB
	if ( p2 == p3 ) { return }
	if ( p2 <  p3 ) {
		iA = p2 : iB = p3
	} else {
		iA = p3 : iB = p2
	}
	
	// 削除する
	StrDelete mString, iA, iB - iA, mStrLen
	mStrLen = stat
	
	// ポインタが削除起点より後にあるなら、調整する
	repeat mcntIdxptr
		if ( mIdxptrList(cnt) > iA ) {
			mIdxptrList(cnt) -= (iB - iA)
		}
	loop
	return
	
//------------------------------------------------
// 文字列の後に区切り文字を付加して返す
//------------------------------------------------
#modfunc _StrSet_addchar var p2, int p3,  local len
	if ( p3 ) { len = p3 } else { len = strlen(p2) }
	
	// 後に区切り文字を付加する
	if ( _StrSet_IsLastChar(thismod, p2, len) == false ) {
		memexpand p2, len + mCharlen + 1	// 確保
		memcpy p2, mChar, mCharLen, len		// 一番後ろに追加
		len += mCharLen
		poke   p2, len, 0
	}
	return len
	
//------------------------------------------------
// n 番目のアイテムへのインデックス値を取得
//------------------------------------------------
#defcfunc _StrSet_SearchByNum mv, int no, int iFrom,  local i, local n, local c, local c2
	i  = iFrom
	n  = 0
	c2 = peek(mChar)
	while ( n < no )
		c = peek(mString, i)
		if ( c == c2 ) {	// 先頭のみの比較で高速化を図る
			
			if ( StrCompNum( mString, mChar, mCharLen, i ) ) {
				// 発見
				n ++			// カウントアップ
				i += mCharLen	// 飛ばす
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
// 指定文字列の項目までのインデックス値を求める
//------------------------------------------------
#define global ctype _StrSet_FindStr(%1,%2,%3=0,%4=-1) __StrSet_FindStr(%1,%2,%3,%4)
#defcfunc __StrSet_FindStr mv, str p2, int iFrom, int lenOf_p2,  local stmp, local len
	if ( lenOf_p2 < 0 ) { len = strlen(p2) } else { len = lenOf_p2 }
	
	sdim stmp, len + mCharLen + 1
	stmp = p2
	
;	logmes logv(stmp)
	
	// 前の区切り文字を除去する
	if ( StrCompNum(stmp, mChar, mCharLen) ) {
		StrDelete  stmp, 0, mCharLen, len : len = stat
	}
	// 後に区切り文字を付加する
	_StrSet_addchar thismod, stmp, len : len = stat
	
;	logmes logv(stmp)
	
	// 最初の項目がこれか？ ( ↓p2の最後に mChar があっても、どうせ比較しないので問題ない )
	if ( iFrom <= 0 ) : if ( StrCompNum(mString, stmp, len) ) {
		return 0
	}
	
	// 中間の項目にマッチするものがあるか探す
	return ( instr(mString, iFrom, mChar + stmp) )	// 「区切り 項目 区切り」を探す
	
//------------------------------------------------
// すでに項目として存在するか
//------------------------------------------------
#defcfunc _StrSet_IsInserted mv, str p2
	
	if ( instr(mString, 0, mChar) < 0 ) {	// 区切り文字がない
		return ( mString == p2 )			// 唯一の項目がこれなら真
	}
	
	return ( _StrSet_FindStr(thismod, p2) >= 0 )
	
//------------------------------------------------
// 最後の項目までのインデックス値を求める
//------------------------------------------------
#defcfunc _StrSet_IdxOfLast mv, local i
	// 最後を探索
	i = instrb( mString, 0, mChar, mStrLen, mCharLen )
	
	// 発見できなかったら、先頭から全部になる
	if ( i < 0 ) {
		return 0	// 区切り文字がない
		
	// 最後が区切り文字で終わっていたら
	} else : if ( i == (mStrLen - mCharLen) ) {
		// もう一度検索する
		i = instrb( mString, mCharLen, mChar, mStrLen, mCharLen )
		
		// 発見できなかったら、空文字列になる
		if ( i < 0 ) {
			return mStrLen
		}
		
	// 最後が区切り文字ではない
	} ;else {}		// 必要な処理はない
	
	// 区切り文字の分をスキップさせる
	return i + mCharLen
	
//##############################################################################
//                コンストラクタ・デストラクタ
//##############################################################################
//------------------------------------------------
// コンストラクタ
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
	
	// mString の最後に mChar を追加する
	if ( mStrLen ) {
		_StrSet_addchar thismod, mString, mStrLen : mStrLen = stat
	}
	
	return
	
//------------------------------------------------
// デストラクタ
//------------------------------------------------
;#modterm
;	return

//##############################################################################
//                メンバ関数
//##############################################################################

//##########################################################
//        取得ポインタ操作系関数群
//##########################################################
//------------------------------------------------
// 先頭に戻る
//------------------------------------------------
#modfunc StrSet_gotop
	mNow = 0
	return
	
//------------------------------------------------
// 終端までジャンプ
//------------------------------------------------
#modfunc StrSet_gobtm
	mNow = mStrLen
	return
	
//------------------------------------------------
// n 個戻る
//------------------------------------------------
#modfunc StrSet_back int num, local offset, local i
	if ( num <= 0 ) { return }
	
	i      = mNow - mCharLen	// 最初のオフセット ( mNow の手前にある mChar へのオフセット )
	mNow   = -1
	repeat num
		// 後ろ向きに検索( num回発見するまで )
		i = instrb(mString, mStrLen - i, mChar, mStrLen, mCharLen)
		
		if ( i < 0 ) { mNow = 0 : break }	// 先頭
	loop
	
	if ( mNow < 0 ) { mNow = i + mCharLen }
	return
	
//------------------------------------------------
// n 個飛ばす
//------------------------------------------------
#modfunc StrSet_skip int num
	i = _StrSet_SearchByNum(thismod, num, mNow)
	
	if ( i < 0 ) {
		mLastErr = STRSET_ERR_ARGMENT
		i        = mStrLen			// 終端
	}
	mNow = i		// 新しい取得ポインタ
	return
	
//------------------------------------------------
// n 番目に移動 (ランダムアクセス)
//------------------------------------------------
#modfunc StrSet_jump int no
	StrSet_gotop thismod		// 一旦先頭に戻って
	StrSet_skip  thismod, no	// no 個飛ばす
	return
	
	
//------------------------------------------------
// 取得ポインタをプッシュ
//------------------------------------------------
#modfunc StrSet_pushIdxptr int p2
	mcntIdxptr ++
	mNow = 0
	if ( p2 ) { StrSet_jump thismod, p2 }
	return
	
//------------------------------------------------
// 取得ポインタをポップ
//------------------------------------------------
#modfunc StrSet_popIdxptr
	if ( mcntIdxptr > 0 ) {
		mcntIdxptr --
	}
	return
	
//##########################################################
//        追加系関数群
//##########################################################
// ☆必ず mString の最後が mChar で終わるように配慮する

//------------------------------------------------
// 最後に加える
//------------------------------------------------
#modfunc StrSet_add str p2
	
	len = strlen(p2)
	sdim stmp, len + 1
	stmp = p2
	
	// 文字列の最後に区切り文字を付加
	_StrSet_addchar thismod, stmp, len : len = stat
	
	// 最後に連結する
	_StrSet_strcat thismod, stmp, len
	return
	
//------------------------------------------------
// 現在の位置に追加する
// 
// @ 次の getnext で取得される
//------------------------------------------------
#modfunc StrSet_insnow str p2
	
	// 後ろに区切り文字を追加しておく
	_StrSet_strins thismod, p2 + mChar, strlen(p2) + mCharLen, mNow
	
	return
	
//------------------------------------------------
// n 番目の位置に追加する
// 
// @return int : 挿入位置のインデックス値
//------------------------------------------------
#modfunc StrSet_insert str p2, int no
	
	// 数える
	i = _StrSet_SearchByNum(thismod, no, 0)
	if ( i < 0 ) { return stat }
	
	// str の後ろに区切り文字を付加して、挿入
	len = strlen(p2) + mCharLen
	
	_StrSet_strins thismod, p2 + mChar, len, i
	
	// mNow より前なら、mNow を加算しておく
	repeat mcntIdxptr
		if ( i < mIdxptrList(cnt) ) { mIdxptrList(cnt) += len }
	loop
	return i
	
//------------------------------------------------
// 排他的系
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
//        取得系関数群
//##########################################################
//------------------------------------------------
// 最初のモノを取得
//------------------------------------------------
#defcfunc StrSet_gettop mv
	sdim   stmp, mStrLen	// ↓mChar までを切り出す
	StrCut stmp, mString, 0, mChar, mStrLen, mCharLen
	return stmp
	
//------------------------------------------------
// 次のモノを取得
//------------------------------------------------
#defcfunc StrSet_getnext mv
	sdim   stmp, mStrLen
	StrCut stmp, mString, mNow, mChar, mStrLen, mCharLen
	
	mNow += stat + mCharLen			// 取得ポインタを進める
	if ( mNow >= mStrLen ) {
		mLastErr = STRSET_ERR_EOS
	}
	return stmp
	
//------------------------------------------------
// 直前に取得したモノを取得
//------------------------------------------------
#defcfunc StrSet_getprev mv
	StrSet_back thismod, 1
	return StrSet_getnext(thismod)
	
//------------------------------------------------
// 最後のモノを取得
//------------------------------------------------
#defcfunc StrSet_getlast mv
	// 切り出して返す
	sdim   stmp, mStrLen
	StrCut stmp, mString, _StrSet_IdxOfLast(thismod), mChar, mStrLen, mCharLen
	return stmp
	
//------------------------------------------------
// n 番目のモノを取得
// 
// @ ランダムアクセス
//------------------------------------------------
#defcfunc StrSet_getone mv, int no
	
	// 数える
	i = _StrSet_SearchByNum(thismod, no, 0)
	if ( i < 0 ) : ErrReturn(STRSET_ERR_ARGMENT, "")
	
	// 切り出して返す
	sdim   stmp, mStrLen
	StrCut stmp, mString, i, mChar, mStrLen, mCharLen
	return stmp
	
//------------------------------------------------
// すべて取得
//------------------------------------------------
#defcfunc StrSet_getall mv
	return mString
	
//------------------------------------------------
// すべて取得
// 
// @ バッファにコピー
//------------------------------------------------
#modfunc StrSet_getall_tobuf var outbuf
	memexpand outbuf, mStrLen + 1
	memcpy    outbuf, mString, mStrLen
	poke      outbuf, mStrLen, 0
	return
	
//##########################################################
//        削除系関数群
//##########################################################
//------------------------------------------------
// 次に取得されるものを削除
//------------------------------------------------
#modfunc StrSet_delnow
	// 次の項目のインデックスを取得
	iNext = _StrSet_SearchByNum(thismod, 1, mNow)
	if ( iNext < 0 ) { return true }
	
	// 削除する
	_StrSet_DeleteBetween thismod, mNow, iNext
	return false
	
//------------------------------------------------
// 前回のモノを削除
// 
// @ 前回の getnext() で取得したものを削除
//------------------------------------------------
#modfunc StrSet_delback
	StrSet_back   thismod, 1	// 一つ戻って
	StrSet_delnow thismod		// 「今」のを削除する
	return stat
	
//------------------------------------------------
// n 番目を削除する
// 
// @ ランダムアクセス
//------------------------------------------------
#modfunc StrSet_delone int no
	// no 番目のインデックスを取得
	iPos = _StrSet_SearchByNum(thismod, no, 0)
	if ( iPos < 0 ) { return true }
	
	// 次の項目のインデックスを取得
	iNext = _StrSet_SearchByNum(thismod, 1, iPos)
	if ( iNext < 0 ) { return true }
	
	// iPos ～ iNext を削除
	_StrSet_DeleteBetween thismod, iPos, iNext
	return false
	
//------------------------------------------------
// 空の項目を削除
//------------------------------------------------
#modfunc StrSet_delvoid  local word
	// 区切り文字が二連続になっているところを探して削除
	len    = mCharLen * 2
	offset = 0
	
	sdim   word, len + 1
	memcpy word, mChar, mCharLen
	memcpy word, mChar, mCharLen, mCharLen
	// ↑ word = mChar + mChar
	
	i = 0
	while ( mStrLen > 0 )
		// 検索
		i = instr(mString, 0, word)
		if ( i < 0 ) { _break }
		
		// 1つだけ削除する
		_StrSet_DeleteBetween thismod, i, i + mCharLen
	wend
	return false
	
//------------------------------------------------
// 指定文字列の項目を削除
//------------------------------------------------
#modfunc StrSet_delstr str p2, int bGlobal
	
	len = strlen(p2) + mCharLen
	
	// stmp に区切り文字を付加
	sdim stmp, len
	stmp = p2 + mChar
	
	// bGlobal が真なら繰り返す
	do
		i = _StrSet_FindStr(thismod, stmp, 0, len)	// 検索
		if ( i < 0 ) { _break }			// 無ければ終了する
		
		// 削除する
		_StrSet_DeleteBetween thismod, i, i + len
		
	until ( bGlobal )
	
	return
	
//##########################################################
//        検索系関数群
//##########################################################
// ※なければ負数を返すので、( 返り値 < 0 ) が偽のとき、成功。

//------------------------------------------------
// 文字列から検索
//------------------------------------------------
#define global StrSet_findStr _StrSet_FindStr

//------------------------------------------------
// 指定文字列の項目が存在するかどうか
//------------------------------------------------
#define global ctype StrSet_exists(%1,%2="") ( StrSet_findStr(%1,%2) >= 0 )

//##########################################################
//        繰返子系関数群
//##########################################################
//------------------------------------------------
// 反復開始の設定
//------------------------------------------------
#modfunc StrSet_iter int p2
	StrSet_pushIdxptr thismod, p2
	return
	
//------------------------------------------------
// 反復開始の設定
// 
// @ 外部の変数を使う場合
//------------------------------------------------
#modfunc StrSet_iterVar int p2, var p3
	StrSet_iter thismod, p2
	dup mIt, p3					// mIt をクローンにする
	return
	
//------------------------------------------------
// 次の項目に移動する
// @private
// @ mIt の更新
//------------------------------------------------
#modfunc StrSet_iterCheckCore
	mIt = StrSet_getnext(thismod)
	return
	
//------------------------------------------------
// while の反復条件に使う
//------------------------------------------------
#defcfunc StrSet_iterCheck mv, local bool
	bool = ( mLastErr != STRSET_ERR_EOS )
	StrSet_IterCheckCore thismod	// 更新される
	if ( bool == false ) {
		StrSet_popIdxptr thismod
	}
	return bool
	
//------------------------------------------------
// 現在の項目を取得する ( 内部変数 mIt を使う場合 )
//------------------------------------------------
#defcfunc StrSet_it mv
	return mIt
	
//------------------------------------------------
// [i] 繰返子初期化
//------------------------------------------------
#modfunc StrSet_iterInit var iterData
	StrSet_iter thismod
	iterData = false
	return
	
//------------------------------------------------
// [i] 繰返子更新
//------------------------------------------------
#defcfunc StrSet_iterNext mv, var vIt, var iterData
	if ( iterData == false ) {
		dup vIt, mIt
		iterData = true
	}
	return StrSet_iterCheck(thismod)
	
//##########################################################
//        便利ルーチン関数群
//##########################################################
//------------------------------------------------
// 全項目を配列にして返す
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
// 指定した位置で二等分する
// 
// @ inPosItem は、位置の項目がどちらに入るか
//   0 なら無視、1 は前、2 は後
//------------------------------------------------
#modfunc StrSet_divByPos array str2, int p, int inPosItem
	sdim str2, mStrLen, 2
	i = _StrSet_SearchByNum( thismod, p + (inPosItem == 1), 0 )
	
	// 左
	memcpy str2(0), mString, i
	if ( inPosItem == 0 ) { i = _StrSet_SearchByNum( thismod, 1, i ) }
	
	// 右
	memcpy str2(1), mString, mStrLen - i, 0, i
	
	// mChar を除去する
	repeat 2
		len = strlen(str2(cnt))
		if ( StrCompNum(str2(cnt), mChar, mCharLen, len - mCharLen) ) {
			poke str2(cnt), len - mCharLen, 0		// mChar の先頭を NULL にして、文字列を止める
		}
	loop
	
	return
	
//##########################################################
//        その他関数群
//##########################################################
//------------------------------------------------
// コピーを作成する
//------------------------------------------------
#modfunc StrSet_copy var v_copy
	StrSet_new v_copy, mString, mChar
	return stat
	
//------------------------------------------------
// 項目数の取得
//------------------------------------------------
#defcfunc StrSet_cntItems mv
	offset = 0
	repeat
		// 次の項目の位置
		offset = _StrSet_SearchByNum(thismod, 1, offset)
		if ( offset < 0 ) {
			i = cnt
			// 最後が区切り文字でなければ、+1 して調整
			if ( _StrSet_IsLastChar(thismod) == false ) {
				i ++
			}
			break
		}
	loop
	
	// STRSET_ERR_ARGMENT が格納されているので、上書きする
	mLastErr = STRSET_ERR_NONE
	return i
	
//------------------------------------------------
// 区切り文字を変換
//------------------------------------------------
#modfunc StrSet_chgChar str newChar
	len = strlen(newChar)
	
	// 大丈夫なように再確保
	if ( len > mCharLen ) {
		memexpand mString, mStrSize + (mCharLen - len) * StrSet_CntItems(thismod)
	}
	
	// 区切り文字の全置換
	StrReplace mString, mChar, newChar
	mStrLen = strlen(mString)
	
	// 必要なら拡張する
	if (mStrSize <= mStrLen) {
		mStrSize += mStrLen + EXPAND_ALLOC_SIZE
		memexpand   mString, mStrSize
	}
	
	// mChar 置き換え
	mChar    = newChar
	mCharLen = len
	return
	
//------------------------------------------------
// 区切り文字を変換してから取得
//------------------------------------------------
#defcfunc StrSet_getall_byChar mv, str newChar, local copy
	StrSet_copy    thismod, copy
	StrSet_chgChar copy, newChar
	return StrSet_getall(copy)
	
//------------------------------------------------
// 区切り文字を取得
//------------------------------------------------
#defcfunc StrSet_char mv
	return mChar
	
//------------------------------------------------
// 現在の取得ポインタの位置
//------------------------------------------------
#defcfunc StrSet_now mv
	return mNow
	
//------------------------------------------------
// 最後に起きたエラー
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
//        外付けルーチン
//##############################################################################

#global

//##############################################################################
//        サンプル・スクリプト
//##############################################################################
#if 0

#define write(%1="") if ( bufsize - iWrote <= 300 ) { bufsize += 320 : memexpand buf, bufsize } poke buf, iWrote, ""+ (%1) +"\n" : iWrote += strsize
#define writeAll write StrSet_getall(ss)
	
	bufsize = 320
	sdim buf, bufsize
	
	StrSet_new ss, "文,字,列", ","
	
	write "mString = "+ StrSet_getall(ss)
	write
	
	write "・add()"
	StrSet_add ss, "addition,two,"
	writeAll
	
	write "\n・insnow(str);"
	StrSet_insnow ss, "insert str"
	writeAll
	
	write "\n・insert(str, int);"
	StrSet_insert ss, "bcc", 2
	writeAll
	
	write "\n・xadd(str);"
	StrSet_xadd ss, "bcc,"
	writeAll
	
	write "\n・get系();"
	write StrSet_gettop(ss)    +"\t(top) "
	write StrSet_getlast(ss)   +"\t(last)"
	write StrSet_getone(ss, 2) +"\t(2)"
	
	write "\n・getnext();"
	write StrSet_getnext(ss)
	write StrSet_getnext(ss)
	write StrSet_getnext(ss)
	
	write "\n・del系();"
	StrSet_delone ss, 1
	write "delone(1) : "+ StrSet_getall(ss)
	StrSet_gobtm   ss
	StrSet_delback ss
	write "delback() : "+ StrSet_getall(ss) +"\t(delete at last)"
	
	write "\n・jump(1);"
	StrSet_jump ss, 1
	
	write "\n・getnext(); と now(); "
	write StrSet_getnext(ss) +"\t("+ StrSet_now(ss) +")"
	write StrSet_getnext(ss) +"\t("+ StrSet_now(ss) +")"
	
	write "\n・skip();"
	StrSet_skip ss, 9
	
	write StrSet_now(ss)
	write StrSet_getnext(ss)
	
	write "\n・空項目を大量に追加"
	StrSet_add ss, ",,,,,,d,,,d,,s,a,,,,gg,g"
	writeAll
	
	write "\n・delvoid();"
	StrSet_delvoid ss
	writeAll
	
	write "\n・項目数を取得 CntItems();"
	write "項目数 = "+ StrSet_cntItems(ss)
	
	write "\n・区切り文字を変更 ChgChar();"
	StrSet_chgChar ss, "[切]"
	writeAll
	
	StrSet_xadd ss, "new[]"
	writeAll
	
	StrSet_chgChar ss, "><"
	writeAll
	
;	string = StrSet_getall(ss)
	
	// イテレータのサンプル ( 全項目を出力する )
	write "\n・Iterator Sample ( output all items )"
	
;	StrSet_iter  ss, 0				// p2 に、何個目の項目から始めるかを設定できる
;	while ( StrSet_iterCheck(ss) )	// 更新
;		write StrSet_it(ss)			// 現在の値は関数で取得する
;	wend
	StrSet_toArray ss, slist
	repeat stat						// foreach はダメ
		write slist(cnt)
	loop
	
	// 出力
	objmode 2, 0
	mesbox buf, ginfo(12), ginfo(13)
	
;	delmod ss
	stop
	
#endif

#endif
