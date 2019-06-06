// 置換モジュール (HSP開発Wiki) 2007/06/05      ver1.3

#ifndef __MODULE_REPLACE_AS__
#define __MODULE_REPLACE_AS__

#module modReplace
// 【変数の説明】
//    var sTarget       置き換えしたい文字列型変数
//    str sBefore       検索する文字列が格納された変数
//    str sAfter        置換後の文字列が格納された変数
//    str sResult       一時的に置換結果を代入する変数
//    int iIndex        sResultの文字列の長さ
//    int iIns          instrの実行結果が格納される変数
//    int iStat         検索して見つかった文字列の数
//    int iNowSize      sResultとして確保されているメモリサイズ
//    int iTargetLen    sTargetの文字列の長さ（毎回調べるのは効率が悪い）
//    int iAfterLen     sAfterの文字列の長さ （〃）
//    int iBeforeLen    sBeforeの文字列の長さ（〃）
#const FIRST_SIZE@modReplace  12800		// はじめに確保するsResultの長さ
#const EXPAND_SIZE@modReplace  6400		// memexpand命令で拡張する長さの単位

//------------------------------------------------
// メモリ再確保の判断及び実行のための命令
// @private
//------------------------------------------------
#deffunc _expand@modReplace var sTarget, var iNowSize, int iIndex, int iPlusSize
	if (iNowSize <= iIndex + iPlusSize) {
		iNowSize += EXPAND_SIZE * (1 + iPlusSize / EXPAND_SIZE)
		memexpand sTarget, iNowSize
	}
	return
	
//------------------------------------------------
// 文字列内の対象文字列全てを置換する命令
//------------------------------------------------
#deffunc replace var sTarget, str sBefore, str sAfter, local sResult, local iIndex, local iIns, \
	local iStat, local iTargetLen, local iAfterLen, local iBeforeLen, local iNowSize
	
	sdim sResult, FIRST_SIZE
	iTargetLen = strlen(sTarget)
	iAfterLen  = strlen(sAfter)
	iBeforeLen = strlen(sBefore)
	iNowSize   = FIRST_SIZE
	iStat  = 0
	iIndex = 0
	
	// 検索・置換
	repeat iTargetLen
		
		iIns = instr( sTarget, cnt, sBefore )
		if ( iIns < 0 ) {
			// もう見つからないので、まだsResultに追加していない分を追加してbreak
			_expand sResult, iNowSize, iIndex, iTargetLen - cnt		// オーバーフローを避けるため、メモリを再確保
			poke sResult, iIndex, strmid(sTarget, cnt, iTargetLen - cnt)
			iIndex += iTargetLen - cnt
			break
			
		// 見つかったので、置換して続行
		} else {
			_expand sResult, iNowSize, iIndex, iIns + iAfterLen		// オーバーフローを避けるため、メモリを再確保
			poke sResult, iIndex, strmid(sTarget, cnt, iIns) + sAfter
			iIndex += iIns + iAfterLen
			iStat++
			continue cnt + iIns + iBeforeLen
		}
	loop
	
	memexpand sTarget, iIndex + 2
	memcpy    sTarget, sResult, iIndex
	poke      sTarget,  iIndex, 0
	return iStat			// 置換した個数
#global

#if 0
	note = "HSPの最新バージョンは2.61です。"
	mes note
	replace note, "2.61", "3.0"
	mes note
	mes str(stat) + "回置換しました。"
	stop
#endif

#endif
