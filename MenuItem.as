/* MenuItem Module ver.1.00 */
	
#ifndef __MENUITEM_AS__INCLUDED__
#define __MENUITEM_AS__INCLUDED__
	
#include "user32.as"
#include "gdi32.as"
	
#module mod_MenuItem
	
	#deffunc MenuItemInit
		hFont = GetStockObject(17)
		
		syscolor 15
		colorBtnFace(0) = RGB(ginfo_r, ginfo_g, ginfo_b)
		colorBtnFace(1) = RGB(200 + int(1.0 * ginfo_r / (255.0 / 55.0) + 0.5), 200 + int(1.0 * ginfo_g / (255.0 / 55.0) + 0.5), 200 + int(1.0 * ginfo_b / (255.0 / 55.0) + 0.5))
		hBrush(0) = CreateSolidBrush(colorBtnFace(1))
		syscolor 13
		hBrush(1) = CreateSolidBrush(RGB(181 + int(1.0 * ginfo_r / (255.0 / 74.0) + 0.5), 181 + int(1.0 * ginfo_g / (255.0 / 74.0) + 0.5), 181 + int(1.0 * ginfo_b / (255.0 / 74.0) + 0.5)))
		hBrush(2) = CreateSolidBrush(RGB(ginfo_r, ginfo_g, ginfo_b))
		
		dim mii_hmenu
		dim mii_style
		dim mii_id
		dim mii_hMenuIcon
		sdim mii_text, 64, 2
		dim mii_textSize, 2
		dim mii_accel
		dim mii_hPopup
		nMenuItem = 0
		return
	
	#deffunc MenuItemDestroy onexit
		repeat length(hBrush)
			DeleteObject hBrush(cnt)
		loop
		return
	
	#deffunc MenuItemSetMessage
		oncmd gosub *OnMeasureItem, WM_MEASUREITEM
		oncmd gosub *OnDrawItem, WM_DRAWITEM
		oncmd gosub *OnMenuChar, WM_MENUCHAR
		return
	
	#deffunc MenuItemAdd int _hmenu, int _style, int _id, str _text, int _hMenuIcon,\
		local text
		
		AppendMenu _hmenu, MF_OWNERDRAW | _style, _id, nMenuItem
		mii_hmenu(nMenuItem) = _hmenu
		mii_style(nMenuItem) = _style
		mii_id(nMenuItem) = _id
		mii_hMenuIcon(nMenuItem) = _hMenuIcon
		text = _text
		getstr mii_text(0, nMenuItem), text, 0, '\t'
		getstr mii_text(1, nMenuItem), text, strsize, 0
		mii_accel(nMenuItem) = peek(mii_text(0, nMenuItem), instr(mii_text(0, nMenuItem), 0, "&") + 1) + 0x20
		mii_hPopup(nMenuItem) = _hmenu
		nMenuItem++
		return
	
	*OnMeasureItem
		MenuItem_MeasureItem
		return
	#deffunc local MenuItem_MeasureItem\
		local mis,\
		local hOldFont,\
		local size
		
		dim mis
		dupptr mis, lparam, 24
		
		hOldFont = SelectObject(hdc, hFont)
		dim size, 2
		GetTextExtentPoint32 hdc, mii_text(0, mis(5)), strlen(mii_text(0, mis(5))), varptr(size) + 0
		GetTextExtentPoint32 hdc, mii_text(1, mis(5)), strlen(mii_text(1, mis(5))), varptr(size) + 4
		SelectObject hdc, hOldFont
		if (mis(5) >= 0 && mis(5) < nMenuItem) {
			if ((mii_style(mis(5)) & MF_SEPARATOR) != 0) {
				mii_textSize(0, mis(5)) = 0
				mis(4) = 6
			} else {
				mii_textSize(0, mis(5)) = size(0)
				mii_textSize(1, mis(5)) = size(1)
				mis(3) = size(0) + size(1)
				mis(4) = 22
			}
		}
		mis(3) += 61
		return
	
	*OnDrawItem
		MenuItem_DrawItem
		return
	#deffunc local MenuItem_DrawItem\
		local dis,\
		local rect
		
		dim dis
		dupptr dis, lparam, 48
		
		rect = dis(7), dis(8), dis(9), dis(10)
		
		FillRect dis(6), varptr(rect), hBrush(0)
		gradf dis(6), 0, dis(8), 24, dis(10) - dis(8), 0, colorBtnFace(1), colorBtnFace(0)
		if ((dis(4) & ODS_GRAYED) != 0) {
			if ((dis(4) & ODS_SELECTED) != 0) {
				FrameRect dis(6), varptr(rect), hBrush(2)
			} else {
				
			}
			if (mii_hMenuIcon(dis(11)) != null) {
				DrawState dis(6), null, null, mii_hMenuIcon(dis(11)), 0, dis(7) + 3, dis(8) + 3, 16, 16, DST_ICON | DSS_DISABLED
			}
			syscolor 17
			SetTextColor dis(6), RGB(ginfo_r, ginfo_g, ginfo_b)
		} else {
			if ((dis(4) & ODS_SELECTED) != 0) {
				FillRect dis(6), varptr(rect), hBrush(1)
				FrameRect dis(6), varptr(rect), hBrush(2)
			} else {
				
			}
			if (mii_hMenuIcon(dis(11)) != null) {
				DrawState dis(6), null, null, mii_hMenuIcon(dis(11)), 0, dis(7) + 3, dis(8) + 3, 16, 16, DST_ICON
			}
			syscolor 7
			SetTextColor dis(6), RGB(ginfo_r, ginfo_g, ginfo_b)
		}
		if ((mii_style(dis(11)) & MF_SEPARATOR) != 0) {
			hPen = CreatePen(0, 1, RGB(166, 166, 166))
			hOldPen = SelectObject(dis(6), hPen)
			MoveToEx dis(6), 27, rect(1) + 3, 0
			LineTo dis(6), rect(2), rect(1) + 3
			SelectObject dis(6), hOldPen
			DeleteObject hPen
		}
		SelectObject dis(6), hFont
		oldBkMode = SetBkMode(dis(6), 1)
		rect(1) += 5
		rect(0) += 35
		DrawText dis(6), varptr(mii_text(0, dis(11))), -1, varptr(rect), 0
		rect(0) = rect(2) - mii_textSize(1, dis(11)) - 31
		DrawText dis(6), varptr(mii_text(1, dis(11))), -1, varptr(rect), 0
		SetBkMode dis(6), oldBkMode
		return
	
	*OnMenuChar
		MenuItem_MenuChar
		return stat
	#deffunc local MenuItem_MenuChar\
		local ret, local i
		
		ret = 0 : i = 0
		repeat nMenuItem
			if (lparam != mii_hPopup(cnt)) {
				i++
				continue
			}
			if (LOWORD(wparam) == mii_accel(cnt)) {
				ret = MAKELONG(cnt - i, MNC_EXECUTE)
				break
			}
		loop
		return ret
	
#global
	
	MenuItemInit
	
#endif
