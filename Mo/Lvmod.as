// Listview module

#ifndef __LISTVIEW_MODULE__
#define __LISTVIEW_MODULE__

#define global WC_LISTVIEW	"SysListView32"

// リストビューに送るメッセージ ------------------------------------------------
#define global LVM_GETBKCOLOR		0x1000		// 背景色を取得
#define global LVM_SETBKCOLOR		0x1001		// 背景色の設定
#define global LVM_SETIMAGELIST		0x1003		// イメージリストを割り当てる
#define global LVM_GETITEMCOUNT		0x1004		// アイテムの数を取得
#define global LVM_GETITEM			0x1005		// アイテムの属性を取得
#define global LVM_SETITEM			0x1006		// アイテム・サブアイテムの属性を設定・変更
#define global LVM_INSERTITEM		0x1007		// 新しいアイテムを挿入
#define global LVM_DELETEITEM		0x1008		// アイテムを削除
#define global LVM_DELETEALLITEMS	0x1009		// すべてのアイテムを削除
#define global LVM_GETNEXTITEM		0x100C		// 指定した属性を持つアイテムを取得
#define global LVM_FINDITEM			0x100D		// アイテムを検索
#define global LVM_INSERTCOLUMN		0x101B		// 新しいカラム (列) を挿入
#define global LVM_DELETECOLUMN		0x101C		// カラムを削除
#define global LVM_GETHEADER		0x101F		// ヘッダコントロールを取得
#define global LVM_GETTEXTCOLOR		0x1023		// テキストの文字色を取得
#define global LVM_GETTEXTBKCOLOR	0x1025		// テキストの背景色を取得
#define global LVM_SETTEXTCOLOR		0x1024		// テキストの文字色を設定
#define global LVM_SETTEXTBKCOLOR	0x1026		// テキストの背景色を設定

#define global LVM_INSERTGROUP		0x1091		// グループを挿入
#define global LVM_ENABLEGROUPVIEW	0x109D		// グループ表示にする

// リストビューのスタイル
#define global LVS_ICON				0x0000		// 「大きいアイコン表示」
#define global LVS_REPORT			0x0001		// 「詳細表示」
#define global LVS_SMALLICON		0x0002		// 「小さいアイコン表示」
#define global LVS_LIST				0x0003		// 「一覧表示」
#define global LVS_SINGLESEL		0x0004		// 一つしか選択できないようにする (デフォルトでは複数選択可能)
#define global LVS_SHOWSELALWAYS	0x0008		// フォーカスを持ってなくても、選択状態が表示されるようにする
#define global LVS_SORTASCENDING	0x0010		// テキストをもとに昇順ソートする
#define global LVS_SORTDESCENDING	0x0020		// テキストをもとに降順ソートする
#define global LVS_SHAREIMAGELISTS	0x0040		// ListView が破棄される際に、ImageList を勝手に破棄しないようにする
#define global LVS_NOLABELWRAP		0x0080		// LVS_ICON のときに、アイテムのテキストを1行で表示されるようにします。（デフォルトでは複数行で表示されることがあります。）
#define global LVS_AUTOARRANGE		0x0100		// アイコン表示のとき、アイコンが整列した状態を維持させる ( LVS_ICON or LVS_SMALLICON )
#define global LVS_EDITLABELS		0x0200		// テキストを編集可能にする (親ウィンドウは LVN_ENDLABELEDIT を処理する必要がある)
#define global LVS_OWNERDATA		0x1000		// version 4.70 以降 : 仮想リストビューであることを示す
#define global LVS_NOSCROLL			0x2000		// スクロールを禁止する (非クライアント領域があってはならない)
#define global LVS_ALIGNTOP			0x0000		// アイコン表示の時、アイテムがリストビューの上端に並べられるようにする (デフォルト)
#define global LVS_ALIGNLEFT		0x0800		// アイコン表示の時、アイテムがリストビューの左側に並べられるようにする
#define global LVS_OWNERDRAWFIXED	0x0400		// 詳細表示 の時、オーナー描画であることを示す。アイテムのみ描画できる。
#define global LVS_NOCOLUMNHEADER	0x4000		// 詳細表示 の時、カラムヘッダを表示しない
#define global LVS_NOSORTHEADER		0x8000		// カラムヘッダのボタン機能を使用しない (カラムヘッダをクリックした時になにも処理をしないなら、指定すべき)

// リストビューの拡張スタイル
// ※ここで示したリストビューの拡張スタイルは LVM_SETEXTENDEDLISTVIEWSTYLE
// および LVM_GETEXTENDEDLISTVIEWSTYLE によって設定・取得をする必要があります (SetWindowLong じゃ駄目)
// version 4.70 以降のみ使用可能
#define global LVM_SETEXTENDEDLISTVIEWSTYLE	0x1036	// sendmsg hlist, LVM_SETEXTENDEDLISTVIEWSTYLE, 0 適用する拡張リストスタイル
#define global LVM_GETEXTENDEDLISTVIEWSTYLE	0x1037	// sendmsg hlist, LVM_GETEXTENDEDLISTVIEWSTYLE, 0, 0

#define global LVS_EX_GRIDLINES			0x0001		// 詳細表示 の時、罫線を表示
#define global LVS_EX_SUBITEMIMAGES		0x0002		// 詳細表示 の時、イメージがサブアイテムに表示されるようにする
#define global LVS_EX_CHECKBOXES		0x0004		// チェックボックス付き
#define global LVS_EX_TRACKSELECT		0x0008		// MouseCursor がアイテム上で一定時間停止した時、アイテムを選択する
#define global LVS_EX_HEADERDRAGDROP	0x0010		// 詳細表示 の時、ヘッダを Ｄ＆Ｄ してカラムの順序を入れ替え可能にする
#define global LVS_EX_FULLROWSELECT		0x0020		// 詳細表示 の時、アイテム選択時に列全体を強調表示する
#define global LVS_EX_ONECLICKACTIVATE	0x0040		// アイテムを Clickした時、親ウィンドウに LVN_ITEMACTIVATE を送る。アイテムがホットになると、強調表示する。
#define global LVS_EX_TWOCLICKACTIVATE	0x0080		// アイテムをWClickした時、親ウィンドウに LVN_ITEMACTIVATE を送る。アイテムがホットになると、強調表示する。
#define global LVS_EX_FLATSB			0x0100		// フラットスクロールバーを使用する
#define global LVS_EX_REGIONAL			0x0200		// LVS_ICON の時、アイテムのアイコンとテキストのみを含む Region を作成し WindowRegionに設定する。
#define global LVS_EX_INFOTIP			0x0400		// LVS_ICON の時、Tooltip が表示される場合、親ウィンドウに LVN_GETINFOTIP を送る。
#define global LVS_EX_UNDERLINEHOT		0x0800		// LVS_EX_ONECLICKACTIVATE or LVS_EX_TWOCLICKACTIVATE が設定されている場合に、ホットなアイテムのテキストに下線を引く
#define global LVS_EX_UNDERLINECOLD		0x1000		// LVS_EX_ONECLICKACTIVATE or LVS_EX_TWOCLICKACTIVATE が設定されている場合に、すべてのアイテムのテキストに下線を引く
#define global LVS_EX_MULTIWORKAREAS	0x2000		// LVS_AUTOARRANGE の時、1つ以上作業領域が定義されるまで自動整列しない

// LVCOLUMN.mask
#define global LVCF_FMT					0x0001		// fmt
#define global LVCF_WIDTH				0x0002		// cx
#define global LVCF_TEXT				0x0004		// pszText
#define global LVCF_SUBITEM				0x0008		// iSubItem
#define global LVCF_IMAGE				0x0010		// iImage	( version 4.70 以降 )
#define global LVCF_ORDER				0x0020		// iOrder	( version 4.70 以降 )

// LVCOLUMN.fmt
#define global LVCFMT_LEFT				0x0000		// 文字列を左詰にする
#define global LVCFMT_RIGHT				0x0001		// 右詰め
#define global LVCFMT_CENTER			0x0002		// 中央揃え
#define global LVCFMT_IMAGE				0x0800		// イメージ					( version 4.70 以降 )
#define global LVCFMT_BITMAP_ON_RIGHT	0x1000		// ビットマップを右側に表示	( version 4.70 以降 )
#define global LVCFMT_COL_HAS_IMAGES	0x8000		// ヘッダはイメージを含む	( version 4.70 以降 )

// LVITEM.mask
#define global LVIF_TEXT				0x0001		// pszText
#define global LVIF_IMAGE				0x0002		// iImage
#define global LVIF_PARAM				0x0004		// lParam
#define global LVIF_STATE				0x0008		// state
#define global LVIF_INDENT				0x0010		// iIndent
#define global LVIF_GROUPID				0x0100		// iGroupID
#define global LVIF_COLUMNS				0x0200		// cColumns
#define global LVIF_NORECOMPUTE			0x0800		// LVM_GETITEM を受け取ったら、文字列を取得するのに LVN_GETDISPINFO を発生させない。代わりに、pszText メンバに -1 (LPSTR_TEXTCALLBACK) を格納する。
#define global LVIF_DI_SETITEM			0x1000		// システムは、要求されたアイテム情報を格納しておき、後から情報を求めない。これは LVN_GETDISPINFO でのみ使用可能。

// LVITEM.state
#define global LVIS_FOCUSED			0x0001	// アイテムがフォーカスを持つ (周囲が点線で囲まれる)。フォーカスを持つアイテムはこれのみ
#define global LVIS_SELECTED		0x0002	// アイテムが選択されている。表示方法は syscolor に依存。複数選択もあり得る
#define global LVIS_CUT				0x0004	// アイテムは Cut & Paste の対象としてマークされている
#define global LVIS_DROPHILITED		0x0008	// Ｄ＆Ｄ の対象としてハイライト表示されている
#define global LVIS_ACTIVATING		0x0020	// (未使用)

// ヘッダコントロールに送るメッセージ
#define global HDM_GETITEMCOUNT		0x00001200		// アイテムの数を取得
#define global HDM_GETITEM			0x00001203		// 
#define global HDM_SETITEM			0x00001204		// 

#define global HDF_JUSTIFYMASK		0x00000003
#define global HDF_SORTUP			0x00000400
#define global HDF_SORTDOWN			0x00000200
#define global HDF_STRING			0x00004000

#define global HDI_FORMAT			0x00000004

//##################################################################################################

#ifdef  __USE_LVINT__
#define __IF_LPARAM_USE_ON__
#endif

#module Lvmod minfLv, mExStyle, mnItem, mnColumn, mbCustom, mbGroup, mcText, mcBack, LPRM

//------------------------------------------------
// マクロ
//------------------------------------------------
#define ArrayIns(%1,%2=0,%3=4)    memcpy %1,%1,(length(%1) - (%2) -1)*(%3),((%2)+1)*(%3),(%2)*(%3)
#define ArrayDel(%1,%2,%3=0,%4=4) memcpy %1,%1,(length(%2) - (%3) -1)*(%4),(%3)*(%4),((%3)+1)*(%4):memset %1,0,%4,((%3)*(%4))+((length(%2)-(%3)-1)*(%4))

#define ctype RGB(%1,%2,%3) ((%1) | (%2) << 8 | (%3) << 16)
#define ctype numrg(%1,%2,%3) (((%2) <= (%1)) && ((%1) <= (%3)))

#define mv modvar Lvmod@

//------------------------------------------------
// モジュール初期化
//------------------------------------------------
#deffunc local _initialize@Lvmod
	dim  lvcolumn, 8		// LVCOLUMN 構造体
	dim  lvitem  , 15		// LVITEM   構造体
	dim  lvgroup , 10		// LVGROUP  構造体
	dim  hditem  , 11		// HDITEM   構造体
	sdim pszText, 512		// pszText
	return
	
//##############################################################################
//                内部処理用関数
//##############################################################################
// 外部からの使用禁止！！

//------------------------------------------------
// int型一次元配列を拡張
//------------------------------------------------
#define RedimInt __RedimInt@Lvmod
#deffunc local __RedimInt@Lvmod array p1, int p2, local temp
	if ( length(p1) >= p2 ) { return }	// 増えない場合は無視
	dim    temp, length(p1)
	memcpy temp, p1, length(p1) * 4		// コピー
	dim    p1, p2
	memcpy p1, temp, length(temp) * 4	// 戻す
	return
	
//------------------------------------------------
// 挿入後の処理
//------------------------------------------------
#modfunc Inserted@Lvmod int p2
	if ( p2 < 0 ) { return }
	
 #ifdef __IF_LV_LPARAM_USE_ON__
		RedimInt   LPRM, mnItem + 1 : ArrayIns   LPRM, p2
 #endif
	if ( mbCustom ) {
		RedimInt mcText, mnItem + 1 : ArrayIns mcText, p2 : mcText(p2) = 0
		RedimInt mcBack, mnItem + 1 : ArrayIns mcBack, p2 : mcBack(p2) = 0xFFFFFF
	}
	mnItem ++
	return p2
	
//------------------------------------------------
// 削除後の処理
//------------------------------------------------
#modfunc Deleted@Lvmod int p2
	if ( p2 < 0 ) { return }
 #ifdef __IF_LV_LPARAM_USE_ON__
	ArrayDel       LPRM,   LPRM, p2		// 削除してシフトさせる
 #endif
	if ( mbCustom ) {
		ArrayDel mcText, mcText, p2
		ArrayDel mcBack, mcBack, p2
	}
	mnItem --
	return p2
	
//##########################################################
//        アイテムの文字列を設定・取得
//##########################################################
//------------------------------------------------
// アイテム文字列の設定
// modvar, "new str", iItem, iSubitem
//------------------------------------------------
#modfunc LvSetStr str p2, int p3, int p4
	pszText = p2
	lvitem  = 0x01, p3, p4, 0, 0, varptr(pszText)
	sendmsg minfLv,    0x1006, 0, varptr(lvitem)	// LVM_SETITEM
	return (stat)
	
//------------------------------------------------
// アイテム文字列の取得
//------------------------------------------------
#define global ctype LvGetStr(%1,%2=0,%3=0,%4=520) _LvGetStr(%1,%2,%3,%4)
#defcfunc _LvGetStr mv, int p2, int p3, int p4
	sdim  pszText, p4 + 1								// 取得バッファ
	lvitem = 0x01, p2, p3, 0, 0, varptr(pszText), p4
	sendmsg minfLv,   0x1005, 0, varptr(lvitem)			// LVM_GETITEM
	if ( stat ) {
		return pszText	// 成功時
	}
	return ""			// 失敗時
	
//------------------------------------------------
// カラム文字列の設定
// modvar, "new str", index
//------------------------------------------------
#modfunc LvSetColumnStr str p2, int p3
	pszText = p2
	hditem  = 0x02, 0, varptr(pszText)
	sendmsg minfLv, 0x101F, 0, 0				// LVM_GETHEADER
	sendmsg   stat, 0x1204, p3, varptr(hditem)	// HDM_SETITEM
	return    stat
	
//##########################################################
//        リストビューを生成
//##########################################################
//------------------------------------------------
// コンストラクタ
//------------------------------------------------
#define global CreateListview(%1,%2,%3,%4=1) newmod %1,Lvmod@,%2,%3,%4
#modinit int p2, int p3, int p4
	winobj "SysListView32", "", 0, 0x50000000 | p4, p2, p3
	minfLv = objinfo(stat, 2), stat
	
	// メンバ変数を作成
	dim mExStyle		// 拡張スタイル
	dim mnColumn		// カラムの数
	dim mnItem  		// カラム 0 のアイテムの数
	dim mbCustom		// カスタムモードかのフラグ
	dim mbGroup 		// グループビューかのフラグ
	dim mcText, 2		// 文字色
	dim mcBack, 2		// 背景色
	
	return minfLv(1)	// oID を返す
	
//##########################################################
//        カラム・アイテムの追加
//##########################################################
//------------------------------------------------
// カラムの追加
// @prmlist: m,"", index, cx, iSubItem
//------------------------------------------------
#define global LvInsertColumn(%1,%2,%3=-1,%4,%5) _LvInsertColumn %1,%2,%3,%4,%5
#modfunc _LvInsertColumn str p2, int p3, int p4, int p5
	pszText  = p2
	lvcolumn = 0x0F, 0x0000, p4, varptr(pszText), 0, p5
	sendmsg  minfLv, 0x101B, p3, varptr(lvcolumn)		// LVM_INSERTCOLUMN (カラムを追加)
	mnColumn ++
	return (stat)
	
//------------------------------------------------
// 文字列アイテムを挿入
// @prmlist: m, "", index
//------------------------------------------------
#define global LvInsertItem(%1,%2,%3=-1) _LvInsertItem %1,%2,%3
#modfunc _LvInsertItem str p2, int p3
	if ( p3 < 0 ) { n = mnItem } else { n = p3 }
	
	pszText = p2
	lvitem  = 0x01, n, 0, 0, 0, varptr(pszText)
	sendmsg minfLv, 0x1007, 0,  varptr(lvitem)		// LVM_INSERTITEM (アイテムを挿入)
	Inserted thismod, stat
	return (stat)
	
//------------------------------------------------
// イメージアイテムを挿入
//------------------------------------------------
#define global LvInsertImgItem(%1,%2,%3=-1) _LvInsertImgItem %1,%2,%3
#modfunc _LvInsertImgItem int p2, int p3
	if ( p3 < 0 ) { n = mnItem } else { n = p3 }
	
	lvitem  = 0x02, n, 0, 0, 0, 0, p2
	sendmsg minfLv, 0x1007, 0, varptr(lvitem)		// LVM_INSERTITEM
	Inserted thismod, stat
	return (stat)
	
//------------------------------------------------
// サブアイテムを設定
// @prmlist: m, "", index, iSubItem
//------------------------------------------------
#modfunc LvSetSub str p2, int p3, int p4
	pszText = p2
	lvitem  = 0x01, p3, p4, 0, 0, varptr(pszText)
	sendmsg minfLv, 0x1006, 0,    varptr(lvitem)	// LVM_SETITEM
	return (stat)
	
//##########################################################
//        アイテムの削除
//##########################################################
//------------------------------------------------
// アイテムを削除
//------------------------------------------------
#modfunc LvDelete int p2
	sendmsg minfLv, 0x1008, p2, 0	// LVM_DELETEITEM
	if ( stat == 0 ) {				// 削除に失敗した
		return 1
	}
	Deleted thismod
	return 0
	
//------------------------------------------------
// アイテムをすべて削除
//------------------------------------------------
#modfunc LvDeleteAll
	sendmsg minfLv, 0x1009, 0, 0	// LVM_DELETEALLITEMS
	if ( mbCustom ) {
		dim mcText, 2		// 文字色
		dim mcBack, 2		// 背景色
	}
	dim LPRM
	return
	
//##########################################################
//        アイテムの取得
//##########################################################
//------------------------------------------------
// アイテムの探索
//------------------------------------------------
#defcfunc LvGetTarget mv, int p2, int p3
	sendmsg minfLv, 0x100C, p2, p3		// LVM_GETNEXTITEM
	return stat
	
#define global ctype LvGetFocus(%1,%2=-1)    LvGetTarget(%1,%2,LVNI_FOCUSED)
#define global ctype LvGetSelected(%1,%2=-1) LvGetTarget(%1,%2,LVNI_SELECTED)
#define global ctype LvGetCut(%1,%2=-1)      LvGetTarget(%1,%2,LVNI_CUT)
#define global ctype LvGetDropped(%1,%2=-1)  LvGetTarget(%1,%2,LVNI_DROPHILIGHT)

#define global ctype LvGetNext(%1,%2=-1)  LvGetTarget(%1,%2,LVNI_ALL)
#define global ctype LvGetAbove(%1,%2=-1) LvGetTarget(%1,%2,LVNI_ABOVE)
#define global ctype LvGetBelow(%1,%2=-1) LvGetTarget(%1,%2,LVNI_BELOW)
#define global ctype LvGetLeft(%1,%2=-1)  LvGetTarget(%1,%2,LVNI_TOLEFT)
#define global ctype LvGetRight(%1,%2=-1) LvGetTarget(%1,%2,LVNI_TORIGHT)

//##########################################################
//        アイテムの設定
//##########################################################
#modfunc LvSetExStyle int p2
	mExStyle |= p2
	sendmsg minfLv, 0x1036, 0, mExStyle
	return
	
//##########################################################
//        アイテムの状態取得関数
//##########################################################
#defcfunc LvSelected mv, int p2
	sendmsg minfLv, 0x100C, p2, 0x0002			// LVM_GETNEXTITEM
	return stat
	
//##########################################################
//        イメージリスト関係
//##########################################################
#modfunc LvSetImgList int hIml
	sendmsg minfLv, 0x1001, hIml, 0				// LVM_SETIMAGELIST
	return
	
#modfunc LvSetImage int p2, int p3
	lvitem  = 0x02, p3, 0, 0, 0, 0, p2
	sendmsg minfLv, 0x1006, 0, varptr(lvitem)	// LVM_SETITEM
	return
	
//##########################################################
//        グループ化関係
//##########################################################
//------------------------------------------------
// GroupView にする
//------------------------------------------------
#modfunc LvEnbleGroupView int bEnable
	// wparam が真なら、グループビュー
	mbGroup = bEnable				// 記憶しておく
	sendmsg minfLv, 0x109D, 1, 0	// LVM_ENABLEGROUPVIEW
	return stat						// 0 = 設定済み, 正数 = 成功, 負数 = 失敗
	
//------------------------------------------------
// Group 追加
//------------------------------------------------
#define global LvInsertGroup(%1,%2,%3,%4=-1) _LvInsertGroup %1,%2,%3,%4
#modfunc _LvInsertGroup str sGroupName, int gID
	cnvstow pszText, sGroupName						// Unicode 文字列じゃないとダメらしい
	lvgroup = 40, 0x11, varptr(pszText), 319		// 設定
	sendmsg minfLv, 0x1091, gID, varptr(lvgroup)	// LVM_INSERTGROUP
	return stat
	
//##########################################################
//        その他
//##########################################################
//------------------------------------------------
// ヘッダに▲▼を表示する
//------------------------------------------------
#modfunc LvSetSortMark int iCol, int dir
	sendmsg minfLv, 0x101F, 0, 0			// LVM_GETHEADER ( カラムヘッダのハンドルを取得 )
	hHDR = stat								// ヘッダのハンドル
	sendmsg hHDR, 0x1200, 0, 0				// HDM_GETITEMCOUNT ( アイテム数を取得 )
	cntHDItem = stat						// アイテム数
	
	hditem(0) = 0x04		// mask (HDI_FORMAT)
	
    // 前回のマークを消去
	repeat cntHDItem
		sendmsg hHDR, 0x1203, cnt, varptr(hditem)	// HDM_GETITEM
		hditem(5) = hditem(5) & HDF_JUSTIFYMASK | HDF_STRING & (HDF_SORTDOWN ^ -1) & ((HDF_SORTUP ^ -1))	// fmt
		sendmsg hHDR, 0x1204, cnt, varptr(hditem)	// HDM_SETITEM
	loop
	
	// マークを表示
	sendmsg hHDR, 0x1203, iCol, varptr(hditem)		// HDM_GETITEM
	switch dir
	case 1
		hditem(5) = hditem(5) & HDF_JUSTIFYMASK | HDF_STRING | HDF_SORTUP		// fmt
		sendmsg hHDR, 0x1204, iCol, varptr(hditem)	// HDM_SETITEM
		swbreak
	case -1
		hditem(5) = hditem(5) & HDF_JUSTIFYMASK | HDF_STRING | HDF_SORTDOWN		// fmt
		sendmsg hHDR, 0x1204, iCol, varptr(hditem)	// HDM_SETITEM
		swbreak
	swend
	return
	
//##########################################################
//        カスタムドロー・モード
//##########################################################
//------------------------------------------------
// カスタムドロー・モードに設定する
//------------------------------------------------
#modfunc LvUseCustomMode
	LvSetExStyle thismod, 0x0020	// LVS_EX_FULLROWSELECT (一行選択モード)
	mbCustom = 1
	return
	
//------------------------------------------------
// カスタムドロー・モードか？
//------------------------------------------------
#defcfunc LvIsCustom mv, int p2
	return mbCustom
	
//------------------------------------------------
// 項目の文字色を設定
//------------------------------------------------
#modfunc LvCtTextColor int iItem, int cref
	mcText(iItem) = cref
	return
	
//------------------------------------------------
// 項目の背景色を設定
//------------------------------------------------
#modfunc LvCtBackColor int iItem, int cref
	mcBack(iItem) = cref
	return
	
//------------------------------------------------
// 項目の文字色を取得
//------------------------------------------------
#defcfunc LvTextColor mv, int iItem
	return mcText( iItem )
	
//------------------------------------------------
// 項目の背景色を取得
//------------------------------------------------
#defcfunc LvBackColor mv, int iItem
	return mcBack( iItem )
	
// 使用方法はサンプルの *Notify 参照
	
//##########################################################
//        関連int操作命令
//##########################################################
//------------------------------------------------
// 設定関数
//------------------------------------------------
#modfunc LvIntSet int p2, int p3
 #ifdef __IF_LV_LPARAM_USE_ON__
	LPRM( p2 ) = p3
 #endif
	return
	
//------------------------------------------------
// 取得関数
//------------------------------------------------
#defcfunc LvInt mv, int p2
 #ifdef __IF_LV_LPARAM_USE_ON__
	return LPRM( p2 )
 #else
	return 0	// 一応 0 を返す
 #endif

//##########################################################
//        内部参照関数
//##########################################################
#defcfunc LvHandle mv
	return minfLv
	
#defcfunc LvColumnNum mv
	return mnColumn
	
#defcfunc LvItemNum mv
	return mnItem
	
#global
_initialize@Lvmod

//##############################################################################
//                サンプル・プログラム
//##############################################################################
#if 0
#undef RGB
#define ctype RGB(%1,%2,%3) ((%1) | (%2) << 8 | (%3) << 16)

	// 0x0001 : 詳細表示
	// 0x0200 : テキスト編集可能
	// 0x8000 : カラムヘッダのボタン機能を停止
	CreateListview mLv, ginfo(12), ginfo(13), 0x0001 | 0x0200 ;| 0x8000
	hLv = objinfo(stat, 2)
	
	LvInsertColumn mLv, "名前", 0, 100, 0
	LvInsertColumn mLv, "読み", 1, 120, 1
	LvInsertColumn mLv, "備考", 2, 100, 2
	
	LvInsertItem   mLv, "在原業平"
	LvSetSub       mLv, "ありわらのなりひら", 0, 1
	LvCtTextColor  mLv, 0, RGB(255,   0,   0)
	LvCtBackColor  mLv, 0, RGB(  0, 255, 255)
	
	LvInsertItem   mLv, "僧正遍昭"
	LvSetSub       mLv, "そうじょうへんじょう", 1, 1
	LvCtTextColor  mLv, 1, RGB(  0,   0, 128)
	LvCtBackColor  mLv, 1, RGB(255, 255, 128)
	
	LvInsertItem   mLv, "喜撰法師"
	LvSetSub       mLv, "きせんほうし", 2, 1
	LvCtTextColor  mLv, 2, RGB(  0, 255,   0)
	LvCtBackColor  mLv, 2, RGB(255,   0, 255)
	
	LvInsertItem   mLv, "大伴黒主"
	LvSetSub       mLv, "おおとものくろぬし", 3, 1
	LvCtTextColor  mLv, 3, RGB(128,   0, 255)
	LvCtBackColor  mLv, 3, RGB(128, 255,   0)
	
	LvInsertItem   mLv, "文屋康秀"
	LvSetSub       mLv, "ふんやのやすひで", 4, 1
	LvCtTextColor  mLv, 4, RGB(255, 128,   0)
	LvCtBackColor  mLv, 4, RGB(  0, 128, 255)
	
	LvInsertItem   mLv, "小野小町"
	LvSetSub       mLv, "おののこまち", 5, 1
	LvCtTextColor  mLv, 5, RGB(255, 255, 255)
	LvCtBackColor  mLv, 5, RGB(  0,   0,   0)
	
	LvUseCustomMode mLv				// カスタムドロー・モードにする(解除不可)
	oncmd gosub *OnNotify, 0x004E	// 直後に指定
	
	// 0x0001 : グリッド(十字線)を表示
	// 0x0004 : チェックボックス
	// 0x0008 : マウスが一定時間止まれば選択
	// 0x0010 : カラムのＤ＆Ｄによる移動
	// 0x0020 : 一行すべてを選択表示
	LvSetExStyle mLv, 0x0001 | 0x0004 | 0x0008 | 0x0010 | 0x0020
	
	// カラムマークを設定
	LvSetSortMark mLv, 0, 1
	sortdir = 1
	sortcol = 0
	
	stop
	
// これ(↓)はコピペでいいです
*OnNotify
	dupptr nmhdr, lparam, 12
	
	if ( nmhdr(0) == hLv ) {		// hLv は ListView のハンドル
		
		// NM_CUSTOMDRAW (これはカスタムドローの処理)
		if ( nmhdr(2) == -12 ) {
			
			if ( LvIsCustom(mLv) ) {
				dupptr NMLVCUSTOMDRAW, lparam, 60		// NMLVCUSTOMDRAW 構造体
				
				if ( NMLVCUSTOMDRAW(3) == 0x0001 ) {	// CDDS_REPAINT (描画サイクルの前)
					return 0x0020						// CDRF_NOTIFYITEMDRAW (アイテムの描画処理を親に通知)
				}
				
				if ( NMLVCUSTOMDRAW(3) == 0x10001 ) {	// CDDS_ITEMREPAINT (描画前)
					NMLVCUSTOMDRAW(12) = LvTextColor(mLv, NMLVCUSTOMDRAW(9))	// 文字色
					NMLVCUSTOMDRAW(13) = LvBackColor(mLv, NMLVCUSTOMDRAW(9))	// 背景色
					return 0x0002
				}
			}
			
		// カラムがクリックされた( ▲▼マークの描画処理 )
		} else : if ( nmhdr(2) == 0xFFFFFF94 ) {		// LVN_COLUMNCLICK
			dupptr NM_LISTVIEW, lparam, 12 + 32				// NMLISTVIEW 構造体
			iCol = NM_LISTVIEW(4)							// クリックされたカラムのインデックス
			if ( iCol == sortcol ) {						// マークつきカラムなら
				sortdir *= -1									// 逆向きにする
			} else {										// 違ったら
				sortdir = 1										// 正方向に向かせる
			}
			// アイコンを設定( ソートされる )
			sortcol = iCol
			LvSetSortMark mLv, sortcol, sortdir
		}
	}
	return
	
#endif

#endif
