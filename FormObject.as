
#ifndef mod_FormObject
	
#include "user32.as"
#include "gdi32.as"
	
	
#module
	
	#deffunc SetPen int _hdc, int _style, int _width,\
		local bmscr,\
		local hPen
		
		dim bmscr
		mref bmscr, 67
		
		hPen = CreatePen(_style, _width, bmscr(40))
		DeleteObject SelectObject(_hdc, hPen)
		bmscr(37) = hPen
		return
	
#global
	
	
#module mod_FormObject
	
	#define global FOS_NONE		0
	#define global FOS_SELECT	1
	#define global FOS_MOVE		2
	
	#const SnapSize 1
	
	#deffunc FormObjectInit
		pointingObject = -1
		
		dim mx, 2 : dim my, 2
		dim dx : dim dy
		
		dim foi_x
		dim foi_y
		dim foi_width
		dim foi_height
		dim foi_style
		dim foi_state
		nFormObject = 0
		
		moving = false
		resizing = false
		clicking = false
		pointingControl = 0
		previousX = 0
		previousY = 0
		previousWidth = 0
		previousHeight = 0
	
		drawStartPosX = 0
		drawStartPosY = 0
	
		isEdit = false
		return
	
	/**
	 * FormObjectCreate _style, _state, _x, _y, _width, _height
	 * @brief FormObject を作成します。
	 * @param _style スタイル
	 * @param _state 状態
	 * @param _x X座標
	 * @param _y Y座標
	 * @param _width 幅
	 * @param _height 高さ
	 */
	#deffunc FormObjectCreate int _style, int _state, int _x, int _y, int _width, int _height
		foi_style(nFormObject) = _style
		foi_state(nFormObject) = _state
		foi_x(nFormObject) = _x
		foi_y(nFormObject) = _y
		foi_width(nFormObject) = _width
		foi_height(nFormObject) = _height
		nFormObject++
		return
	
	/**
	 * FormObjectGetCount
	 * @brief FormObject の数を取得します。
	 * @return FormObject の数
	 */
	#defcfunc FormObjectGetCount
		return nFormObject
	
	/**
	 * FormObjectGetX _id
	 * @brief FormObject のX座標を取得します。
	 * @param _id ID
	 * @return FormObject のX座標
	 */
	#defcfunc FormObjectGetX int _id
		return foi_x(_id)
	
	/**
	 * FormObjectGetY _id
	 * @brief FormObject のY座標を取得します。
	 * @param _id ID
	 * @return FormObject のY座標
	 */
	#defcfunc FormObjectGetY int _id
		return foi_y(_id)
	
	/**
	 * FormObjectGetWidth _id
	 * @brief FormObject の幅を取得します。
	 * @param _id ID
	 * @return FormObject の幅
	 */
	#defcfunc FormObjectGetWidth int _id
		return foi_width(_id)
	
	/**
	 * FormObjectGetHeight _id
	 * @brief FormObject の高さを取得します。
	 * @param _id ID
	 * @return FormObject の高さ
	 */
	#defcfunc FormObjectGetHeight int _id
		return foi_height(_id)
	
	#defcfunc FormObjectIsPointing int _id, int _x, int _y,\
		local x, local y, local w, local h
		
		x = foi_x(_id) - drawStartPosX
		y = foi_y(_id) - drawStartPosY
		w = foi_width(_id)
		h = foi_height(_id)
		return ( _x >= x ) & ( _x < x + w ) & ( _y >= y ) & (_y < y + h )
	
	#defcfunc FormObjectGetPointing int _x, int _y,\
		local result
		
		result = -1
		repeat nFormObject
			if (FormObjectIsPointing(cnt, _x, _y) != 0) {
				result = cnt
			}
		loop
		return result
	
	/**
	 * FormObjectGetPointing _x, _y
	 * @brief ポイントされている FormObject のIDを取得します。
	 * @param _x X座標
	 * @param _y Y座標
	 * @return ポイントされている FormObject のID
	 */
	#defcfunc FormObjectGetPointingObject
		return pointingObject
	
	#deffunc FormObjectSetPointingObject int _pointingObject
		pointingObject = _pointingObject
		return
	
	#defcfunc FormObjectIsPointingControl int _id, int _x, int _y,\
		local state, local x, local y, local w, local h
	
		state = foi_state(_id)
		x = foi_x(_id) - drawStartPosX
		y = foi_y(_id) - drawStartPosY
		w = foi_width(_id)
		h = foi_height(_id)
		if (state & 1) {
			if (_x >= x - 6) && (_x < x) && (_y >= y + 1) && (_y < y + h - 1) {
				// 左
				return 1
			}
		}
		if (state & 2) {
			if (_x >= x + 1) && (_x < x + w - 1) && (_y >= y - 6) && (_y < y) {
				// 上
				return 2
			}
		}
		if (state & 4) {
			if (_x >= x + w - 1) && (_x < x + w + 6) && (_y >= y + 1) && (_y < y + h - 1) {
				// 右
				return 4
			}
		}
		if (state & 8) {
			if (_x >= x + 1) && (_x < x + w - 1) && (_y >= y + h - 1) && (_y < y + h + 6) {
				// 下
				return 8
			}
		}
		if (state & (1 | 2)) {
			if (_x >= x - 6) && (_x < x + 1) && (_y >= y - 6) && (_y < y + 1) {
				// 左上
				return 1 | 2
			}
		}
		if (state & (2 | 4)) {
			if (_x >= x + w - 1) && (_x < x + w + 6) && (_y >= y - 6) && (_y < y + 1) {
				// 右上
				return 2 | 4
			}
		}
		if (state & (1 | 8)) {
			if (_x >= x - 6) && (_x < x + 1) && (_y >= y + h - 1) && (_y < y + h + 6) {
				// 左下
				return 1 | 8
			}
		}
		if (state & (4 | 8)) {
			if (_x >= x + w - 1) && (_x < x + w + 6) && (_y >= y + h - 1) && (_y < y + h + 6) {
				// 右下
				return 4 | 8
			}
		}
		return 0
	
	/**
	 * FormObject_MouseMove
	 * @brief WM_MOUSEMOVE メッセージが届いたときに呼び出してください。
	 */
	#deffunc FormObject_MouseMove\
		local selWndId,\
		local point,\
		local state, local x, local y, local w, local h
		
		selWndId = ginfo_sel
		gsel ginfo_intid
		
		dim point, 2
		point = ginfo_mx, ginfo_my
		ScreenToClient hwnd, varptr(point)
		mx(0) = point(0) : my(0) = point(1)
		
		changeCursor mx(0), my(0)
	
		if (clicking == true) {
		if (pointingControl != 0) {
			if (mx(0) / SnapSize * SnapSize != mx(1) / SnapSize * SnapSize || my(0) / SnapSize * SnapSize != my(1) / SnapSize * SnapSize) {
			if (pointingObject != -1) {
				state = foi_state(pointingObject)
				x = foi_x(pointingObject)
				y = foi_y(pointingObject)
				w = foi_width(pointingObject)
				h = foi_height(pointingObject)
				if (state & 1) {
					// 左
					if ((pointingControl & 1) != 0) {
						foi_width(pointingObject) = w + dx - mx(0)
						if (foi_width(pointingObject) != w) {
							foi_x(pointingObject) = (x + mx(0) - dx) / SnapSize * SnapSize
							dx = mx(0) / SnapSize * SnapSize
						}
					}
				}
				if (state & 2) {
					// 上
					if ((pointingControl & 2) != 0) {
						foi_height(pointingObject) = h + dy - my(0)
						if (foi_height(pointingObject) ! h) {
							foi_y(pointingObject) = (y + my(0) - dy) / SnapSize * SnapSize
							dy = my(0) / SnapSize * SnapSize
						}
					}
				}
				if (state & 4) {
					// 右
					if ((pointingControl & 4) != 0) {
						foi_width(pointingObject) = (mx(0) - x) / SnapSize * SnapSize + drawStartPosX
					}
				}
				if (state & 8) {
					// 下
					if ((pointingControl & 8) != 0) {
						foi_height(pointingObject) = (my(0) - y) / SnapSize * SnapSize + drawStartPosY
					}
				}
				
				if (previousX + previousY + previousWidth + previousHeight != 0) {
					drawResizeRect previousX - drawStartPosX, previousY - drawStartPosY, previousX - drawStartPosX + previousWidth, previousY - drawStartPosY + previousHeight
				}
				drawResizeRect foi_x(pointingObject) - drawStartPosX, foi_y(pointingObject) - drawStartPosY, foi_x(pointingObject) - drawStartPosX + foi_width(pointingObject), foi_y(pointingObject) - drawStartPosY + foi_height(pointingObject)
				previousX = foi_x(pointingObject)
				previousY = foi_y(pointingObject)
				previousWidth = foi_width(pointingObject)
				previousHeight = foi_height(pointingObject)
				isEdit = true
			}
			}
		}
		}
	
		if (clicking == true) {
			if (wparam == MK_LBUTTON) {
				if (mx(0) / SnapSize * SnapSize != mx(1) / SnapSize * SnapSize || my(0) / SnapSize * SnapSize != my(1) / SnapSize * SnapSize) {
					if (resizing == false && pointingObject != -1) {
						if (foi_style(pointingObject) & FOS_MOVE) {
							moving = true
						}
					}
				}
				
				if (moving == true) {
					// 移動
					foi_x(pointingObject) = (foi_x(pointingObject) + mx(0) - dx) / SnapSize * SnapSize
					foi_y(pointingObject) = (foi_y(pointingObject) + my(0) - dy) / SnapSize * SnapSize
					dx = mx(0) / SnapSize * SnapSize
					dy = my(0) / SnapSize * SnapSize
					
					if (previousX + previousY + previousWidth + previousHeight != 0) {
						drawResizeRect previousX - drawStartPosX, previousY - drawStartPosY, previousX - drawStartPosX + previousWidth, previousY - drawStartPosY + previousHeight
					}
					drawResizeRect foi_x(pointingObject) - drawStartPosX, foi_y(pointingObject) - drawStartPosY, foi_x(pointingObject) - drawStartPosX + foi_width(pointingObject), foi_y(pointingObject) - drawStartPosY + foi_height(pointingObject)
					previousX = foi_x(pointingObject)
					previousY = foi_y(pointingObject)
					previousWidth = foi_width(pointingObject)
					previousHeight = foi_height(pointingObject)
					isEdit = true
				}
			}
		}
		
		mx(1) = mx(0) : my(1) = my(0)
		
		gsel selWndId
		return
	
	#defcfunc FormObjectIsEdit int _id
		return isEdit
	
	/**
	 * FormObject_LButtonDown
	 * @brief WM_LBUTTONDOWN メッセージが届いたときに呼び出してください。
	 */
	#deffunc FormObject_LButtonDown\
		local selWndId,\
		local ret,\
		local point, local rect
		
		selWndId = ginfo_sel
		gsel ginfo_intid
		
		dim point, 2
		point = ginfo_mx, ginfo_my
		ScreenToClient hwnd, varptr(point)
		mx(0) = point(0) : my(0) = point(1)
	
		clicking = true
		isEdit = false
		
		changeCursor mx(0), my(0)
		
		SetCapture hwnd
		
		if (pointingObject != -1) {
			ret = FormObjectIsPointingControl(pointingObject, mx(0), my(0))
			if (ret != 0) {
				resizing = true
				pointingControl = ret
				dx = mx(0) / SnapSize * SnapSize
				dy = my(0) / SnapSize * SnapSize
			}
		}
		
		if (resizing == false) {
			pointingObject = FormObjectGetPointing(mx(0), my(0))
			if (pointingObject != -1) {
				if (foi_style(pointingObject) & FOS_SELECT) {
					dx = mx(0) / SnapSize * SnapSize
					dy = my(0) / SnapSize * SnapSize
				} else {
					pointingObject = -1
				}
			}
		}
		
		gsel selWndId
		return
	
	/**
	 * FormObject_LButtonUp
	 * @brief WM_LBUTTONUP メッセージが届いたときに呼び出してください。
	 */
	#deffunc FormObject_LButtonUp\
		local selWndId,\
		local rect
		
		selWndId = ginfo_sel
		gsel ginfo_intid
	
		clicking = false
		
		if (GetCapture() == hwnd) {
			ReleaseCapture
			
			if (previousX + previousY + previousWidth + previousHeight != 0) {
				drawResizeRect previousX - drawStartPosX, previousY - drawStartPosY, previousX - drawStartPosX + previousWidth, previousY - drawStartPosY + previousHeight
			}
			
			moving = false
			resizing = false
			pointingControl = 0
			previousX = 0
			previousY = 0
			previousWidth = 0
			previousHeight = 0
		}
		
		gsel selWndId
		return
	
	/**
	 * FormObject_SetCursor
	 * @brief WM_SETCURSOR メッセージが届いたときに呼び出してください。
	 */
	#defcfunc FormObject_SetCursor\
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
		local result,\
		local state, local x, local y, local w, local h
		
		if (GetCapture() == null) {
			result = FormObjectGetPointing(_x, _y)
			if (result != -1) {
				if (foi_style(result) & FOS_MOVE) {
					cursorType = IDC_SIZEALL
				} else {
					cursorType = IDC_ARROW
				}
			} else {
				cursorType = IDC_ARROW
			}
			if (pointingObject != -1){
				state = foi_state(pointingObject)
				w = foi_width(pointingObject)
				h = foi_height(pointingObject)
				switch (FormObjectIsPointingControl(pointingObject, _x, _y))
					case 1
						if (state & 1) {
							cursorType = IDC_SIZEWE
						}
						swbreak
					case 4
						if (state & 4) {
							cursorType = IDC_SIZEWE
						}
						swbreak
					case 2
						if (state & 2) {
							cursorType = IDC_SIZENS
						}
						swbreak
					case 8
						if (state & 8) {
							cursorType = IDC_SIZENS
						}
						swbreak
					case 3
						if ((state & 1) ! 0) && ((state & 2) ! 0) {
							cursorType = IDC_SIZENWSE
						}
						swbreak
					case 12
						if ((state & 4) ! 0) && ((state & 8) ! 0) {
							cursorType = IDC_SIZENWSE
						}
						swbreak
					case 9
						if ((state & 1) ! 0) && ((state & 8) ! 0) {
							cursorType = IDC_SIZENESW
						}
						swbreak
					case 6
						if ((state & 2) ! 0) && ((state & 4) ! 0) {
							cursorType = IDC_SIZENESW
						}
						swbreak
				swend
			}
		}
		SetCursor LoadCursor(0, cursorType)
		return
	
	/**
	 * FormObjectDrawSelectBox _id
	 * @brief 選択されているオブジェクトに枠を描画します。
	 * @param _id ID
	 */
	#deffunc FormObjectDrawSelectBox int _id,\
		local rect
		
		redraw 0
		dim rect, 4
		rect(0) = foi_x(_id) - drawStartPosX - 2
		rect(1) = foi_y(_id) - drawStartPosY - 2
		rect(2) = foi_x(_id) - drawStartPosX + foi_width(_id) + 2
		rect(3) = foi_y(_id) - drawStartPosY + foi_height(_id) + 2
		color 0, 0, 0
		DrawFocusRect hdc, varptr(rect)
		
		drawRectAnchors _id
		redraw 1
		return
	
	#deffunc FormObjectSetDrawStartPosX int _x
		drawStartPosX = _x
		return
	
	#deffunc FormObjectSetDrawStartPosY int _y
		drawStartPosY = _y
		return
	
	#deffunc local drawResizeRect int _x1, int _y1, int _x2, int _y2,\
		local hdcScreen
		
		hdcScreen = GetDCEx(hwnd, null, DCX_CACHE | DCX_LOCKWINDOWUPDATE)
		SetROP2 hdcScreen, R2_NOT
		SelectObject hdcScreen, GetStockObject(NULL_BRUSH)
		SetPen hdcScreen, 0, 4
		Rectangle hdcScreen, _x1 + 2, _y1 + 2, _x2 - 1, _y2 - 1
		ReleaseDC hwnd, hdcScreen
		return
	
	#deffunc local drawRectAnchors int _id,\
		local x, local y, local w, local h
		
		x = foi_x(_id) - drawStartPosX
		y = foi_y(_id) - drawStartPosY
		w = foi_width(_id)
		h = foi_height(_id)
		if (foi_state(_id) & 1) {
			// 左
			drawAnchor x - 3, y + (h - 2) / 2
		}
		if ((foi_state(_id) & 1) != 0) && ((foi_state(_id) & 2) != 0) {
			// 左上
			drawAnchor x - 3, y - 3
		}
		if ((foi_state(_id) & 1) != 0) && ((foi_state(_id) & 8) != 0) {
			// 左下
			drawAnchor x - 3, y + h + 2
		}
		if (foi_state(_id) & 2) {
			// 上
			drawAnchor x + (w - 2) / 2, y - 3
		}
		if (foi_state(_id) & 4) {
			// 右
			drawAnchor x + w + 2, y + (h - 2) / 2
		}
		if ((foi_state(_id) & 4) != 0) && ((foi_state(_id) & 2) != 0) {
			// 右上
			drawAnchor x + w + 2, y - 3
		}
		if ((foi_state(_id) & 4) != 0) && ((foi_state(_id) & 8) != 0) {
			// 右下
			drawAnchor x + w + 2, y + h + 2
		}
		if (foi_state(_id) & 8) {
			// 下
			drawAnchor x + (w - 2) / 2, y + h + 2
		}
		return
	
	#deffunc local drawAnchor int _x, int _y
		color 0, 0, 0
		boxf _x - 3, _y - 3, _x + 3, _y + 3
		color 255, 255, 255
		boxf _x - 2, _y - 2, _x + 2, _y + 2
		return
	
#global
	
	FormObjectInit
	
#endif
