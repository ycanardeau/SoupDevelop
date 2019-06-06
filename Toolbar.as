
#ifndef mod_Toolbar
	
#module mod_Toolbar\
	m_objectID,\
	m_hwnd
	
	#modinit int _style, int _hbitmap, int _nImages,\
		local tbaddbitmap
		dim tbaddbitmap, 2
		
		winobj "ToolbarWindow32", "", 0, WS_CHILD | WS_VISIBLE | _style
		m_objectID = stat
		m_hwnd = objinfo_hwnd(m_objectID)
		sendmsg m_hwnd, TB_BUTTONSTRUCTSIZE, 20, 0
		sendmsg m_hwnd, TB_SETEXTENDEDSTYLE, 0, TBSTYLE_EX_DRAWDDARROWS
		if (_hbitmap == null) {
			tbaddbitmap(0) = -1
		} else {
			tbaddbitmap(0) = 0
		}
		tbaddbitmap(1) = _hbitmap
		sendmsg m_hwnd, TB_ADDBITMAP, _nImages, varptr(tbaddbitmap)
		return
	
	#modcfunc ToolbarGetWnd
		return m_hwnd
	
	#modfunc ToolbarAddButton int _iBitmap, int _idCommand, int _fsState, int _fsStyle, str _szText,\
		local tbbutton, local toolinfo,\
		local hTooltip,\
		local szText
		dim tbbutton, 5
		dim toolinfo, 10
		
		tbbutton(0) = _iBitmap
		tbbutton(1) = _idCommand
		tbbutton(2) = _fsState | (_fsStyle << 8)
		tbbutton(3) = 0
		tbbutton(4) = 0
		sendmsg m_hwnd, TB_ADDBUTTONS, 1, varptr(tbbutton)
		sendmsg m_hwnd, TB_AUTOSIZE, 0, 0
	
		sendmsg m_hwnd, TB_GETTOOLTIPS, 0, 0
		hTooltip = stat
		toolinfo(0) = 40
		toolinfo(1) = TTF_SUBCLASS
		toolinfo(2) = m_hwnd
		toolinfo(3) = _idCommand
		toolinfo(4) = 0
		toolinfo(5) = 0
		toolinfo(6) = 0
		toolinfo(7) = 0
		toolinfo(8) = hinstance
		szText = _szText
		toolinfo(9) = varptr(szText)
		toolinfo(10) = 0
		sendmsg m_hwnd, TB_GETRECT, _idCommand, varptr(toolinfo) + 16
		sendmsg hTooltip, TTM_ADDTOOL, 0, varptr(toolinfo)
		sendmsg m_hwnd, TB_SETTOOLTIPS, hTooltip, 0
		return
	
	#modfunc ToolbarEnableButton int _id, int _state
		sendmsg m_hwnd, TB_ENABLEBUTTON, _id, _state
		return
	
#global
	
#if 0
	
#enum IDM_NEW = 1
#enum IDM_OPEN
#enum IDM_SAVE
#enum IDM_CUT
#enum IDM_COPY
#enum IDM_PASTE
#enum IDM_UNDO
#enum IDM_REDO
	
	dimtype myToolbar, 5
	
	oncmd gosub *OnCommand, WM_COMMAND
	
	newmod myToolbar, mod_Toolbar, TBSTYLE_FLAT | TBSTYLE_TOOLTIPS | CCS_NODIVIDER, 0, 0
	ToolbarAddButton myToolbar, STD_FILENEW, IDM_NEW, 4, 0, "新規作成"
	ToolbarAddButton myToolbar, STD_FILEOPEN, IDM_OPEN, 4, 0, "開く
	ToolbarAddButton myToolbar, STD_FILESAVE, IDM_SAVE, 4, 0, "上書き保存"
	ToolbarAddButton myToolbar, , , , 1, ""
	ToolbarAddButton myToolbar, STD_CUT, IDM_CUT, 4, 0, "切り取り"
	ToolbarAddButton myToolbar, STD_COPY, IDM_COPY, 4, 0, "コピー"
	ToolbarAddButton myToolbar, STD_PASTE, IDM_PASTE, 4, 0, "貼り付け"
	ToolbarAddButton myToolbar, , , , 1, ""
	ToolbarAddButton myToolbar, STD_UNDO, IDM_UNDO, 4, 0, "元に戻す"
	ToolbarAddButton myToolbar, STD_REDOW, IDM_REDO, 4, 0, "やり直し"
	stop
	
*OnCommand
	switch (LOWORD(wparam))
		case IDM_NEW
			dialog "新規作成"
			swbreak
		case IDM_OPEN
			dialog "開く
			swbreak
		case IDM_SAVE
			dialog "上書き保存"
			swbreak
		case IDM_CUT
			dialog "切り取り"
			swbreak
		case IDM_COPY
			dialog "コピー"
			swbreak
		case IDM_PASTE
			dialog "貼り付け"
			swbreak
		case IDM_UNDO
			dialog "元に戻す"
			swbreak
		case IDM_REDO
			dialog "やり直し"
			swbreak
	swend
	return
	
#endif
	
#endif
