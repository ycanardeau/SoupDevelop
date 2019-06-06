
#ifndef mod_Rebar
	
#include "comctl32.as"
#include "user32.as"
	
#module mod_Rebar\
	m_objectId,\
	m_hRebar,\
	m_rebarbandinfo
	
	#modinit int _hbitmap,\
		local icce,\
		local rebarinfo
		
		dim icce, 2
		icce = 8, ICC_BAR_CLASSES | ICC_COOL_CLASSES
		InitCommonControlsEx varptr(icce)
		
		dim rebarinfo, 3
		dim m_rebarbandinfo, 20
		
		winobj "ReBarWindow32", "", 0, WS_CHILD | WS_VISIBLE | WS_CLIPSIBLINGS | WS_CLIPCHILDREN | CCS_NODIVIDER
		m_objectId = stat
		m_hRebar = objinfo_hwnd(stat)
		rebarinfo(0) = 12
		sendmsg m_hRebar, RB_SETBARINFO, 0, varptr(rebarinfo)
		m_rebarbandinfo(0) = 80
		m_rebarbandinfo(1) = RBBIM_LPARAM | RBBIM_IDEALSIZE | RBBIM_BACKGROUND | RBBIM_SIZE | RBBIM_CHILDSIZE | RBBIM_CHILD | RBBIM_STYLE
		m_rebarbandinfo(2) = RBBS_USECHEVRON | RBBS_VARIABLEHEIGHT
		m_rebarbandinfo(12) = _hbitmap
		return
	
	#modcfunc RebarGetId
		return m_objectId
	
	#modcfunc RebarGetWnd
		return m_hRebar
	
	#modcfunc RebarGetHeight\
		local rect, local rebarHeight
		
		dim rect, 4
		GetWindowRect m_hRebar, varptr(rect)
		rebarHeight = rect(3) - rect(1)
		return rebarHeight
	
	#modfunc RebarInsertBand int _hwndChild
		m_rebarbandinfo(8) = _hwndChild
		m_rebarbandinfo(10) = 25
		m_rebarbandinfo(11) = 0
		m_rebarbandinfo(14) = 22
		m_rebarbandinfo(15) = 22
		sendmsg m_hRebar, RB_INSERTBAND, -1, varptr(m_rebarbandinfo)
		return
	
	#modfunc Rebar_Resize
		MoveWindow m_hRebar, 0, 0, ginfo_winx, 0, true
		return
	
#global
	
#if 0
	
#include "Toolbar.hsp"
	
#enum IDM_NEW = 0
#enum IDM_OPEN
#enum IDM_SAVE
#enum IDM_CUT
#enum IDM_COPY
#enum IDM_PASTE
	
	dimtype rebar, 5
	newmod rebar, mod_Rebar, null
	
	dimtype toolbar, 5
	
	newmod toolbar, mod_Toolbar, TBSTYLE_FLAT | TBSTYLE_TOOLTIPS | CCS_NODIVIDER | CCS_NORESIZE, 0, 0
	ToolbarAddButton toolbar(0), STD_FILENEW, IDM_NEW, 4, 0, "新規作成"
	ToolbarAddButton toolbar(0), STD_FILEOPEN, IDM_OPEN, 4, 0, "開く"
	ToolbarAddButton toolbar(0), STD_FILESAVE, IDM_SAVE, 4, 0, "上書き保存"
	RebarInsertBand rebar, ToolbarGetWnd(toolbar(0))
	
	newmod toolbar, mod_Toolbar, TBSTYLE_FLAT | TBSTYLE_TOOLTIPS | CCS_NODIVIDER | CCS_NORESIZE, 0, 0
	ToolbarAddButton toolbar(1), STD_CUT, IDM_CUT, 4, 0, "切り取り"
	ToolbarAddButton toolbar(1), STD_COPY, IDM_COPY, 4, 0, "コピー"
	ToolbarAddButton toolbar(1), STD_PASTE, IDM_PASTE, 4, 0, "貼り付け"
	RebarInsertBand rebar, ToolbarGetWnd(toolbar(1))
	
	oncmd gosub *OnCommand, WM_COMMAND
	
	stop
	
*OnCommand
	if (lparam == ToolbarGetWnd(toolbar)) {
		switch (LOWORD(wparam))
			case IDM_NEW
				dialog "新規作成"
				swbreak
			case IDM_OPEN
				dialog "開く"
				swbreak
			case IDM_SAVE
				dialog "上書き保存"
				swbreak
		swend
	}
	return
	
	stop
	
#endif
	
#endif
