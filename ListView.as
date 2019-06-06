
#ifndef mod_ListView

#include "comctl32.as"
#include "user32.as"

#define global LVIF_TEXT       0x0001

#define global LVNI_SELECTED   0x0002

#define global LVCFMT_LEFT      0x0000
#define global LVCFMT_RIGHT     0x0001
#define global LVCFMT_CENTER    0x0002

#module mod_ListView\
	m_objectID,\
	m_hwnd

	#modinit int _exStyle, int _style, int _x, int _y, int _width, int _height
		InitCommonControls
		pos _x, _y
		winobj "SysListView32", "", _exStyle, WS_CHILD | WS_VISIBLE | _style, _width, _height
		m_objectID = stat
		m_hwnd = objinfo_hwnd(m_objectID)
		return
	
	#modcfunc ListViewGetWnd
		return m_hwnd
	
	#modfunc ListViewInsertColumn int _index, int _align, int _width, str _szText,\
		local lvcolmun,\
		local szText
	
		szText = _szText
		dim lvcolmun, 8
		lvcolmun(0) = LVCF_FMT | LVCF_WIDTH | LVCF_TEXT | LVCF_SUBITEM
		lvcolmun(1) = _align
		lvcolmun(2) = _width
		lvcolmun(3) = varptr(szText)
		sendmsg m_hwnd, LVM_INSERTCOLUMN, _index, varptr(lvcolmun)
		return
	
	#modfunc ListViewInsertItem int _index, str _szText,\
		local szText,\
		local lvitem
	
		szText = _szText
		dim lvitem, 13
		lvitem(0) = LVIF_TEXT
		lvitem(1) = _index
		lvitem(5) = varptr(szText)
		sendmsg m_hwnd, LVM_INSERTITEM, 0, varptr(lvitem)
		return stat
	
	#modfunc ListViewSetItem int _index, int _subItem, str _szText,\
		local szText,\
		local lvitem
	
		szText = _szText
		dim lvitem, 13
		lvitem(0) = LVIF_TEXT
		lvitem(1) = _index
		lvitem(2) = _subItem
		lvitem(5) = varptr(szText)
		sendmsg m_hwnd, LVM_SETITEM, 0, varptr(lvitem)
		return
	
	#modfunc ListViewMove int _x, int _y, int _width, int _height
		MoveWindow m_hwnd, _x, _y, _width, _height, true
		return
	
	#modfunc ListViewDeleteAllItems
		sendmsg m_hwnd, LVM_DELETEALLITEMS, 0, 0
		return
	
	#modfunc ListViewSetExtendedListViewStyle int _exStyle
		sendmsg m_hwnd, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, _exStyle
		return
	
	#modcfunc ListViewGetItemText int _index, int _subItem,\
		local lvitem,\
		local textBufSize,\
		local textBuf
	
		dim lvitem, 13
		lvitem(2) = _subItem
		textBufSize = 256
		repeat
			sdim textBuf, textBufSize
			lvitem(5) = varptr(textBuf)
			lvitem(6) = textBufSize
			sendmsg m_hwnd, LVM_GETITEMTEXT, _index, varptr(lvitem)
			if (stat < textBufSize - 1) {
				break
			}
			textBufSize *= 2
		loop
		return textBuf

#global

#if 0

	dimtype listView, 5
	newmod listView, mod_ListView, WS_EX_CLIENTEDGE, LVS_REPORT, 0, 0, ginfo_winx, ginfo_winy
	
	ListViewInsertColumn listView, 0, LVCFMT_LEFT, 100, "column 0"
	ListViewInsertColumn listView, 1, LVCFMT_LEFT, 200, "column 1"
	
	repeat 5
		ListViewInsertItem listView, 0, "item " + cnt + ", 0"
		ListViewSetItem listView, 0, 1, "item " + cnt + ", 1"
	loop
	stop

#endif

#endif
