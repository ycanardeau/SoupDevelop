
#ifndef mod_TreeView
	
#include "comctl32.as"
#include "user32.as"
	
#module mod_TreeView\
	m_objectID,\
	m_hwnd
	
	#modinit int _exStyle, int _style, int _x, int _y, int _width, int _height
		InitCommonControls
		pos _x, _y
		winobj "SysTreeView32", "", _exStyle, WS_CHILD | WS_VISIBLE | _style, _width, _height//, hwnd, 0
		m_objectID = stat
		m_hwnd = objinfo_hwnd(m_objectID)
		return
	
	#modcfunc TreeViewGetWnd
		return m_hwnd
	
	#modfunc TreeViewMove int _x, int _y, int _width, int _height
		MoveWindow m_hwnd, _x, _y, _width, _height, true
		return
	
	#modcfunc TreeViewInsertItem int _hParent, int _hInst, int _imageIndex, str _szText, int _lParam,\
		local szText,\
		local tvins,\
		local ret
		szText = _szText
		dim tvins, 12
	
		tvins(0) = _hParent
		tvins(1) = _hInst
		tvins(2) = TVIF_TEXT | TVIF_IMAGE | TVIF_SELECTEDIMAGE | TVIF_PARAM
		tvins(3) = 0
		tvins(4) = 0
		tvins(5) = 0
		tvins(6) = varptr(szText)
		tvins(7) = 0
		tvins(8) = _imageIndex
		tvins(9) = _imageIndex
		tvins(10) = 0
		tvins(11) = _lParam
		sendmsg m_hwnd, TVM_INSERTITEM, 0, varptr(tvins)
		ret = stat
		return ret
	
	#modfunc TreeViewSetItem int _hItem, str _szText, int _lParam,\
		local szText,\
		local tvitem
		szText = _szText
		dim tvitem, 10
	
		tvitem(0) = TVIF_HANDLE | TVIF_PARAM | TVIF_TEXT
		tvitem(1) = _hItem
		tvitem(2) = 0
		tvitem(3) = 0
		tvitem(4) = varptr(szText)
		tvitem(5) = 0
		tvitem(6) = 0
		tvitem(7) = 0
		tvitem(8) = 0
		tvitem(9) = _lParam
		sendmsg m_hwnd, TVM_SETITEM, 0, varptr(tvitem)
		return
	
	#modfunc TreeViewSetImageList int _hImageList
		sendmsg m_hwnd, TVM_SETIMAGELIST, 0, _hImageList
		return
	
	#modfunc TreeViewExpand int _hItem, int _state
		sendmsg m_hwnd, TVM_EXPAND, _state, _hItem
		return
	
	#modfunc TreeViewDeleteItem int _hItem
		ShowWindow m_hwnd, SW_HIDE
		sendmsg m_hwnd, TVM_DELETEITEM, 0, _hItem
		ShowWindow m_hwnd, SW_SHOW
		return
	
	#modcfunc TreeViewGetNextItem int _flag, int _hItem
		sendmsg m_hwnd, TVM_GETNEXTITEM, _flag, _hItem
		return stat
	
	#modcfunc TreeViewHitTest int _x, int _y,\
		local point,\
		local tvhittestinfo,\
		local hItem,\
		local ret
		dim point, 2
		dim tvhittestinfo, 4
	
		point(0) = _x
		point(1) = _y
		ScreenToClient m_hwnd, varptr(point)
	
		tvhittestinfo(0) = point(0)
		tvhittestinfo(1) = point(1)
		tvhittestinfo(2) = 0
		tvhittestinfo(3) = 0
		sendmsg m_hwnd, TVM_HITTEST, 0, varptr(tvhittestinfo)
		hItem = stat
		if ((tvhittestinfo(2) & 4) == 0) {
			ret = null
		} else {
			ret = hItem
		}
		return ret
	
	#modfunc TreeViewSelectItem int _hItem
		sendmsg m_hwnd, TVM_SELECTITEM, TVGN_CARET, _hItem
		return
	
	#modcfunc TreeViewGetItemText int _hItem,\
		local tvitem,\
		local s
		sdim s, MAX_PATH
		dim tvitem, 10
	
		tvitem(0) = TVIF_TEXT
		tvitem(1) = _hItem
		tvitem(2) = 0
		tvitem(3) = 0
		tvitem(4) = varptr(s)
		tvitem(5) = MAX_PATH
		sendmsg m_hwnd, TVM_GETITEM, 0, varptr(tvitem)
		return s
	
	#modfunc TreeViewSetBold int _hItem,\
		local tvitem
		dim tvitem, 10
	
		tvitem(0) = TVIF_HANDLE | TVIF_STATE
		tvitem(1) = _hItem
		tvitem(2) = 16
		tvitem(3) = 16
		tvitem(4) = 0
		tvitem(5) = 0
		tvitem(6) = 0
		tvitem(7) = 0
		tvitem(8) = 0
		tvitem(9) = 0
		sendmsg m_hwnd, TVM_SETITEM, 0, varptr(tvitem)
		return
	
	#modcfunc TreeViewGetParam int _hItem,\
		local tvitem
		dim tvitem, 10
	
		tvitem(0) = TVIF_HANDLE | TVIF_STATE
		tvitem(1) = _hItem
		tvitem(2) = 0
		tvitem(3) = 0
		tvitem(4) = 0
		tvitem(5) = 0
		tvitem(6) = 0
		tvitem(7) = 0
		tvitem(8) = 0
		tvitem(9) = 0
		sendmsg m_hwnd, TVM_GETITEM, 0, varptr(tvitem)
		return tvitem(9)
	
	#modfunc TreeViewSortChildren int _hItem
		sendmsg m_hwnd, TVM_SORTCHILDREN, 0, _hItem
		return
	
	#modfunc TreeViewEditLabel int _hItem
		sendmsg m_hwnd, TVM_EDITLABEL, 0, _hItem
		return
	
	#modfunc TreeViewSortChild int _hItem
		sendmsg m_hwnd, TVM_SORTCHILDREN, 0, _hItem
		return
	
#global
	
#if 0
	
	dimtype myTreeView, 5
	
	newmod myTreeView, mod_TreeView, WS_EX_CLIENTEDGE, TVS_HASBUTTONS | TVS_HASLINES | TVS_LINESATROOT | TVS_INFOTIP | TVS_EDITLABELS, 0, 0, ginfo_winx, ginfo_winy
	hParent1 = TreeViewInsertItem(myTreeView, TVI_ROOT, 0xffff0002, 0, "親1")
	hParent2 = TreeViewInsertItem(myTreeView, TVI_ROOT, 0xffff0002, 0, "親2")
	hParent3 = TreeViewInsertItem(myTreeView, TVI_ROOT, 0xffff0002, 0, "親3")
	
	hChild1 = TreeViewInsertItem(myTreeView, hParent1, 0xffff0002, 0, "子1")
	hChild2 = TreeViewInsertItem(myTreeView, hParent2, 0xffff0002, 0, "子2")
	r = TreeViewInsertItem(myTreeView, hChild1, 0xffff0002, 0, "孫1")
	r = TreeViewInsertItem(myTreeView, hChild2, 0xffff0002, 0, "孫2")
	hChild3 = TreeViewInsertItem(myTreeView, hParent2, 0xffff0002, 0, "子3")
	hChild4 = TreeViewInsertItem(myTreeView, hParent3, 0xffff0002, 0, "子4")
	
	hBitmap = null
	TreeViewSetImageList myTreeView, hBitmap
	stop
	
#endif
	
#endif
