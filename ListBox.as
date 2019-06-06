
#ifndef mod_ListBox
	
#include "comctl32.as"
#include "gdi32.as"
	
#module mod_ListBox\
	m_hListBox,\
	m_hFont
	
	#modinit int _exStyle, int _style, str _string, int _x, int _y, int _width, int _height, int _index,\
		local bmscr,\
		local hFontOrg,\
		local logfont
		
		mref bmscr, 67
		
		InitCommonControls
		
		winobj "ListBox", "", _exStyle, WS_CHILD | WS_VISIBLE | WS_VSCROLL | LBS_NOINTEGRALHEIGHT | _style, _width, _height, hwnd, 0
		m_hListBox = objinfo_hwnd(stat)
		hFontOrg = bmscr(38)
		dim logfont
		GetObject hFontOrg, 60, varptr(logfont)
		m_hFont = CreateFontIndirect(varptr(logfont))
		sendmsg m_hListBox, WM_SETFONT, m_hFont, true
		ListBoxAddString thismod, _string
		sendmsg m_hListBox, LB_SETCURSEL, _index, 0
		return
	
	#modcfunc ListBoxGetWnd
		return m_hListBox
	
	#modfunc ListBoxAddString str _string,\
		local string,\
		local lineData,\
		local index
	
		string = _string
		sendmsg m_hListBox, WM_SETREDRAW, 0, 0
		notesel string
		sdim lineData
		index = 0
		repeat notemax
			getstr lineData, string, index
			index += strsize
			sendmsg m_hListBox, LB_ADDSTRING, 0, varptr(lineData)
		loop
		noteunsel
		sendmsg m_hListBox, WM_SETREDRAW, 1, 0
		return
	
	#modfunc ListBoxResetContent str _string
		sendmsg m_hListBox, LB_RESETCONTENT, 0, 0
		ListBoxAddString thismod, _string
		return
	
	#modcfunc ListBoxGetCurSel
		sendmsg m_hListBox, LB_GETCURSEL, 0, 0
		return stat
	
	#modfunc ListBoxSetCurSel int _index
		sendmsg m_hListBox, LB_SETCURSEL, _index, 0
		return
	
	#modcfunc ListBoxGetText int _index,\
		local text
		
		sdim text
		sendmsg m_hListBox, LB_GETTEXT, _index, varptr(text)
		return text
	
#global
	
#endif
