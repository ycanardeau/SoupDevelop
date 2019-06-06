
#ifndef mod_WindowScrollBar
	
#include "user32.as"
	
#module mod_WindowScrollBar
	
	#deffunc groll2 int _x, int _y,\
		local rect,\
		local scrollPos,\
		local hObject
		
		dim rect, 4
		scrollPos = ginfo_vx, ginfo_vy
		repeat
			hObject = FindWindowEx(hwnd, hObject, 0, 0)
			if (hObject == null) {
				break
			}
			GetWindowRect hObject, varptr(rect)
			ScreenToClient hwnd, varptr(rect)
			SetWindowpos hObject, 0, rect(0) + scrollPos(0) - ginfo_vx, rect(1) + scrollPos(1) - ginfo_vy, 0, 0, 0x115
		loop
		return
	
	#deffunc WindowScrollBarInit
		return
	
	#deffunc WindowScrollBarCreate int _style, int _min, int _max, int _page, int _pos,\
		local scrollinfo
		
		SetStyle hwnd, GWL_STYLE, _style
		
		dim scrollinfo, 7
		scrollinfo(0) = 28
		scrollinfo(1) = SIF_ALL | SIF_DISABLENOSCROLL
		scrollinfo(2) = _min
		scrollinfo(3) = _max
		scrollinfo(4) = _page
		scrollinfo(5) = _pos
		scrollinfo(6) = 0
		switch (_style)
			case WS_HSCROLL
				SetScrollInfo hwnd, SB_HORZ, varptr(scrollinfo), true
				swbreak
			case WS_VSCROLL
				SetScrollInfo hwnd, SB_VERT, varptr(scrollinfo), true
				swbreak
		swend
		return
	
	#deffunc WindowScrollBarSetMessage
		oncmd gosub *OnScroll, WM_VSCROLL
		oncmd gosub *OnScroll, WM_HSCROLL
		oncmd gosub *OnWheel, WM_MOUSEWHEEL
		oncmd gosub *OnWheel, 0x0000020e/*WM_MOUSEHWHEEL*/
		return
	
	#defcfunc WindowScrollBarGetPos int _nBar
		return GetScrollPos(hwnd, _nBar)
	
	#deffunc WindowScrollBarSetPos int _nBar, int _nPos
		SetScrollPos hwnd, _nBar, _nPos, true
		return
	
	#deffunc WindowScrollBarGetInfo int _nBar, var _min, var _max, var _page,\
		local scrollinfo
		
		dim scrollinfo, 7
		scrollinfo(0) = 28
		scrollinfo(1) = SIF_ALL | SIF_DISABLENOSCROLL
		GetScrollInfo hwnd, _nBar, varptr(scrollinfo)
		_min = scrollinfo(2)
		_max = scrollinfo(3)
		_page = scrollinfo(4)
		return
	
	#defcfunc WindowScrollBarGetMax int _nBar,\
		local min, local max, local page
		
		WindowScrollBarGetInfo _nBar, min, max, page
		return max
	
	#deffunc WindowScrollBarSetInfo int _nBar, int _min, int _max, int _page,\
		local scrollinfo
		
		dim scrollinfo, 7
		scrollinfo(0) = 28
		scrollinfo(1) = SIF_ALL | SIF_DISABLENOSCROLL
		GetScrollInfo hwnd, _nBar, varptr(scrollinfo)
		scrollinfo(2) = _min
		scrollinfo(3) = _max
		scrollinfo(4) = _page
		SetScrollInfo hwnd, _nBar, varptr(scrollinfo), true
		return
	
	*OnSize
		WindowScrollBar_Size
		return
	#deffunc WindowScrollBar_Size\
		local selWndId,\
		local m
		
		selWndId = ginfo_sel
		gsel ginfo_intid
		
		m = iparam = 0x20a
		
		gsel selWndId
		return
	
	*OnWheel
		WindowScrollBar_Wheel
		return
	#deffunc WindowScrollBar_Wheel\
		local selWndId,\
		local m
		
		selWndId = ginfo_sel
		gsel ginfo_intid
		
		m = iparam == 0x20a
		SetScrollPos hwnd, m, WindowScrollBarGetPos(m) - (wparam >> 18) / 30 * 3, true
		
		gsel selWndId
		return
	
	*OnScroll
		WindowScrollBar_Scroll
		return
	#deffunc WindowScrollBar_Scroll\
		local selWndId,\
		local m,\
		local scrollinfo
		
		selWndId = ginfo_sel
		gsel ginfo_intid
		
		m = iparam == 0x115
		
		dim scrollinfo, 7
		scrollinfo(0) = 28
		scrollinfo(1) = SIF_ALL
		GetScrollInfo hwnd, m, varptr(scrollinfo)
		switch (LOWORD(wparam))
			case SB_LINELEFT
				scrollinfo(5)--
				swbreak
			case SB_LINERIGHT
				scrollinfo(5)++
				swbreak
		
			case SB_PAGELEFT
				scrollinfo(5) -= scrollinfo(4)
				swbreak
			case SB_PAGERIGHT
				scrollinfo(5) += scrollinfo(4)
				swbreak
		
			case SB_LEFT
				scrollinfo(5) = scrollinfo(2)
				swbreak
			case SB_RIGHT
				scrollinfo(5) = scrollinfo(3)
				swbreak
		
			case SB_THUMBPOSITION
			case SB_THUMBTRACK
				scrollinfo(5) = scrollinfo(6)
				swbreak
		
			default
				return
		swend
		SetScrollPos hwnd, m, scrollinfo(5), true
		
		gsel selWndId
		return
	
#global
	
#if 0
	
#include "user32.as"
	
	bgscr 0, ginfo_dispx, ginfo_dispy, screen_hide
	SetWindowLong hwnd, GWL_STYLE, WS_OVERLAPPEDWINDOW
	WindowScrollBarCreate WS_HSCROLL, 0, 2, 1, 0
	WindowScrollBarCreate WS_VSCROLL, 0, 1, 1, 0
	oncmd gosub *OnScroll, WM_HSCROLL
	oncmd gosub *OnScroll, WM_VSCROLL
	width 300, 300
	gsel 0, 1
	stop
	
*OnScroll
	WindowScrollBar_Scroll
	title "" + WindowScrollBarGetPos(SB_HORZ) + ":" + WindowScrollBarGetPos(SB_VERT)
	return
	
#endif
	
#endif