
#ifndef mod_ScrollBar
	
#module mod_ScrollBar\
	m_hScrollBar
	
	/**
	 * 
	 * @brief �X�N���[���o�[���쐬���܂��B
	 * @param _style �E�B���h�E�X�^�C��
	 * @param _x X���W
	 * @param _y Y���W
	 * @param _width ��
	 * @param _height ����
	 * @param _nMin �ŏ��l
	 * @param _nMax �ő�l
	 * @param _nPage �y�[�W
	 */
	#modinit int _style, int _x, int _y, int _width, int _height, int _nMin, int _nMax, int _nPage,\
		local mod_id,\
		local scrollinfo
		
		dim mod_id : mref mod_id, 2
		
		pos _x, _y
		winobj "ScrollBar", "", 0, WS_CHILD | WS_VISIBLE | _style, _width, _height, 0, 0
		m_hScrollBar = objinfo_hwnd(stat)
		
		dim scrollinfo, 7
		scrollinfo(0) = 28	// cbSize
		scrollinfo(1) = SIF_ALL	// fMask
		scrollinfo(2) = _nMin	// nMin
		scrollinfo(3) = _nMax	// nMax
		scrollinfo(4) = _nPage	// nPage
		scrollinfo(5) = 0	// nPos
		scrollinfo(6) = 0	// nTrackPos
		sendmsg m_hScrollBar, SBM_SETSCROLLINFO, true, varptr(scrollinfo)
		return mod_id
	
	/**
	 * ScrollBarGetWnd
	 * @breif �X�N���[���o�[�̃E�B���h�E�n���h�����擾���܂��B
	 * @return �X�N���[���o�[�̃E�B���h�E�n���h��
	 */
	#modcfunc ScrollBarGetWnd
		return m_hScrollBar
	
	#modfunc ScrollBarMove int _x, int _y, int _width, int _height
		MoveWindow m_hScrollBar, _x, _y, _width, _height, true
		return
	
	/**
	 * ScrollBarGetPos
	 * @brief �܂݂̈ʒu���擾���܂��B
	 * @return �܂݂̈ʒu
	 */
	#modcfunc ScrollBarGetPos\
		local scrollinfo
		
		dim scrollinfo, 7
		scrollinfo(0) = 28
		scrollinfo(1) = SIF_ALL
		sendmsg m_hScrollBar, SBM_GETSCROLLINFO, false, varptr(scrollinfo)
		return limit(scrollinfo(5), scrollinfo(2), scrollinfo(3))
	
	/**
	 * ScrollBarSetMax _nMax
	 * @brief �ő�l��ݒ肵�܂��B
	 * @param _nMax �ő�l
	 */
	#modfunc ScrollBarSetMax int _nMax,\
		local scrollinfo
		
		dim scrollinfo, 7
		scrollinfo(0) = 28
		scrollinfo(1) = SIF_ALL
		sendmsg m_hScrollBar, SBM_GETSCROLLINFO, false, varptr(scrollinfo)
		scrollinfo(3) = _nMax
		sendmsg m_hScrollBar, SBM_SETSCROLLINFO, true, varptr(scrollinfo)
		return
	
	#deffunc ScrollBar_Scroll\
		local scrollinfo
		
		dim scrollinfo, 7
		scrollinfo(0) = 28
		scrollinfo(1) = SIF_ALL
		sendmsg lparam, SBM_GETSCROLLINFO, false, varptr(scrollinfo)
		switch (LOWORD(wparam))
			/*case SB_TOP
				scrollinfo(5) = scrollinfo(2)
				swbreak
			case SB_BOTTOM
				scrollinfo(5) = scrollinfo(3)
				swbreak*/
			case SB_LINEUP
				if (scrollinfo(5) != 0) {
					scrollinfo(5)--
				}
				swbreak
			case SB_LINEDOWN
				if (scrollinfo(5) < scrollinfo(3) - 1) {
					scrollinfo(5)++
				}
				swbreak
			case SB_PAGEUP
				scrollinfo(5) -= scrollinfo(4)
				swbreak
			case SB_PAGEDOWN
				scrollinfo(5) += scrollinfo(4)
				swbreak
			case SB_THUMBTRACK/*SB_THUMBPOSITION*/
				scrollinfo(5) = HIWORD(wparam)
				swbreak
		swend
		sendmsg lparam, SBM_SETSCROLLINFO, true, varptr(scrollinfo)
		return
	
#global
	
#if 0
	
	screen 0
	
	dimtype scrollBar, 5
	newmod scrollBar, mod_ScrollBar, SBS_VERT, ginfo_winx - 17, 0, 17, ginfo_winy, 0, 9, 2
	
	oncmd gosub *OnScroll, WM_VSCROLL
	
	stop
	
*OnScroll
	ScrollBar_Scroll
	return
	
#endif
	
#endif