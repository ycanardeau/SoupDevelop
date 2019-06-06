
#ifndef mod_TabFolder
	
#include "user32.as"
#include "gdi32.as"
	
#include "ScrollBar.as"
	
	
#module mod_TabItem\
	m_nItems,\
	m_name,\
	m_style,\
	m_hChildWnd,\
	m_text,\
	m_textSize
	
	#define global TIS_NORMAL		0
	#define global TIS_AUTOSIZE		1
	#define global TIS_AUTODESTROY	2
	#define global TIS_AUTO			3
	/*#define global TIS_ICON			4*/
	
	#modinit\
		local mod_id
		dim mod_id : mref mod_id, 2
		
		dim m_nItems
		sdim m_name
		dim m_style
		dim m_hChildWnd
		dim m_text
		dim m_textSize
		return mod_id
	
	#modterm
		repeat length(m_hChildWnd)
			if ((m_style(cnt) & TIS_AUTODESTROY) != 0) {
				DestroyWindow m_hChildWnd(cnt)
			}
		loop
		return
	
	#modfunc TabItemAdd int _index, str _name, int _style, int _hChildWnd, str _text
		m_name(_index)      = _name
		m_style(_index)     = _style
		m_hChildWnd(_index) = _hChildWnd
		TabItemSetText thismod, _index, _text
		m_nItems++
		return
	
	#modfunc TabItemSetText int _index, str _text,\
		local hOldFont,\
		local text, local size
	
		dim size
		hOldFont = SelectObject(hdc, GetStockObject(17))
		text = _text
		GetTextExtentPoint32 hdc, text, strlen(text), varptr(size)
		SelectObject hdc, hOldFont
		
		m_text(_index)      = _text
		m_textSize(_index)  = size
		return
	
	#modfunc TabItemDelete int _index
		if (m_nItems == 0) {
			return
		}
		if ((m_style(_index) & TIS_AUTODESTROY) != 0) {
			DestroyWindow m_hChildWnd(_index)
		}
		repeat m_nItems - 1
			if (cnt >= _index) {
				m_name(cnt)      = m_name(cnt + 1)
				m_style(cnt)     = m_style(cnt + 1)
				m_hChildWnd(cnt) = m_hChildWnd(cnt + 1)
				m_text(cnt)      = m_text(cnt + 1)
				m_textSize(cnt)  = m_textSize(cnt + 1)
			}
		loop
		m_nItems--
		m_name(m_nItems)      = ""
		m_style(m_nItems)     = 0
		m_hChildWnd(m_nItems) = null
		m_text(m_nItems)      = ""
		m_textSize(m_nItems)  = 0
		return
	
	#modcfunc TabItemGetCount
		return m_nItems
	
	#modcfunc TabItemGetName int _index
		return m_name(_index)
	
	#modcfunc TabItemGetStyle int _index
		return m_style(_index)
	
	#modcfunc TabItemGetChildWnd int _index
		return m_hChildWnd(_index)
	
	#modcfunc TabItemGetText int _index
		return m_text(_index)
	
	#modcfunc TabItemGetTextSize int _index
		return m_textSize(_index)
	
#global
	
	
#module mod_TabFolder
	
	/*#define global TFS_CAPTION		1*/
	/*#define global TFS_CLOSEBUTTON	2*/
	
	#deffunc TabFolderInit
		syscolor 15
		colorBtnFace(0) = RGB(ginfo_r, ginfo_g, ginfo_b)
		colorBtnFace(1) = RGB(200 + int(1.0 * ginfo_r / (255.0 / 55.0) + 0.5), 200 + int(1.0 * ginfo_g / (255.0 / 55.0) + 0.5), 200 + int(1.0 * ginfo_b / (255.0 / 55.0) + 0.5))
		
		dim tfi_wndId
		dim tfi_hWnd
		dim tfi_x
		dim tfi_y
		dim tfi_width
		dim tfi_height
		dim tfi_hParentWnd
		dim tfi_hContextMenu
		dim tfi_selectedItem
		dim tfi_tbiId
		nTabFolder = 0
	
		dim tfi_nmhdr, 3
		
		dimtype tabItem, 5
	
		dimtype tfi_scrollBar, 5
		dim tfi_scrollBarID
		return
	
	#deffunc TabFolderCreate int _wndId, int _exStyle, int _style, int _x, int _y, int _width, int _height, int _hContextMenu,\
		local selWndId,\
		local id
		
		selWndId = ginfo_sel
	
		id = nTabFolder
		tfi_wndId(nTabFolder)        = _wndId
		tfi_x(nTabFolder)            = _x
		tfi_y(nTabFolder)            = _y
		tfi_width(nTabFolder)        = _width
		tfi_height(nTabFolder)       = _height
		tfi_hParentWnd(nTabFolder)   = hwnd
		tfi_hContextMenu(nTabFolder) = _hContextMenu
		tfi_selectedItem(nTabFolder) = 0
		
		newmod tabItem, mod_TabItem
		tfi_tbiId(nTabFolder) = stat
		
		bgscr _wndId, ginfo_dispx, ginfo_dispy, screen_hide
			tfi_hWnd(nTabFolder) = hwnd
			SetStyle hwnd, GWL_STYLE, WS_CHILD | WS_CLIPCHILDREN | WS_CLIPSIBLINGS | _style, WS_POPUP
			SetStyle hwnd, GWL_EXSTYLE, _exStyle, 0
			SetParent hwnd, tfi_hParentWnd(nTabFolder)
			
			oncmd gosub *OnLButtonDown, WM_LBUTTONDOWN
			oncmd gosub *OnLButtonUp, WM_LBUTTONUP
			if (_hContextMenu != null) {
				oncmd gosub *OnRButtonUp, WM_RBUTTONUP
				oncmd gosub *OnCommand, WM_COMMAND
			}
	
			newmod tfi_scrollBar, mod_ScrollBar, SBS_HORZ
			tfi_scrollBarID(nTabFolder) = stat
			ShowWindow ScrollBarGetWnd(tfi_scrollBar(tfi_scrollBarID(nTabFolder))), SW_HIDE
			
			width _width, _height, _x, _y
			TabFolderDraw nTabFolder
			
			gsel _wndId, 1
		
		nTabFolder++
		
		gsel selWndId
		return id
	
	#defcfunc TabFolderGetWnd int _id
		return tfi_hWnd(_id)
	
	#deffunc TabFolderDraw int _id,\
		local selWndId,\
		local rect,\
		local x, local size
		
		selWndId = ginfo_sel
		gsel tfi_wndId(_id)
		
		redraw 0
		syscolor 12 : boxf
		if (TabFolderGetItemCount(_id) > 0) {
			gradf hdc, 0, 0, ginfo_winx, 26, 0, colorBtnFace(0), colorBtnFace(1)
			
			dim rect, 4
			rect = 0, 22, tfi_width(_id), 26
			DrawEdge hdc, varptr(rect), BDR_RAISEDINNER, BF_TOP | BF_MIDDLE
		} else {
			
		}
		
		sysfont 17
		x = 0
		repeat TabFolderGetItemCount(_id)
			size = TabFolderGetItemTextSize(_id, cnt)
			
			if (cnt == tfi_selectedItem(_id)) {
				rect = x + 4, 26 - 22, x + size + 16, 26 - 3
				DrawEdge hdc, varptr(rect), BDR_RAISEDINNER, BF_LEFT | BF_RIGHT | BF_TOP | BF_MIDDLE
			}
			
			syscolor 18
			pos x + 10, 9
			mes TabFolderGetItemText(_id, cnt)
			
			x += size + 13
		loop
	
		redraw 1
		
		gsel selWndId
		return
	
	#deffunc TabFolderMove int _id, int _x, int _y, int _width, int _height,\
		local rect
		
		tfi_x(_id)      = _x
		tfi_y(_id)      = _y
		tfi_width(_id)  = _width
		tfi_height(_id) = _height
		
		MoveWindow tfi_hWnd(_id), _x, _y, _width, _height, true
		
		dim rect, 4
		TabFolderGetRect _id, rect
		repeat TabFolderGetItemCount(_id)
			if ((TabFolderGetItemStyle(_id, cnt) & TIS_AUTOSIZE) != 0) {
				MoveWindow TabFolderGetItemChildWnd(_id, cnt), rect(0), rect(1), rect(2), rect(3), true
			}
		loop
		
		TabFolderDraw _id
		return
	
	#deffunc TabFolderAddItem int _id, str _name, int _style, int _hChildWnd, str _text,\
		local tabIndex,\
		local rect
		
		TabItemAdd tabItem(tfi_tbiId(_id)), TabFolderGetItemCount(_id), _name, _style, _hChildWnd, _text
		SetParent _hChildWnd, tfi_hWnd(_id)
		
		dim rect, 4
		GetClientRect tfi_hParentWnd(_id), varptr(rect)
		sendmsg tfi_hParentWnd(_id), WM_SIZE, 0, MAKELONG(rect(2) - rect(0), rect(3) - rect(1))
		
		TabFolderSetSelectedItem _id, TabFolderGetItemCount(_id) - 1
		TabFolderDraw _id
		return
	
	#deffunc TabFolderDeleteItem int _id, int _index,\
		local selectedItem
		
		TabItemDelete tabItem(tfi_tbiId(_id)), _index
		
		selectedItem = TabFolderGetSelectedItem(_id)
		if (selectedItem > 0) {
			if (selectedItem == _index) {
				selectedItem--
			}
		}
		TabFolderSetSelectedItem _id, selectedItem
		
		TabFolderDraw _id
		return
	
	#deffunc TabFolderGetRect int _id, array _rect,\
		local selWndId
		
		selWndId = ginfo_sel
		gsel tfi_wndId(_id)
		
		_rect(0) = 0
		_rect(1) = 26
		_rect(2) = ginfo_winx
		_rect(3) = ginfo_winy - 26
		
		gsel selWndId
		return
	
	#defcfunc TabFolderGetSelectedItem int _id
		return tfi_selectedItem(_id)
	
	#deffunc TabFolderSetSelectedItem int _id, int _index,\
		local selWndId,\
		local hChildWnd
		
		LockWindowUpdate tfi_hParentWnd(_id)
		
		selWndId = ginfo_sel
		gsel tfi_wndId(_id)
		title TabFolderGetItemText(_id, _index)
		
		ShowWindow TabFolderGetItemChildWnd(_id, tfi_selectedItem(_id)), SW_HIDE
		
		tfi_selectedItem(_id) = _index
		
		TabFolderDraw _id
		
		hChildWnd = TabFolderGetItemChildWnd(_id, _index)
		ShowWindow hChildWnd, SW_SHOW
		if (hChildWnd == null) {
			SetFocus tfi_hWnd(_id)
		} else {
			SetFocus hChildWnd
		}
	
		tfi_nmhdr(0) = hwnd
		tfi_nmhdr(1) = 0
		tfi_nmhdr(2) = TCN_SELCHANGE
		sendmsg tfi_hParentWnd(_id), WM_NOTIFY, 0, varptr(tfi_nmhdr)
	
		gsel selWndId
		
		LockWindowUpdate null
		return
	
	#defcfunc TabFolderGetClickedItem int _id, int _x, int _y,\
		local x,\
		local clickedItem,\
		local size,\
		local rect
		
		x = 0 : clickedItem = -1
		repeat TabFolderGetItemCount(_id)
			size = TabFolderGetItemTextSize(_id, cnt)
			rect = x + 4, 26 - 22, x + size + 16, 26 - 3
			if (PtInRect(varptr(rect), _x, _y) != 0) {
				clickedItem = cnt
				break
			}
			x += size + 13
		loop
		return clickedItem
	
	#defcfunc TabFolderGetItemName int _id, int _index
		return TabItemGetName(tabItem(tfi_tbiId(_id)), _index)
	
	#defcfunc TabFolderGetItemStyle int _id, int _index
		return TabItemGetStyle(tabItem(tfi_tbiId(_id)), _index)
	
	#defcfunc TabFolderGetItemChildWnd int _id, int _index
		return TabItemGetChildWnd(tabItem(tfi_tbiId(_id)), _index)
	
	#defcfunc TabFolderGetItemText int _id, int _index
		return TabItemGetText(tabItem(tfi_tbiId(_id)), _index)
	
	#deffunc TabFolderSetItemText int _id, int _index, str _text
		TabItemSetText tabItem(tfi_tbiId(_id)), _index, _text
		TabFolderDraw _id
		return
	
	#defcfunc TabFolderGetItemTextSize int _id, int _index
		return TabItemGetTextSize(tabItem(tfi_tbiId(_id)), _index)
	
	#defcfunc TabFolderGetItemCount int _id
		return TabItemGetCount(tabItem(tfi_tbiId(_id)))
	
	*OnLButtonDown
		tabFolder_LButtonDown
		return
	#deffunc local tabFolder_LButtonDown\
		local selWndId,\
		local id,\
		local mx, local my,\
		local clickedItem,\
	
		selWndId = ginfo_sel
		gsel ginfo_intid
		
		id = getId(ginfo_sel)
		
		mx = LOWORD(lparam) : my = HIWORD(lparam)
	
		SetFocus hwnd
		
		clickedItem = TabFolderGetClickedItem(id, mx, my)
		if (clickedItem != -1) {
			TabFolderSetSelectedItem id, clickedItem
		}
	
		gsel selWndId
		return
	
	*OnLButtonUp
		tabFolder_LButtonUp
		return
	#deffunc local tabFolder_LButtonUp
		return
	
	*OnRButtonUp
		tabFolder_RButtonUp
		return
	#deffunc local tabFolder_RButtonUp\
		local selWndId,\
		local id,\
		local mx, local my,\
		local clickedItem
		
		selWndId = ginfo_sel
		gsel ginfo_intid
		
		id = getId(ginfo_intid)
		
		mx = LOWORD(lparam) : my = HIWORD(lparam)
		clickedItem = TabFolderGetClickedItem(id, mx, my)
		if (clickedItem != -1) {
			TabFolderSetSelectedItem id, clickedItem
			TrackPopupMenu tfi_hContextMenu(id), 0, ginfo_mx, ginfo_my, 0, hwnd, 0
		}
		
		gsel selWndId
		return
	
	*OnCommand
		tabFolder_Command
		return
	#deffunc local tabFolder_Command\
		local selWndId,\
		local id
		
		selWndId = ginfo_sel
		gsel ginfo_intid
		
		id = getId(ginfo_intid)
		
		sendmsg tfi_hParentWnd(id), WM_COMMAND, wparam, lparam
		
		gsel selWndId
		return
	
	#defcfunc local getId int _wndId,\
		local ret
		
		ret = -1
		foreach tfi_wndId
			if (tfi_wndId(cnt) == _wndId) {
				ret = cnt
				break
			}
		loop
		return ret
	
#global
	
	TabFolderInit
	
#endif
