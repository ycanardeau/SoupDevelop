
#ifndef mod_RectangleSelection
	
#include "user32.as"
#include "gdi32.as"
	
#module mod_RectangleSelection
	
	#deffunc RectangleSelectionInit
		dim m_startX : dim m_startY
		dim m_endX : dim m_endY
		dim m_isClicking
		return
	
	#deffunc RectangleSelectionGetRect array _rect
		_rect(0) = m_startX
		_rect(1) = m_startY
		_rect(2) = m_endX
		_rect(3) = m_endY
		return
	
	#deffunc RectangleSelection_MouseMove\
		local selWndId,\
		local point
	
		selWndId = ginfo_sel
		gsel ginfo_intid
	
		dim point, 2
		point = ginfo_mx, ginfo_my
		ScreenToClient hwnd, varptr(point)
	
		if (m_isClicking == true) {
			if (wparam == MK_LBUTTON) {
				drawRectangleSelection m_startX, m_startY, m_endX, m_endY
				m_endX = point(0) : m_endY = point(1)
				drawRectangleSelection m_startX, m_startY, m_endX, m_endY
			}
		}
	
		gsel selWndId
		return
	
	#deffunc RectangleSelection_LButtonDown\
		local selWndId,\
		local point
	
		selWndId = ginfo_sel
		gsel ginfo_intid
	
		m_isClicking = true
	
		SetCapture hwnd
	
		dim point, 2
		point = ginfo_mx, ginfo_my
		ScreenToClient hwnd, varptr(point)
		m_startX = point(0) : m_startY = point(1)
	
		m_endX = m_startX : m_endY = m_startY
	
		gsel selWndId
		return
	
	#deffunc RectangleSelection_LButtonUp\
		local selWndId
	
		selWndId = ginfo_sel
		gsel ginfo_intid
	
		m_isClicking = false
	
		if (GetCapture() == hwnd) {
			ReleaseCapture
			drawRectangleSelection m_startX, m_startY, m_endX, m_endY
		}
	
		gsel selWndId
		return
	
	#deffunc local drawRectangleSelection int _x1, int _y1, int _x2, int _y2,\
		local hdcScreen
		
		hdcScreen = GetDCEx(hwnd, null, DCX_CACHE | DCX_LOCKWINDOWUPDATE)
		SetROP2 hdcScreen, R2_NOT
		SelectObject hdcScreen, GetStockObject(NULL_BRUSH)
		Rectangle hdcScreen, _x1, _y1, _x2, _y2
		ReleaseDC hwnd, hdcScreen
		return
	
#global
	
	RectangleSelectionInit
	
#if 0
	
	oncmd gosub *OnMouseMove, WM_MOUSEMOVE
	oncmd gosub *OnLButtonDown, WM_LBUTTONDOWN
	oncmd gosub *OnLButtonUp, WM_LBUTTONUP
	stop
	
*OnMouseMove
	RectangleSelection_MouseMove
	return
	
*OnLButtonDown
	RectangleSelection_LButtonDown
	return
	
*OnLButtonUp
	RectangleSelection_LButtonUp
	dim rect, 4
	RectangleSelectionGetRect rect
	dialog "開始座標 " + rect(0) + ", " + rect(1) + "\n終了座標 " + rect(2) + ", " + rect(3)
	return
	
#endif
	
#endif