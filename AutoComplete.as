
#ifndef mod_AutoComplete
	
#include "user32.as"
	
#include "hscallbk.as"
#include "ListBox.as"
#include "HspKeyword.as"
#include "String.as"
	
#module mod_AutoComplete
	
	#const AutoCompleteWndWidth		204
	#const AutoCompleteWndHeight	126
	
	#uselib ""
	#func AutoCompleteProc "" int, int, int, int
	
	#deffunc AutoCompleteInit int _wndId,\
		local selWndID,\
		local hParentWnd, local hListBox
	
		selWndID = ginfo_sel
		
		dimtype m_exListBox, 5
		
		dim m_hParentWnd
	
		sdim m_keywordDataBase
		dim m_nKeywords
	
		dim m_keywordStartPos
		dim m_keywordEndPos
		sdim m_inputKeyword
		sdim m_outputKeyword
	
		dim m_hParentWnd
		
		m_isShow = false
		
		hParentWnd = hwnd
		bgscr _wndId, AutoCompleteWndWidth, AutoCompleteWndHeight, screen_hide
		title "AutoCompleteWnd"
		m_hAutoCompleteWnd = hwnd
		SetWindowLong m_hAutoCompleteWnd, GWL_HWNDPARENT, hParentWnd
		SetWindowLong m_hAutoCompleteWnd, GWL_STYLE, WS_POPUP
		
		sdim m_candidate
		font msgothic, 15
		newmod m_exListBox, mod_ListBox, WS_EX_DLGMODALFRAME, LBS_NOTIFY | LBS_SORT, m_candidate, 0, 0, ginfo_winx, ginfo_winy, 0
		hListBox = ListBoxGetWnd(m_exListBox)
		dim m_lpfnProc
		dim m_lpfnDefListBox
		setcallbk m_lpfnProc, AutoCompleteProc, *OnProc
		m_lpfnDefListBox = GetWindowLong(hListBox, GWL_WNDPROC)
		SetWindowLong hListBox, GWL_WNDPROC, varptr(m_lpfnProc)
	
		gsel selWndID
		return
	
	#defcfunc AutoCompleteWndGetWnd
		return m_hAutoCompleteWnd
	
	#deffunc AutoCompleteWndSetParent int _m_hParentWnd
		m_hParentWnd = _m_hParentWnd
		return
	
	#deffunc AutoCompleteSetKeyword str _keywordDataBase
		m_keywordDataBase = _keywordDataBase
		notesel m_keywordDataBase
		m_nKeywords = notemax
		noteunsel
		return
	
#if 0
	#deffunc AutoCompleteAddKeyword str _keywordGroup, str _keywordName
		m_keywordDataBase += _keywordGroup + "\t" + _keywordName + "\n"
		m_nKeywords++
		return
#endif
	
	#deffunc AutoCompleteWndShow int _isShow
		m_isShow = _isShow
		if (_isShow == false) {
			ShowWindow m_hAutoCompleteWnd, SW_HIDE
		} else {
			ShowWindow m_hAutoCompleteWnd, SW_SHOW
		}
		return
	
	#defcfunc AutoCompleteWndIsShow
		return m_isShow
	
	#deffunc AutoCompleteWndMove\
		local point,\
		local parentWndX, local parentWndY
		
		dim point, 2
		ClientToScreen m_hParentWnd, varptr(point)
		parentWndX = point(0)
		parentWndY = point(1)
		
		dim point, 2
		GetCaretPos varptr(point)
		point(0) += parentWndX
		point(1) += parentWndY
		
		SetWindowPos m_hAutoCompleteWnd, HWND_TOP, point(0), point(1) + 17, 0, 0, SWP_NOACTIVATE | SWP_SHOWWINDOW | SWP_NOSIZE
		return
	
	#deffunc AutoCompleteBegin var _szLine, int _caretPos,\
		local keyword,\
		local len,\
		local index, local i,\
		local lineData,\
		local keywordGroup, local keywordName
	
		m_keywordStartPos = HspKeywordGetStartPos(_szLine, _caretPos)
		m_keywordEndPos = HspKeywordGetEndPos(_szLine, _caretPos)
		m_inputKeyword = strmid(_szLine, m_keywordStartPos, m_keywordEndPos - m_keywordStartPos)
		
		m_candidate = ""
		sdim lineData
		index = 0
		len = strlen(m_keywordDataBase)
		while (index < len)
			getstr keywordName, m_keywordDataBase, index
			index += strsize
	
			if (instr(keywordName, 0, m_inputKeyword) == 0) {
				m_candidate += keywordName + "\n"
			}
		wend

		if (m_candidate == "") {
			ListBoxSetCurSel m_exListBox, -1
		} else {
			ListBoxResetContent m_exListBox, m_candidate
			ListBoxSetCurSel m_exListBox, 0
		}
	
		if (_caretPos == m_keywordStartPos && _caretPos == m_keywordEndPos) {
			AutoCompleteWndShow false
		} else {
			if (_caretPos == m_keywordEndPos && strlen(m_inputKeyword) == 1 && wparam != VK_BACK) {
				AutoCompleteWndMove
				notesel m_candidate
				if (notemax == 0) {
					AutoCompleteWndShow false
				} else {
					AutoCompleteWndShow true
				}
				noteunsel
			}
		}
		return
	
	#deffunc AutoCompleteEnd
		AutoCompleteWndShow false
		return
	
	#deffunc AutoCompleteSelect int _keycode
		sendmsg ListBoxGetWnd(m_exListBox), WM_KEYDOWN, _keycode, 0
		return
	
	#deffunc AutoCompleteEnter
		sendmsg ListBoxGetWnd(m_exListBox), WM_LBUTTONDBLCLK, 0, 0
		return
	
	#defcfunc AutoCompleteGetCurSel
		return ListBoxGetCurSel(m_exListBox)
	
	#defcfunc AutoCompleteGetOutputKeyword
		return m_outputKeyword
	
	#defcfunc AutoCompleteGetKeywordStartPos
		return m_keywordStartPos
	
	#defcfunc AutoCompleteGetKeywordEndPos
		return m_keywordEndPos
	
	*OnProc
		listBox_Proc
		return
	#deffunc local listBox_Proc\
		local hCtl, local uMsg, local wp, local lp
		
		hCtl = callbkarg(0)
		uMsg = callbkarg(1)
		wp = callbkarg(2)
		lp = callbkarg(3)
		
		switch (uMsg)
			case WM_LBUTTONDBLCLK
				m_outputKeyword = ListBoxGetText(m_exListBox, ListBoxGetCurSel(m_exListBox))
				if (m_outputKeyword != "") {
					sendmsg m_hParentWnd, WM_COMMAND, MAKELONG(0, 0x00000002/*LBN_DBLCLK*/), m_hAutoCompleteWnd
				}
				
				AutoCompleteEnd
				SetFocus m_hParentWnd
				swbreak
			case WM_KEYDOWN
				switch (wp)
				case VK_RETURN
					AutoCompleteEnter
					swbreak
				case VK_ESCAPE
					AutoCompleteEnd
					SetFocus m_hParentWnd
					swbreak
				default
					return CallWindowProc(m_lpfnDefListBox, hCtl, uMsg, wp, lp)
				swend
				swbreak
			default
				return CallWindowProc(m_lpfnDefListBox, hCtl, uMsg, wp, lp)
		swend
		return 0
	
#global
	
#endif
