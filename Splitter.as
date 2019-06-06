	
#ifndef mod_Splitter
	
#include "user32.as"
#include "gdi32.as"
	
#module mod_Splitter
	
	/**
	 * SplitterInit
	 * @brief モジュールを初期化します。
	 */
	#deffunc SplitterInit
		dim beginX : dim beginY
		dim dx : dim dy
		dim endX : dim endY
		dim cursorType
		dim hittingSplitter
		
		cursorType = IDC_ARROW
		hittingSplitter = -1
		
		hCursorSizeNS = LoadCursor(0, IDC_SIZENS)
		hCursorSizeWE = LoadCursor(0, IDC_SIZEWE)
		hCursorArrow = LoadCursor(0, IDC_ARROW)
		
		nSplitter = 0
		return
	
	/**
	 * SplitterCreate _orientation, _thickness, _x, _y, _size, _min, _max
	 * @brief スプリッターを作成します。
	 * @param _orientation 向き
	 * @param _thickness 太さ
	 * @param _x X座標
	 * @param _y Y座標
	 * @param _size サイズ
	 * @param _min 最小値
	 * @param _max 最大値
	 */
	#deffunc SplitterCreate int _orientation, int _thickness, int _x, int _y, int _size, int _min, int _max,\
		local id
		
		id = nSplitter
		si_enabled(nSplitter) = true
		si_orientation(nSplitter) = _orientation
		if (_thickness > 0) {
			si_thickness(nSplitter) = _thickness
			si_isReverse(nSplitter) = 0
		}
		if (_thickness < 0) {
			si_thickness(nSplitter) = -_thickness
			si_isReverse(nSplitter) = 1
		}
		si_wndId(nSplitter)       = ginfo_sel
		si_x(nSplitter)           = _x
		si_y(nSplitter)           = _y
		si_size(nSplitter)        = _size
		si_min(nSplitter)         = _min
		si_max(nSplitter)         = _max
		nSplitter++
		return id
	
	#deffunc SplitterSetEnabled int _id, int _enabled
		si_enabled(_id) = _enabled
		return
	
	/**
	 * SplitterGetDistance _id
	 * @brief スプリッターの距離を取得します。
	 * @param _id ID
	 * @return スプリッターの距離
	 */
	#defcfunc SplitterGetDistance int _id,\
		local ret
		
		if (si_orientation(_id) == 0) {
			ret = si_y(_id)
		} else {
			ret = si_x(_id)
		}
		return ret
	
	/**
	 * SplitterGetDistance _id
	 * @brief スプリッターの位置を取得します。
	 * @param _id ID
	 * @return スプリッターの位置
	 */
	#defcfunc SplitterGetPos int _id,\
		local ret
		if (si_orientation(_id) == 0) {
			if (si_isReverse(_id) == 0) {
				ret = si_y(_id)
			} else {
				ret = ginfo_winy - (si_y(_id) + si_thickness(_id))
			}
		} else {
			if (si_isReverse(_id) == 0) {
				ret = si_x(_id)
			} else {
				ret = ginfo_winx - (si_x(_id) + si_thickness(_id))
			}
		}
		return ret
	
	/**
	 * SplitterGetDistance _id, _pos
	 * @brief スプリッターの位置を設定します。
	 * @param _id ID
	 * @param _pos スプリッターの位置
	 */
	#deffunc SplitterSetPos int _id, int _pos
		if (si_orientation(_id) == 0) {
			if (si_isReverse(_id) == 0) {
				si_y(_id) = _pos
			} else {
				si_y(_id) = ginfo_winy - (_pos + si_thickness(_id))
			}
		} else {
			if (si_isReverse(_id) == 0) {
				si_x(_id) = _pos
			} else {
				si_x(_id) = ginfo_winx - (_pos + si_thickness(_id))
			}
		}
		return
	
	#deffunc SplitterSetMessage
		oncmd gosub *OnMouseMove, WM_MOUSEMOVE
		oncmd gosub *OnLButtonDown, WM_LBUTTONDOWN
		oncmd gosub *OnLButtonUp, WM_LBUTTONUP
		oncmd gosub *OnSetCursor, WM_SETCURSOR
		return
	
	#defcfunc SplitterGetHitting
		if (hittingSplitter != -1) {
			if (ginfo_sel != si_wndId(hittingSplitter)) {
				return -1
			}
		}
		return hittingSplitter
	
	#define global SplitterMove(%1, %2, %3=-1, %4=-1, %5=-1) _SplitterMove %1, %2, %3, %4, %5
	#deffunc _SplitterMove int _id, int _size, int _pos, int _min, int _max
		si_size(_id) = _size
		if (_pos != -1) {
			if (si_orientation(_id) == 0) {
				si_x(_id) = _pos
			} else {
				si_y(_id) = _pos
			}
		}
		if (_min != -1) {
			si_min(_id) = _min
		}
		if (_max != -1) {
			si_max(_id) = _max
		}
		return
	
	*OnMouseMove
		Splitter_MouseMove
		return
	#deffunc Splitter_MouseMove\
		local selWndId,\
		local point,\
		local x, local y
		
		selWndId = ginfo_sel
		gsel ginfo_intid
		
		point = ginfo_mx, ginfo_my
		ScreenToClient hwnd, varptr(point)
		beginX = point(0) : beginY = point(1)
		
		if (hittingSplitter != -1) {
			if (GetCapture() == hwnd) {
				if (si_orientation(hittingSplitter) == 0) {
					y = SplitterGetPos(hittingSplitter)
					drawSplitter hittingSplitter, y + endY - dy
					drawSplitter hittingSplitter, y + beginY - dy
				} else {
					x = SplitterGetPos(hittingSplitter)
					drawSplitter hittingSplitter, x + endX - dx
					drawSplitter hittingSplitter, x + beginX - dx
				}
				endX = beginX : endY = beginY
			}
		} else {
			changeCursor beginX, beginY
		}
		
		gsel selWndId
		return
	
	*OnLButtonDown
		Splitter_LButtonDown
		return
	#deffunc Splitter_LButtonDown\
		local selWndId,\
		local point,\
		local x, local y
		
		selWndId = ginfo_sel
		gsel ginfo_intid
		
		point = ginfo_mx, ginfo_my
		ScreenToClient hwnd, varptr(point)
		beginX = point(0) : beginY = point(1)
		dx = beginX : dy = beginY
		
		changeCursor beginX, beginY
		
		hittingSplitter = getHitting(beginX, beginY)
		if (hittingSplitter != -1) {
			SetCapture hwnd
			if (si_orientation(hittingSplitter) == 0) {
				y = SplitterGetPos(hittingSplitter)
				drawSplitter hittingSplitter, y + beginY - dy
			} else {
				x = SplitterGetPos(hittingSplitter)
				drawSplitter hittingSplitter, x + beginX - dx
			}
		}
		endX = beginX : endY = beginY
		
		gsel selWndId
		return
	
	*OnLButtonUp
		Splitter_LButtonUp
		return
	#deffunc Splitter_LButtonUp\
		local selWndId,\
		local min, local max,\
		local x, local y
		
		selWndId = ginfo_sel
		gsel ginfo_intid
		
		if (GetCapture() == hwnd) {
			ReleaseCapture
			if (hittingSplitter != -1) {
				min = si_min(hittingSplitter)
				max = si_max(hittingSplitter)
				if (si_orientation(hittingSplitter) == 0) {
					y = SplitterGetPos(hittingSplitter) + beginY - dy
					y = limit(y, min, max)
					drawSplitter hittingSplitter, y
					SplitterSetPos hittingSplitter, y
				} else {
					x = SplitterGetPos(hittingSplitter) + beginX - dx
					x = limit(x, min, max)
					drawSplitter hittingSplitter, x
					SplitterSetPos hittingSplitter, x
				}
				sendmsg hwnd, WM_SIZE, 0, MAKELONG(ginfo_winx, ginfo_winy)
				hittingSplitter = -1
			}
		}
		
		gsel selWndId
		return
	
	*OnSetCursor
		return Splitter_SetCursor()
	#defcfunc Splitter_SetCursor\
		local selWndId,\
		local ret
		
		selWndId = ginfo_sel
		gsel ginfo_intid
		
		if (LOWORD(lparam) == 1) {
			ret = 0
		} else {
			ret = DefWindowProc(hwnd, WM_SETCURSOR, wparam, lparam)
		}
		
		gsel selWndId
		return ret
	
	#deffunc local changeCursor int _x, int _y,\
		local ret
		
		ret = getHitting(_x, _y)
		if (ret != -1) {
			if (si_orientation(ret) == 0) {
				SetCursor hCursorSizeNS
			} else {
				SetCursor hCursorSizeWE
			}
		} else {
			SetCursor hCursorArrow
		}
		return
	
	#deffunc local drawSplitter int _id, int _pos,\
		local rect
		
		dim rect, 4
		hdcScreen = GetDCEx(hwnd, 0, DCX_LOCKWINDOWUPDATE | DCX_PARENTCLIP | DCX_CLIPSIBLINGS)
		if (hdcScreen != null) {
			if (si_orientation(_id) == 0) {
				rect = si_x(_id), _pos, si_size(_id), si_thickness(_id)
				rect(1) = limit(rect(1), si_min(_id), si_max(_id))
			} else {
				rect = _pos, si_y(_id), si_thickness(_id), si_size(_id)
				rect(0) = limit(rect(0), si_min(_id), si_max(_id))
			}
			PatBlt hdcScreen, rect(0), rect(1), rect(2), rect(3), PATINVERT
		}
		ReleaseDC hwnd, hdcScreen
		return
	
	#defcfunc local getHitting int _x, int _y,\
		local ret
		
		ret = -1
		repeat nSplitter
			if (isHitting(cnt, _x, _y) == true) {
				ret = cnt
				break
			}
		loop
		return ret
	
	#defcfunc local isHitting int _id, int _x, int _y,\
		local rect,\
		local x, local y
		
		if (ginfo_sel != si_wndId(_id)) {
			return -1
		}
		
		if (si_enabled(_id) == false) {
			return -1
		}
		
		dim rect, 4
		if (si_orientation(_id) == 0) {
			y = SplitterGetPos(_id)
			rect = si_x(_id), y, si_x(_id) + si_size(_id), y + si_thickness(_id)
		} else {
			x = SplitterGetPos(_id)
			rect = x, si_y(_id), x + si_thickness(_id), si_y(_id) + si_size(_id)
		}
		return PtInRect(varptr(rect), _x, _y)
	
#global
	
	SplitterInit
	
#if 0
	
#cmpopt varinit 1
	
#include "user32.as"
	
	bgscr 0, ginfo_dispx, ginfo_dispy, screen_hide
	SetWindowLong hwnd, -16, WS_OVERLAPPEDWINDOW
	
	SplitterCreate 1, -6, 160
	SplitterSetMessage
	
	oncmd gosub *OnSize, WM_SIZE
	
	width 800, 600, ginfo_dispx - 800 >> 1, ginfo_dispy - 600 >> 1
	
	gsel 0, 1
	stop
	
*OnSize
	gsel ginfo_intid
	
	SplitterMove 0, ginfo_winy, 0, 0, ginfo_winx - 6
	
	redraw 0
	color 255, 255, 255 : boxf
	syscolor 15
	x = SplitterGetPos(0)
	boxf x, 0, x + 5, ginfo_winy
	redraw 1
	return
	
#endif
	
#endif
