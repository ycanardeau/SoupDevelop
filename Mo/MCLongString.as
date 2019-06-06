// 長い文字列特化クラス

#ifndef __MODULE_CLASS_LONG_STRING_AS__
#define __MODULE_CLASS_LONG_STRING_AS__

#module MCLongString mString, mStrlen, mStrSize, mExpand

#define mv modvar MCLongString@
#define DEFAULT_SIZE 3200

//##########################################################
//        コンストラクタ・デストラクタ
//##########################################################
//------------------------------------------------
// [i] コンストラクタ
//------------------------------------------------
#define global LongStr_new(%1,%2=-1,%3=-1) newmod %1, MCLongString@, %2, %3
#modinit int p2, int p3,  local defsize, local expandSize
	if ( p2 <= 0 ) { defsize = DEFAULT_SIZE } else { defsize = p2 }
	if ( p3 <= 0 ) { mExpand = DEFAULT_SIZE } else { mExpand = p3 }
	
	sdim mString, defsize
	mStrlen  = 0
	mStrSize = defsize
	return
	
//------------------------------------------------
// [i] デストラクタ
//------------------------------------------------
#define global LongStr_delete(%1) delmod %1

//##########################################################
//        公開メソッド
//##########################################################
//------------------------------------------------
// 文字列を後ろに追加する
//------------------------------------------------
#modfunc LongStr_add str p2, int p3
	if ( p3 ) { len = p3 } else { len = strlen(p2) }
	
	// overflow しないように
	if ( ( mStrSize - mStrLen ) <= len ) {	// 足りなければ
		mStrSize += len + mExpand
		memexpand mString, mStrSize			// 拡張する
	}
	
	// 書き込む
	poke mString, mStrlen, p2
	mStrlen += strsize
	return
	
#define global LongStr_cat       LongStr_add
#define global LongStr_push_back LongStr_add

//------------------------------------------------
// 文字列を変数バッファにコピーする
//------------------------------------------------
#modfunc LongStr_tobuf var buf
	if ( vartype( buf ) != vartype("str") ) {
		sdim      buf, mStrlen + 1
	} else {
		memexpand buf, mStrlen + 1
	}
	memcpy buf, mString, mStrlen
	poke   buf, mStrlen, 0
	return
	
//------------------------------------------------
// 文字列を後ろから削る
//------------------------------------------------
#modfunc LongStr_eraseBack int sizeErase
	
	mStrlen -= sizeErase
	if ( mStrlen < 0 ) { mStrlen = 0 }
	
	// 終端文字を置く
	poke mString, mStrlen, 0
	
	return
	
//------------------------------------------------
// [i] 文字列の長さを返す
//------------------------------------------------
#modcfunc LongStr_length
	return mStrlen
	
#define global LongStr_size LongStr_length

//------------------------------------------------
// 確保済みバッファの大きさを返す
//------------------------------------------------
#modcfunc LongStr_bufSize
	return mStrSize
	
//------------------------------------------------
// 文字列を関数形式で返す( 非推奨 )
//------------------------------------------------
;#modcfunc LongStr_get
;	return mString
	
//------------------------------------------------
// [i] 初期化
//------------------------------------------------
#modfunc LongStr_clear
	memset mString, 0, mStrlen
	mStrlen = 0
	return
	
//------------------------------------------------
// [i] 連結
//------------------------------------------------
#modfunc LongStr_chain var mv_from,  local tmpbuf
	LongStr_tobuf mv_from, tmpbuf
	LongStr_add   thismod, tmpbuf
	return
	
//------------------------------------------------
// [i] 複写
//------------------------------------------------
#modfunc LongStr_copy var mv_from
	LongStr_clear thismod
	LongStr_chain thismod, mv_from
	return
	
//------------------------------------------------
// [i] 交換
//------------------------------------------------
#modfunc LongStr_exchange var mv2, local mvTemp
	LongStr_new  mvTemp
	LongStr_copy mvTemp,  thismod
	LongStr_copy thismod, mv2
	LongStr_copy mv2,     mvTemp
	LongStr_delete mvTemp
	return
	
//------------------------------------------------
// 文字列を設定する
//------------------------------------------------
#modfunc LongStr_set str string
	LongStr_clear thismod
	LongStr_add   thismod, string
	return
	
//##########################################################
//        内部メソッド
//##########################################################

#global

#endif
