// definition list

#ifndef __MODULECLASS_DEFINITION_LIST_AS__
#define __MODULECLASS_DEFINITION_LIST_AS__

#include "Mo/strutil.as"
#include "Mo/HPM_split.as"
#include "Mo/pvalptr.as"

#module MCDeflist mScript, mCount, mFileName, mFilePath, mIdent, mLn, mType, mScope, mInclude, mCntInclude

#include "Mo/HPM_header.as"

//##############################################################################
//        定数・マクロ
//##############################################################################
#define true  1
#define false 0

//------------------------------------------------
// DEFTYPE
//------------------------------------------------
#const global DEFTYPE_LABEL		0x0001		// ラベル
#const global DEFTYPE_MACRO		0x0002		// マクロ
#const global DEFTYPE_CONST		0x0004		// 定数
#const global DEFTYPE_FUNC		0x0008		// 命令・関数
#const global DEFTYPE_DLL		0x0010		// DLL命令
#const global DEFTYPE_CMD		0x0020		// HPIコマンド
#const global DEFTYPE_COM		0x0040		// COM命令
#const global DEFTYPE_IFACE		0x0080		// インターフェース

#const global DEFTYPE_CTYPE		0x0100		// CTYPE
#const global DEFTYPE_MODULE	0x0200		// モジュールメンバ

//------------------------------------------------
// 特殊な空間名
//------------------------------------------------
#define global AREA_GLOBAL "global"
#define global AREA_ALL    "*"

//##############################################################################
//                コンストラクタ・デストラクタ
//##############################################################################
//------------------------------------------------
// コンストラクタ
//------------------------------------------------
#define global deflist_new(%1,%2) newmod %1, MCDeflist@, %2
#modinit str path
	// メンバ変数を初期化
	sdim mIdent,, 5
	dim  mLn,     5
	dim  mType,   5
	sdim mScope,, 5
	sdim mFileName
	sdim mFilePath, MAX_PATH
	sdim mInclude,  MAX_PATH
	dim  mCntInclude
	
	mFilePath = path
	mFileName = getpath(mFilePath, 8)
	
	// スクリプトを読み込む
	notesel  mScript
	noteload mFilePath
	noteunsel
	
	// 定義をリストアップ
	deflist_listup thismod
	
	return getaptr(thismod)
	
//------------------------------------------------
// デストラクタ
//------------------------------------------------
#define global deflist_delete(%1) delmod %1
	
//##############################################################################
//                メンバ関数
//##############################################################################
//------------------------------------------------
// 一括して格納する
// 
// @ p2 を負数にすると追加になる -> deflist_add
//------------------------------------------------
#define global deflist_set(%1,%2,%3,%4,%5,%6) _deflist_set %1,%2,%3,%4,%5,%6
#define global deflist_add(%1,%2,%3,%4,%5)    _deflist_set %1,-1,%2,%3,%4,%5
#modfunc _deflist_set int p2, str ident, int linenum, int deftype, str scope,  local iItem
	if ( p2 < 0 ) { iItem = mCount : mCount ++ } else { iItem = p2 }
	mIdent(iItem) = ident
	mLn   (iItem) = linenum
	mType (iItem) = deftype
	mScope(iItem) = scope
	return iItem
	
//------------------------------------------------
// 一括して取得する
//------------------------------------------------
#modfunc deflist_get int p2, var ident, var linenum, var deftype, var scope
	ident   = mIdent(p2)
	linenum = mLn   (p2)
	deftype = mType (p2)
	scope   = mScope(p2)
	return
	
//------------------------------------------------
// 各メンバごとの getter
//------------------------------------------------
#modfunc deflist_getScript var script
	script = mScript
	return
	
#modcfunc deflist_getCount
	return mCount
	
#modcfunc deflist_getFilePath
	return mFilePath
	
#modcfunc deflist_getFileName
	return mFileName
	
#modcfunc deflist_getIdent int p2
	return mIdent(p2)
	
#modcfunc deflist_getLn int p2
	return mLn(p2)
	
#modcfunc deflist_getDefType int p2
	return mType(p2)
	
#modcfunc deflist_getScope int p2
	return mScope(p2)
	
#modcfunc deflist_getCntInclude
	return mCntInclude
	
#modcfunc deflist_getInclude int p2
	return mInclude(p2)
	
//------------------------------------------------
// include ファイルを配列にして返す
//------------------------------------------------
#modfunc deflist_getIncludeArray array p2
	sdim p2,, mCntInclude
	repeat    mCntInclude
		p2(cnt) = mInclude(cnt)
	loop
	return
	
//##############################################################################
//                定義をリストアップする
//##############################################################################
//------------------------------------------------
// 範囲名を作成する
// @private
// @static
//------------------------------------------------
#deffunc MakeScope@MCDeflist var scope, str defscope, int deftype, int bGlobal, int bLocal
	if ( bGlobal ) { scope = AREA_ALL : return }
	
	scope = defscope
	
	if ( bLocal ) { scope += " [local]" }
	return
	
//------------------------------------------------
// 定義をリストアップする
//------------------------------------------------
#define nowTkType tktypelist(idx)
#define nowTkStr  tkstrlist (idx)

#modfunc deflist_listup  local tktypelist, local tkstrlist, local befTkType, local idx, local cntToken, local sIdent, local areaScope, local scope, local nowline, local bGlobal, local bLocal, local deftype, local uniqueCount, local fSplit
	fSplit  = HPM_SPLIT_FLAG_NO_BLANK
	fSplit |= HPM_SPLIT_FLAG_NO_RESERVED
	
	hpm_split tktypelist, tkstrlist, mScript, fSplit
	
	cntToken = stat
	if ( cntToken <= 0 ) {
		return 0
	}
	
	sdim sIdent
	sdim scope
	sdim areaScope
	
	dim listIndex, 5	// 文字インデックスのリスト( 高速化のために使う )
	
	nowline     = 0
	uniqueCount = 0
	areaScope   = AREA_GLOBAL
	befTkType   = TKTYPE_END
	
	repeat cntToken
		gosub *LNextToken
		if ( idx >= cntToken ) {
			break
		}
	loop
	
	return mCount
	
*LProcToken
	switch ( nowTkType )
		
		//--------------------
		// 文の終端
		//--------------------
		case TKTYPE_END
			c = peek(nowTkStr)
			if ( IsNewLine( c ) ) {
				nowline ++
			}
			swbreak
			
		//--------------------
		// 改行回避
		//--------------------
		case TKTYPE_ESC_LINEFEED
			nowline ++
			swbreak
			
		//--------------------
		// コメント
		//--------------------
		case TKTYPE_COMMENT
			// 複数行コメントの場合、行数を数える
			if ( wpeek(nowTkStr) == 0x2A2F ) {		// /*
				gosub *LCountLines
			}
			swbreak
			
		//--------------------
		// 文字列
		//--------------------
		case TKTYPE_STRING
			// 複数行文字列定数の場合、行数を数える
			if ( wpeek(nowTkStr) == 0x227B ) {		// {"
				gosub *LCountLines
			}
			swbreak
			
		//--------------------
		// ラベル
		//--------------------
		case TKTYPE_LABEL
			// 行頭の場合のみ
			if ( befTkType == TKTYPE_END ) {
				sIdent = nowTkStr
				
				gosub *LDecideModuleName
				
				// リストに追加
				deftype = DEFTYPE_LABEL
				gosub *LAddDefList
			}
			swbreak
			
		//--------------------
		// プリプロセッサ命令
		//--------------------
		case TKTYPE_PREPROC
			deftype  = 0
			bGlobal  = true
			bLocal   = false
			
			ppident  = CutPreprocIdent( nowTkStr )		// 識別子部分だけにする
			
			switch ( ppident )
				
				// モジュール空間に突入
				case "module"
					gosub *LNextToken
					
					// #module "modname" の形式
					if ( nowTkType == TKTYPE_STRING ) {
						nowTkStr = CutStrInner(nowTkStr)
						
					// #module modname の形式
					} else : if ( nowTkType == TKTYPE_NAME ) {
						
					// 無名モジュール
					} else {
						// ユニークな空間名を与える
						nowTkStr = strf("m%02d [unique]", uniqueCount)
						uniqueCount ++
					}
					
					areaScope = nowTkStr
					swbreak
					
				// モジュール空間から脱出
				case "global"
					areaScope = AREA_GLOBAL
					swbreak
					
				case "include"
				case "addition"
					gosub *LNextToken
					
					if ( nowTkType == TKTYPE_STRING ) {
						nowTkStr = CutStrInner( nowTkStr )
						
						mInclude(mCntInclude) = nowTkStr
						mCntInclude ++
						
;						logmes "#include "+ nowTkStr
					} else {
						logmes "[Warning] in mod_deflist line "+ nowline +"\nBad #include Syntax:\n\t#include "+ nowTkStr +"\n\tTKTYPE = "+ nowTkType
					}
					swbreak
					
				case "modfunc"  : deftype  = DEFTYPE_MODULE
				case "deffunc"  : deftype |= DEFTYPE_FUNC                    : goto *LAddDefinition
				case "modcfunc" : deftype  = DEFTYPE_MODULE
				case "defcfunc" : deftype |= DEFTYPE_FUNC   | DEFTYPE_CTYPE  : goto *LAddDefinition
				case "define"   : deftype  = DEFTYPE_MACRO : bGlobal = false : goto *LAddDefinition
				case "const"
				case "enum"     : deftype  = DEFTYPE_CONST : bGlobal = false : goto *LAddDefinition
				case "cfunc"    : deftype  = DEFTYPE_CTYPE
				case "func"     : deftype |= DEFTYPE_DLL   : bGlobal = false : goto *LAddDefinition
				case "cmd"      : deftype  = DEFTYPE_CMD   : bGlobal = true  : goto *LAddDefinition
				case "comfunc"  : deftype  = DEFTYPE_COM   : bGlobal = false : goto *LAddDefinition
				case "usecom"   : deftype  = DEFTYPE_IFACE : bGlobal = false : goto *LAddDefinition
			:*LAddDefinition
					gosub *LNextToken
					
					switch ( nowTkStr )
						case "global" : bGlobal  = true                  : goto *LAddDefinition
						case "ctype"  : deftype |= DEFTYPE_CTYPE         : goto *LAddDefinition
						case "local"  : bGlobal  = false : bLocal = true : goto *LAddDefinition
						case "double" : goto *LAddDefinition
						
						// 定義される識別子
						default:
							sIdent = nowTkStr
							swbreak
					swend
					
					// スコープを解決
					gosub *LDecideModuleName
					if ( scope != areaScope ) {		// ident@scope の場合
						bGlobal = false
					}
					
					// 範囲を作成
					MakeScope scope, areaScope, deftype, bGlobal, bLocal
					
					// リストに追加
					gosub *LAddDefList
					swbreak
			swend
			swbreak
	swend
	return
	
*LAddDefList
	deflist_add thismod, sIdent, nowline, deftype, scope
	return
	
*LNextToken
	befTkType = nowTkType
	
	idx ++
	if ( idx >= cntToken ) {
		nowTkType = TKTYPE_ERROR
		nowTkStr  = ""
		
	}
	
	gosub *LProcToken
	
	return
	
;*LBackToken
;	idx --
;	if ( idx <= 0 ) {
;		idx       = 0
;		befTkType = TKTYPE_END
;	} else {
;		befTkType = tktypelist(idx - 1)
;	}
;	return
	
*LCountLines
	notesel nowTkStr
	nowline += notemax - 1		// 行数
	noteunsel
	return
	
//----------------------------
// モジュール空間名を決定する
//----------------------------
*LDecideModuleName
	if ( idx == cntToken ) {
		goto *LDecideModuleName_areaScope
	}
	
	if ( tktypelist(idx + 1) == TKTYPE_SCOPE ) {
		
		gosub *LNextToken
		
		if ( nowTkStr == "@" ) {
			scope = AREA_GLOBAL
		} else {
			scope = nowTkStr
		}
		return
		
	}
*LDecideModuleName_areaScope
	scope = areaScope
	return
	
//------------------------------------------------
// 定義タイプから文字列を生成する
// @static
//------------------------------------------------
#defcfunc MakeDefTypeString int deftype,  local stype, local bCType
	sdim stype, 320
	bCType = ( deftype & DEFTYPE_CTYPE ) != false
	
	if ( deftype & DEFTYPE_LABEL ) { stype = "ラベル"   }
	if ( deftype & DEFTYPE_MACRO ) { stype = "マクロ"   }
	if ( deftype & DEFTYPE_CONST ) { stype = "定数"     }
	if ( deftype & DEFTYPE_CMD   ) { stype = "コマンド" }
	if ( deftype & DEFTYPE_COM   ) { stype = "命令(COM)" }
	if ( deftype & DEFTYPE_IFACE ) { stype = "interface" }
	
	if ( deftype & DEFTYPE_DLL ) {
		if ( bCType ) { stype = "関数(Dll)" } else { stype = "命令(Dll)" }
		
	} else : if ( deftype & DEFTYPE_FUNC  ) {
		if ( bCType ) { stype = "関数" } else { stype = "命令" }
		
	} else {
		if ( bCType ) { stype += " Ｃ" }
	}
	
	if ( deftype & DEFTYPE_MODULE ) { stype += " Ｍ" }
	return stype
	
#global

#endif
