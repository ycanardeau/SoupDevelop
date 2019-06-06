/* StatusBar Module ver.1.00 */
	
#ifndef __STATUSBAR_AS__INCLUDED__
#define __STATUSBAR_AS__INCLUDED__
	
#include "user32.as"
#include "comctl32.as"
	
#module mod_StatusBar\
	m_objectId,\
	m_hStatusBar
	
	#modinit var p1, int _style, int _exStyle
		InitCommonControls
		
		winobj "msctls_statusbar32", "", _exStyle, WS_CHILD | WS_VISIBLE | _style, 0, 0, hwnd, 0
		m_objectId = stat
		m_hStatusBar = objinfo_hwnd(stat)
		
		sendmsg m_hStatusBar, SB_SETPARTS, length(p1), varptr(p1)
		return
	
	#modcfunc StatusBarGetId
		return m_objectId
	
	#modcfunc StatusBarGetWnd
		return m_hStatusBar
	
	#modcfunc StatusBarGetHeight\
		local rect, local statusBarHeight
		
		dim rect, 4
		GetWindowRect m_hStatusBar, varptr(rect)
		statusBarHeight = rect(3) - rect(1)
		return statusBarHeight
	
	#modfunc StatusBar_Resize
		sendmsg m_hStatusBar, WM_SIZE, 0, 0
		return
	
#global
	
#if 0
	
#include "user32.as"
	
	bgscr 0, ginfo_dispx, ginfo_dispy, screen_hide
	SetWindowLong hwnd, -16, WS_OVERLAPPEDWINDOW
	
	dimtype statusBar, 5
	
	parts = -1
	newmod statusBar, MStatusBar, parts, 0, 0
	
	oncmd gosub *OnSize, WM_SIZE
	
	width 800, 600, ginfo_dispx - 800 >> 1, ginfo_dispy - 600 >> 1
	gsel 0, 1
	
	stop
	
*OnSize
	StatusBar_Resize statusBar
	return
	
#endif
	
#endif
