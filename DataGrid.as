
#ifndef mod_DataGrid
	
#include "WindowScrollBar.as"
#include "TSVDataBase.as"
#include "Splitter.as"
	
#include "hscallbk.as"
	
#module mod_DataGridDataBase\
	m_data
	
	#modinit
		sdim m_data
		return
	
	#modfunc DataGridDataBaseSetCellData int _row, int _column, str _data
		TSVDataBaseSetCellData m_data, _row, _column, _data
		return
	
	#modcfunc DataGridDataBaseGetCellData int _row, int _column
		return TSVDataBaseGetCellData(m_data, _row, _column)
	
	#modfunc DataGridDataBaseSet str _data
		m_data = _data
		return
	
	#modcfunc DataGridDataBaseGet
		return m_data
	
#global
	
#module mod_DataGrid
	
	#uselib "imm32"
	#func ImmAssociateContext "ImmAssociateContext" sptr, sptr
	
	#uselib ""
	#func InputBoxProc "" int, int, int, int
	
	#const CellHeight 16
	#const MaxLength 65535
	
	#enum global DGCS_TEXTBOX = 0
	#enum global DGCS_DROPDOWNLIST
	#enum global DGCS_FIXED
	#enum global DGCS_COMBOBOX
	//#enum global DGCS_MULTITEXTBOX
	#enum global DGCS_BUTTON
	
	#deffunc DataGridInit
		dim dgi_wndId
		dim dgi_hParentWnd
		dim dgi_hWnd
		dim dgi_rows
		dim dgi_columns
		dim dgi_splitterId
		dim dgi_selectedRow
		dim dgi_selectedColumn
		dim dgi_previousRow
		dim dgi_previousColumn
		dim dgi_isActive
		dim dgi_hInputBox
		sdim dgi_inputData, MaxLength
		dimtype dgi_cellWidth, 5
		dimtype dgi_cellStyle, 5
		dimtype dgi_cellData, 5
		dimtype dgi_dropDownData, 5
		nDataGrid = 0
	
		dim dgi_selectedDataGridId
	
		dim dgi_lpfnInputBox
		dim dgi_lpfnDefInputBox
		setcallbk dgi_lpfnInputBox, InputBoxProc, *OnWndProc
		dim dgi_dropDownIndex
	
		dim dgi_nmhdr
		return
	
	#deffunc DataGridCreate int _wndId, int _rows, int _columns, int _x, int _y, int _width, int _height,\
		local selWndId,\
		local id,\
		local distance, local previousDistance
		
		selWndId = ginfo_sel
	
		id = nDataGrid
		dgi_wndId(id)          = _wndId
		dgi_hParentWnd(id)     = hwnd
		dgi_rows(id)           = _rows
		dgi_columns(id)        = _columns
		dgi_selectedRow(id)    = -1
		dgi_selectedColumn(id) = -1
		dgi_previousRow(id)    = -1
		dgi_previousColumn(id) = -1
		dgi_isActive(id)       = false
		dgi_hInputBox(id)      = null
		newmod dgi_cellWidth, mod_DataGridDataBase
		newmod dgi_cellStyle, mod_DataGridDataBase
		newmod dgi_cellData, mod_DataGridDataBase
		newmod dgi_dropDownData, mod_DataGridDataBase
		
		bgscr _wndId, ginfo_dispx, ginfo_dispy, screen_hide
		dgi_hWnd(id) = hwnd
		SetStyle hwnd, GWL_STYLE, WS_CHILD | WS_CLIPSIBLINGS | WS_CLIPCHILDREN, WS_POPUP
		SetStyle hwnd, GWL_EXSTYLE, WS_EX_CLIENTEDGE, 0
		SetParent hwnd, dgi_hParentWnd(id)
		syscolor 12 : boxf
		
		ImmAssociateContext hwnd, 0
		
		WindowScrollBarCreate WS_HSCROLL
		WindowScrollBarCreate WS_VSCROLL
		
		repeat dgi_columns(id)
			SplitterCreate 1, 1
		loop
		dgi_splitterId(id) = stat
		
		oncmd gosub *OnScroll, WM_HSCROLL
		oncmd gosub *OnScroll, WM_VSCROLL
		oncmd gosub *OnWheel, WM_MOUSEWHEEL
		oncmd gosub *OnWheel, 0x0000020e/*WM_MOUSEHWHEEL*/
		
		oncmd gosub *OnSize, WM_SIZE
		oncmd gosub *OnChar, WM_CHAR
		oncmd gosub *OnKeyDown, WM_KEYDOWN
		oncmd gosub *OnMouseMove, WM_MOUSEMOVE
		oncmd gosub *OnLButtonDown, WM_LBUTTONDOWN
		oncmd gosub *OnLButtonUp, WM_LBUTTONUP
		oncmd gosub *OnSetCursor, WM_SETCURSOR
	
		oncmd gosub *OnSetFocus, WM_SETFOCUS
		oncmd gosub *OnKillFocus, WM_KILLFOCUS
	
		oncmd gosub *OnCommand, WM_COMMAND
	
		width _width, _height, _x, _y
		
		nDataGrid++
		
		gsel selWndId
		return id
	
	#defcfunc DataGridGetWnd int _id
		return dgi_hWnd(_id)
	
	#deffunc DataGridMove int _id, int _x, int _y, int _width, int _height
		MoveWindow dgi_hWnd(_id), _x, _y, _width, _height, true
		return
	
	#deffunc DataGridShow int _id
		gsel dgi_wndId(_id), 1
		return
	
	#deffunc DataGridSetRows int _id, int _rows
		if (_rows == 0) {
			repeat dgi_columns(_id)
				SplitterSetEnabled dgi_splitterId(_id) - (dgi_columns(_id) - 1 - cnt), false
			loop
		} else {
			repeat dgi_columns(_id)
				SplitterSetEnabled dgi_splitterId(_id) - (dgi_columns(_id) - 1 - cnt), true
			loop
		}
		dgi_rows(_id) = _rows
		draw _id
		return
	
	#defcfunc DataGridGetSelectedRow int _id
		return dgi_selectedRow(_id)
		
	#defcfunc DataGridGetSelectedColumn int _id
		return dgi_selectedColumn(_id)
	
	#defcfunc DataGridGetCellWidth int _id, int _column
		return int(DataGridDataBaseGetCellData(dgi_cellWidth(_id), 0, _column))
	
	#deffunc DataGridSetCellWidth int _id, int _column, int _width
		DataGridDataBaseSetCellData dgi_cellWidth(_id), 0, _column, str(_width)
		return
	
	#defcfunc DataGridGetCellData int _id, int _row, int _column
		return DataGridDataBaseGetCellData(dgi_cellData(_id), _row, _column)
	
	#deffunc DataGridSetCellData int _id, int _row, int _column, str _data
		DataGridDataBaseSetCellData dgi_cellData(_id), _row, _column, _data
		return
	
	#defcfunc DataGridGetCellStyle int _id, int _row, int _column
		return int(DataGridDataBaseGetCellData(dgi_cellStyle(_id), _row, _column))
	
	#deffunc DataGridSetCellStyle int _id, int _row, int _column, int _style
		DataGridDataBaseSetCellData dgi_cellStyle(_id), _row, _column, str(_style)
		return
	
	#defcfunc DataGridGetDropDownData int _id, int _row, int _column,\
		local data
	
		data = DataGridDataBaseGetCellData(dgi_dropDownData(_id), _row, _column)
		strrep data, "\\n", "\n"
		return data
	
	#deffunc DataGridSetDropDownData int _id, int _row, int _column, str _data,\
		local data
	
		data = _data
		strrep data, "\n", "\\n"
		DataGridDataBaseSetCellData dgi_dropDownData(_id), _row, _column, data
		return
	
	#deffunc DataGridClear int _id
		DataGridSet _id, ""
		dgi_selectedRow(_id) = -1
		dgi_selectedColumn(_id) = -1
		dgi_previousRow(_id) = -1
		dgi_previousColumn(_id) = -1
		DataGridSetRows _id, 0
		draw _id
		return
	
	#defcfunc DataGridGet int _id
		return DataGridDataBaseGet(dgi_cellData(_id))
	
	#deffunc DataGridSet int _id, str _data
		DataGridDataBaseSet dgi_cellData(_id), _data
		draw _id
		return
	
	#deffunc DataGridRedraw int _id
		draw _id
		return
	
	#defcfunc DataGridGetWidth int _id,\
		local selWndID,\
		local wx
	
		selWndID = ginfo_sel
		gsel dgi_wndId(_id)
	
		wx = ginfo_winx
	
		gsel selWndID
		return wx
	
	*OnScroll
		DataGrid_Scroll
		return
	#deffunc local DataGrid_Scroll\
		local selWndId,\
		local id
		
		selWndId = ginfo_sel
		gsel ginfo_intid
		
		id = getId(ginfo_sel)
		
		WindowScrollBar_Scroll
		
		endInput id
		
		draw id
		
		gsel selWndId
		return
	
	*OnWheel
		DataGrid_Wheel
		return
	#deffunc local DataGrid_Wheel\
		local selWndId,\
		local id
		
		selWndId = ginfo_sel
		gsel ginfo_intid
		
		id = getId(ginfo_sel)
		
		WindowScrollBar_Wheel
		
		endInput id
		
		draw id
		
		gsel selWndId
		return
	
	*OnSize
		DataGrid_Resize
		return
	#deffunc local DataGrid_Resize\
		local selWndId,\
		local id,\
		local distance, local previousDistance
		
		selWndId = ginfo_sel
		gsel ginfo_intid
		
		id = getId(ginfo_sel)
		
		endInput id
		
		draw id
		
		gsel selWndId
		return
	
	*OnMouseMove
		DataGrid_MouseMove
		return
	#deffunc local DataGrid_MouseMove\
		local selWndId,\
		local id
		
		selWndId = ginfo_sel
		gsel ginfo_intid
		
		id = getId(ginfo_sel)
		
		Splitter_MouseMove
		
		gsel selWndId
		return
	
	*OnLButtonDown
		DataGrid_LButtonDown
		return
	#deffunc local DataGrid_LButtonDown\
		local selWndId,\
		local id,\
		local row, local column,\
		local splitterId,\
		local distance,\
		local scrollPosY
		
		selWndId = ginfo_sel
		gsel ginfo_intid
		
		id = getId(ginfo_sel)
		dgi_selectedDataGridId = id
	
		Splitter_LButtonDown
	
		SetFocus dgi_hWnd(id)
	
		scrollPosY = WindowScrollBarGetPos(SB_VERT)
		
		if (SplitterGetHitting() == -1) {
			row = mousey / (CellHeight + 1)
			if (row >= dgi_rows(id)) {
				row = -1
			}
			distance = 0
			repeat dgi_columns(id)
				splitterId = dgi_splitterId(id) - (dgi_columns(id) - 1 - cnt)
				if (mousex >= distance) {
					column = cnt
				}
				distance = SplitterGetPos(splitterId)
			loop
			if (mousex >= SplitterGetPos(splitterId)) {
				column = -1
			}
			endInput id
			if (row + scrollPosY < dgi_rows(id)) {
				dgi_selectedRow(id) = row + scrollPosY
			} else {
				dgi_selectedRow(id) = -1
			}
			dgi_selectedColumn(id) = column
			if (dgi_selectedRow(id) == dgi_previousRow(id) && dgi_selectedColumn(id) == dgi_previousColumn(id)) {
				beginInput id
			}
			dgi_previousRow(id) = dgi_selectedRow(id)
			dgi_previousColumn(id) = dgi_selectedColumn(id)
			
			draw id
		} else {
			endInput id
		}
		
		gsel selWndId
		return
	
	*OnLButtonUp
		DataGrid_LButtonUp
		return
	#deffunc local DataGrid_LButtonUp\
		local selWndId,\
		local id
		
		selWndId = ginfo_sel
		gsel ginfo_intid
		
		id = getId(ginfo_sel)
		
		Splitter_LButtonUp
		
		gsel selWndId
		return
	
	*OnSetCursor
		return Splitter_SetCursor()
	
	*OnChar
		DataGrid_Char
		return
	#deffunc local DataGrid_Char\
		local selWndId,\
		local id,\
		local wp, local lp
		
		selWndId = ginfo_sel
		gsel ginfo_intid
		
		id = getId(ginfo_sel)
	
		wp = wparam : lp = lparam
		
		beginInput id
		sendmsg dgi_hInputBox(id), WM_CHAR, wp, lp
		
		gsel selWndId
		return
	
	*OnKeyDown
		DataGrid_KeyDown
		return
	#deffunc local DataGrid_KeyDown\
		local selWndId,\
		local id
		
		selWndId = ginfo_sel
		gsel ginfo_intid
		
		id = getId(ginfo_sel)
	
		switch (wparam)
			case 37
				dgi_selectedColumn(id)--
				if (dgi_selectedColumn(id) < 0) {
					dgi_selectedColumn(id) = 0
				}
				swbreak
			case 38
				dgi_selectedRow(id)--
				if (dgi_selectedRow(id) < 0) {
					dgi_selectedRow(id) = 0
				}
				swbreak
			case 39
				dgi_selectedColumn(id)++
				if (dgi_selectedColumn(id) > dgi_columns(id) - 1) {
					dgi_selectedColumn(id) = dgi_columns(id) - 1
				}
				swbreak
			case 40
				dgi_selectedRow(id)++
				if (dgi_selectedRow(id) > dgi_rows(id) - 1) {
					dgi_selectedRow(id) = dgi_rows(id) - 1
				}
				swbreak
			case 113
				beginInput id
				swbreak
		swend
		
		draw id
		
		gsel selWndId
		return
	
	*OnSetFocus
		DataGrid_SetFocus
		return
	#deffunc local DataGrid_SetFocus\
		local selWndId,\
		local id
	
		selWndId = ginfo_sel
		gsel ginfo_intid
	
		id = getId(ginfo_sel)
	
		dgi_isActive(id) = true
	
		if (SplitterGetHitting() == -1) {
			draw id
		}
	
		gsel selWndId
		return
	
	*OnKillFocus
		DataGrid_KillFocus
		return
	#deffunc local DataGrid_KillFocus\
		local selWndId,\
		local id
	
		selWndId = ginfo_sel
		gsel ginfo_intid
	
		id = getId(ginfo_sel)
	
		dgi_isActive(id) = false
	
		draw id
	
		gsel selWndId
		return
	
	*OnCommand
		DataGrid_Command
		return
	#deffunc local DataGrid_Command\
		local selWndID,\
		local id
	
		selWndId = ginfo_sel
		gsel ginfo_intid
	
		id = getId(ginfo_sel)
	
		if (lparam == 0 || lparam == 1) {
			sendmsg dgi_hParentWnd(id), WM_COMMAND, wparam, lparam
		}
		
		gsel selWndID
		return
	
	*OnWndProc
		InputBox_WndProc
		return
	#deffunc local InputBox_WndProc\
		local hCtl, local uMsg, local wp, local lp
	
		hCtl = callbkarg(0)
		uMsg = callbkarg(1)
		wp = callbkarg(2)
		lp = callbkarg(3)
	
		switch (uMsg)
			case WM_KILLFOCUS
				endInput dgi_selectedDataGridId
				draw dgi_selectedDataGridId
				return CallWindowProc(dgi_lpfnDefInputBox, hCtl, uMsg, wp, lp)
			case WM_CHAR
				switch (wp)
					case 13
						endInput dgi_selectedDataGridId
						draw dgi_selectedDataGridId
						swbreak
				swend
				return CallWindowProc(dgi_lpfnDefInputBox, hCtl, uMsg, wp, lp)
			default
				return CallWindowProc(dgi_lpfnDefInputBox, hCtl, uMsg, wp, lp)
		swend
		return 0
	
	#deffunc local endInput int _id,\
		local lineData
		
		if (dgi_hInputBox(_id) == null) {
			return
		}
		
		dgi_inputStyle(_id) = int(DataGridGetCellStyle(_id, dgi_selectedRow(_id), dgi_selectedColumn(_id)))
		switch (dgi_inputStyle(_id))
		case DGCS_TEXTBOX
			if (dgi_inputData(_id) != DataGridGetCellData(_id, dgi_selectedRow(_id), dgi_selectedColumn(_id))) {
				DataGridSetCellData _id, dgi_selectedRow(_id), dgi_selectedColumn(_id), dgi_inputData(_id)
				sendmsg dgi_hParentWnd(_id), WM_COMMAND, MAKELONG(0, 0x00000300/*EN_CHANGE*/), dgi_hWnd(_id)
			}
			swbreak
		case DGCS_DROPDOWNLIST
			sdim lineData, 32767
			sendmsg dgi_hInputBox(_id), WM_GETTEXT, 32767, varptr(lineData)
			if (lineData != DataGridGetCellData(_id, dgi_selectedRow(_id), dgi_selectedColumn(_id))) {
				DataGridSetCellData _id, dgi_selectedRow(_id), dgi_selectedColumn(_id), lineData
				sendmsg dgi_hParentWnd(_id), WM_COMMAND, MAKELONG(0, 0x00000300/*EN_CHANGE*/), dgi_hWnd(_id)
			}
			swbreak
		case DGCS_COMBOBOX
			sdim lineData, 32767
			sendmsg dgi_hInputBox(_id), WM_GETTEXT, 32767, varptr(lineData)
			if (lineData != DataGridGetCellData(_id, dgi_selectedRow(_id), dgi_selectedColumn(_id))) {
				DataGridSetCellData _id, dgi_selectedRow(_id), dgi_selectedColumn(_id), lineData
				sendmsg dgi_hParentWnd(_id), WM_COMMAND, MAKELONG(0, 0x00000300/*EN_CHANGE*/), dgi_hWnd(_id)
			}
			swbreak
		swend
		DestroyWindow dgi_hInputBox(_id)
		dgi_hInputBox(_id) = null
		dgi_inputData(_id) = ""
		return
	
	#deffunc local beginInput int _id,\
		local splitterId,\
		local distance,\
		local dropDownData,\
		local lineData,\
		local bmscr,\
		local hFont,\
		local comboboxinfo,\
		local scrollPosY
		
		if (dgi_hInputBox(_id) != null || dgi_selectedRow(_id) == -1 || dgi_selectedColumn(_id) == -1) {
			return
		}
	
		LockWindowUpdate dgi_hWnd(_id)
	
		dim comboboxinfo, 13
	
		scrollPosY = WindowScrollBarGetPos(SB_VERT)
		
		font "MS UI Gothic", 12
		objmode 2
		splitterId = dgi_splitterId(_id) - (dgi_columns(_id) - 1 - dgi_selectedColumn(_id))
		distance = 0
		repeat dgi_selectedColumn(_id)
			distance += DataGridGetCellWidth(_id, cnt) + 1
		loop
		dgi_inputData(_id) = DataGridGetCellData(_id, dgi_selectedRow(_id), dgi_selectedColumn(_id))
		dgi_inputStyle(_id) = int(DataGridGetCellStyle(_id, dgi_selectedRow(_id), dgi_selectedColumn(_id)))
		switch (dgi_inputStyle(_id))
		case DGCS_TEXTBOX
			pos distance, (CellHeight + 1) * (dgi_selectedRow(_id) - scrollPosY)
			objsize DataGridGetCellWidth(_id, dgi_selectedColumn(_id)), CellHeight
			input dgi_inputData(_id)
			dgi_hInputBox(_id) = objinfo_hwnd(stat)
			dgi_lpfnDefInputBox = GetWindowLong(dgi_hInputBox(_id), GWL_WNDPROC)
			SetWindowLong dgi_hInputBox(_id), GWL_WNDPROC, varptr(dgi_lpfnInputBox)
			SetStyle dgi_hInputBox(_id), GWL_STYLE, WS_BORDER
			SetWindowLong dgi_hInputBox(_id), GWL_EXSTYLE, 0
			SetWindowPos dgi_hInputBox(_id), 0, 0, 0, 0, 0, SWP_FRAMECHANGED | SWP_NOZORDER | SWP_NOMOVE | SWP_NOSIZE
			SetFocus dgi_hInputBox(_id)
			sendmsg dgi_hInputBox(_id), EM_SETSEL, 0, 0xffffffff
			swbreak
		case DGCS_DROPDOWNLIST
			pos distance - 1, (CellHeight + 1) * (dgi_selectedRow(_id) - scrollPosY) - 2
			objsize DataGridGetCellWidth(_id, dgi_selectedColumn(_id)) + 1, CellHeight
			sdim lineData
			dgi_dropDownIndex(_id) = -1
			dropDownData = DataGridGetDropDownData(_id, dgi_selectedRow(_id), dgi_selectedColumn(_id))
			notesel dropDownData
			repeat notemax
				noteget lineData, cnt
				if (dgi_inputData(_id) == lineData) {
					dgi_dropDownIndex = cnt
					break
				}
			loop
			noteunsel
			combox dgi_dropDownIndex(_id), 194, dropDownData
			dgi_hInputBox(_id) = objinfo_hwnd(stat)
			dgi_lpfnDefInputBox = GetWindowLong(dgi_hInputBox(_id), GWL_WNDPROC)
			SetWindowLong dgi_hInputBox(_id), GWL_WNDPROC, varptr(dgi_lpfnInputBox)
			SetFocus dgi_hInputBox(_id)
			PostMessage dgi_hInputBox(_id), WM_LBUTTONDOWN, MK_LBUTTON, MAKELONG(ginfo_mx, ginfo_my)
			swbreak
		case DGCS_COMBOBOX
			sysfont 17
			mref bmscr, 67
			hFont = bmscr(38)
	
			pos distance - 1, (CellHeight + 1) * (dgi_selectedRow(_id) - scrollPosY) - 1
			objsize DataGridGetCellWidth(_id, dgi_selectedColumn(_id)) + 1, CellHeight
			winobj "ComboBox", "", 0, WS_CHILD | WS_VISIBLE | 0x0002/*CBS_DROPDOWN*/, , , dgi_hWnd(_id), 0
			dgi_hInputBox(_id) = objinfo_hwnd(stat)
			GetStockObject 17
			sendmsg dgi_hInputBox(_id), WM_SETFONT, hFont
	
			sdim lineData
			dgi_dropDownIndex(_id) = -1
			dropDownData = DataGridGetDropDownData(_id, dgi_selectedRow(_id), dgi_selectedColumn(_id))
			notesel dropDownData
			repeat notemax
				noteget lineData, cnt
				sendmsg dgi_hInputBox(_id), CB_ADDSTRING, 0, varptr(lineData)
			loop
			noteunsel
				
			sendmsg dgi_hInputBox(_id), WM_SETTEXT, strlen(dgi_inputData(_id)), varptr(dgi_inputData(_id))
			SetFocus dgi_hInputBox(_id)
			sendmsg dgi_hInputBox(_id), EM_SETSEL, 0, 0xffffffff
	
			dim comboboxinfo, 13
			comboboxinfo(0) = 52
			GetComboBoxInfo dgi_hInputBox(_id), varptr(comboboxinfo)
			dgi_lpfnDefInputBox = GetWindowLong(comboboxInfo(11), GWL_WNDPROC)
			SetWindowLong comboboxInfo(11), GWL_WNDPROC, varptr(dgi_lpfnInputBox)
			swbreak
		case DGCS_BUTTON
			dgi_nmhdr(0) = dgi_hWnd(_id)
			dgi_nmhdr(1) = 0
			dgi_nmhdr(2) = BN_CLICKED
			sendmsg dgi_hParentWnd(_id), WM_NOTIFY, 0, varptr(dgi_nmhdr)
			swbreak
		swend
		
		LockWindowUpdate null
		return
	
	#deffunc local draw int _id,\
		local selWndId,\
		local hittingSplitter,\
		local distance,\
		local w,\
		local splitterId,\
		local min,\
		local i, local j,\
		local rect,\
		local data,\
		local scrollPosY
		dim rect, 4
	
		selWndId = ginfo_sel
		gsel dgi_wndId(_id)
		
		redraw 0
		syscolor 12 : boxf
		
		font "MS UI Gothic", 12
		
		hittingSplitter = SplitterGetHitting()
		if (hittingSplitter != -1) {
			if (hittingSplitter == dgi_splitterId(_id) - (dgi_columns(_id) - 1)) {
				distance = SplitterGetPos(hittingSplitter)
			} else {
				distance = SplitterGetPos(hittingSplitter) - SplitterGetPos(hittingSplitter - 1) - 1
			}
			DataGridSetCellWidth _id, hittingSplitter - (dgi_splitterId(_id) - dgi_columns(_id) + 1), distance
		}
	
		WindowScrollBarSetInfo SB_VERT, 0, dgi_rows(_id), ginfo_winy / (CellHeight + 1)
	
		scrollPosY = WindowScrollBarGetPos(SB_VERT)
		for i, 0, dgi_rows(_id) - scrollPosY, 1
			distance = 0
			for j, 0, dgi_columns(_id), 1
				syscolor 15
				w = DataGridGetCellWidth(_id, j)
				splitterId = dgi_splitterId(_id) - (dgi_columns(_id) - 1 - j)
				if (j == 0) {
					min = 0
				} else {
					min = SplitterGetPos(splitterId - 1)
				}
				SplitterMove splitterId, (CellHeight + 1) * dgi_rows(_id), 0, min + 20, ginfo_winx
				SplitterSetPos splitterId, distance + w
				boxf distance, (CellHeight + 1) * i, distance + w, (CellHeight + 1) * i + CellHeight
				
				if (dgi_selectedRow(_id) == (i + scrollPosY) && dgi_selectedColumn(_id) == j) {
					if (dgi_isActive(_id) == false) {
						syscolor 15
					} else {
						syscolor 13
					}
					boxf distance, (CellHeight + 1) * i, distance + w - 1, (CellHeight + 1) * i + CellHeight - 1
					color 0, 0, 0
					if (dgi_isActive(_id) != false) {
						rect(0) = distance + 1
						rect(1) = (CellHeight + 1) * i
						rect(2) = distance + w - 1
						rect(3) = (CellHeight + 1) * i + CellHeight
						DrawFocusRect hdc, varptr(rect)
					}
					if (dgi_isActive(_id) == false) {
						syscolor 8
					} else {
						syscolor 14
					}
				} else {
					switch (DataGridGetCellStyle(_id, (i + scrollPosY), j))
						case DGCS_FIXED
							rect(0) = distance
							rect(1) = (CellHeight + 1) * i
							rect(2) = distance + w
							rect(3) = (CellHeight + 1) * i + CellHeight + 1
							DrawFrameControl hdc, varptr(rect), DFC_BUTTON, DFCS_BUTTONPUSH
							syscolor 8
							swbreak
						default
							if (i \ 2 == 0) {
								color 255, 255, 255
							} else {
								syscolor 15
								color 200 + int(1.0 * ginfo_r / (255.0 / 55.0) + 0.5), 200 + int(1.0 * ginfo_g / (255.0 / 55.0) + 0.5), 200 + int(1.0 * ginfo_b / (255.0 / 55.0) + 0.5)
							}
							boxf distance, (CellHeight + 1) * i, distance + w - 1, (CellHeight + 1) * i + CellHeight - 1
							syscolor 8
							swbreak
					swend
				}
	
				switch (DataGridGetCellStyle(_id, (i + scrollPosY), j))
					case DGCS_FIXED
						rect(0) = distance + 3
						rect(1) = (CellHeight + 1) * i
						rect(2) = distance + w - 2
						rect(3) = (CellHeight + 1) * i + CellHeight
						swbreak
					default
						rect(0) = distance + 3
						rect(1) = (CellHeight + 1) * i
						rect(2) = distance + w
						rect(3) = (CellHeight + 1) * i + CellHeight
						swbreak
				swend
				data = DataGridGetCellData(_id, (i + scrollPosY), j)
				DrawText hdc, data, strlen(data), varptr(rect), DT_EDITCONTROL | DT_SINGLELINE | DT_VCENTER
				
				distance += w + 1
			next
		next
	
		redraw 1
	
		gsel selWndId
		return
	
	#defcfunc local getId int _wndId,\
		local ret
		
		ret = -1
		foreach dgi_wndId
			if (dgi_wndId(cnt) == _wndId) {
				ret = cnt
				break
			}
		loop
		return ret
	
#global
	
	DataGridInit
	
#if 0

	DataGridCreate ginfo_newid, 11, 2 : m_propertiesDataGridId = stat
	repeat 11
		DataGridSetCellStyle m_propertiesDataGridId, cnt, 0, DGCS_FIXED
	loop
	DataGridSetCellWidth m_propertiesDataGridId, 0, 64
	DataGridSetCellWidth m_propertiesDataGridId, 1, 160 - 65
	DataGridSetCellData m_propertiesDataGridId, 0, 0, "Name"
	DataGridSetCellData m_propertiesDataGridId, 1, 0, "BackColor"
	DataGridSetCellData m_propertiesDataGridId, 2, 0, "FormBorderStyle"
	DataGridSetCellData m_propertiesDataGridId, 3, 0, "InitializationType"
	DataGridSetCellData m_propertiesDataGridId, 4, 0, "MaximizeBox"
	DataGridSetCellData m_propertiesDataGridId, 5, 0, "MinimizeBox"
	DataGridSetCellData m_propertiesDataGridId, 6, 0, "Width"
	DataGridSetCellData m_propertiesDataGridId, 7, 0, "Height"
	DataGridSetCellData m_propertiesDataGridId, 8, 0, "StartPosition"
	DataGridSetCellData m_propertiesDataGridId, 9, 0, "Text"
	DataGridSetCellData m_propertiesDataGridId, 10, 0, "WindowID"
	DataGridSetCellData m_propertiesDataGridId, 0, 1, "MainForm"
	DataGridSetCellData m_propertiesDataGridId, 1, 1, "Control"
	DataGridSetCellData m_propertiesDataGridId, 2, 1, "Sizable"
	DataGridSetCellData m_propertiesDataGridId, 3, 1, "Bgscr"
	DataGridSetCellData m_propertiesDataGridId, 4, 1, "True"
	DataGridSetCellData m_propertiesDataGridId, 5, 1, "True"
	DataGridSetCellData m_propertiesDataGridId, 6, 1, "300"
	DataGridSetCellData m_propertiesDataGridId, 7, 1, "300"
	DataGridSetCellData m_propertiesDataGridId, 8, 1, "CenterScreen"
	DataGridSetCellData m_propertiesDataGridId, 9, 1, "ÉÅÉÇí†"
	DataGridSetCellData m_propertiesDataGridId, 10, 1, "IDW_MAINFORM"
	DataGridSetCellStyle m_propertiesDataGridId, 1, 1, DGCS_COMBOBOX
	DataGridSetDropDownData m_propertiesDataGridId, 1, 1, {"ActiveBorder
ActiveCaption
ActiveCaptionText
AppWorkspace
ButtonFace
ButtonHighlight
ButtonShadow
Control
ControlDark
ControlLight
ControlLightLight
ControlText
Desktop
GradientActiveCaption
GradientInactiveCaption
GrayText
Highlight
HighlightText
HotTrack
InactiveBorder
InactiveCaption
InactiveCaptionText
Info
InfoText
Menu
MenuBar
MenuHighlight
MenuText
ScrollBar
Window
WindowFrame
WindowText"}
	DataGridSetCellStyle m_propertiesDataGridId, 2, 1, DGCS_DROPDOWNLIST
	DataGridSetDropDownData m_propertiesDataGridId, 2, 1, "None\nFixedSingle\nFixed3D\nFixedDialog\nSizable\nFixedToolWindow\nSizableToolWindow"
	DataGridSetCellStyle m_propertiesDataGridId, 3, 1, DGCS_DROPDOWNLIST
	DataGridSetDropDownData m_propertiesDataGridId, 3, 1, "Screen\nBgscr"
	DataGridSetCellStyle m_propertiesDataGridId, 4, 1, DGCS_DROPDOWNLIST
	DataGridSetDropDownData m_propertiesDataGridId, 4, 1, "False\nTrue"
	DataGridSetCellStyle m_propertiesDataGridId, 5, 1, DGCS_DROPDOWNLIST
	DataGridSetDropDownData m_propertiesDataGridId, 5, 1, "False\nTrue"
	DataGridSetCellStyle m_propertiesDataGridId, 8, 1, DGCS_DROPDOWNLIST
	DataGridSetDropDownData m_propertiesDataGridId, 8, 1, "Manual\nCenterScreen\nWindowsDefaultLocation\nWindowsDefaultBounds\nCenterParent"
	DataGridRedraw m_propertiesDataGridId
	stop

#endif
	
#endif
