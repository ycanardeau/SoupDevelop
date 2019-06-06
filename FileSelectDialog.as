
#ifndef __FILESELECTDIALOG_AS__INCLUDED__
#define __FILESELECTDIALOG_AS__INCLUDED__
	
#include "comdlg32.as"
	
#module mod_FileSelectDialog
	
	#deffunc FileSelectDialogCreate int _mode, str _initialDir, str _title, str _file, str _filter, int _index,\
		local _ret, local _refstr, local bmscr,\
		local dialogTitle, local dialogFile, local dialogFilter, local dialogInitialDir, local dialogFileTitle, local dialogFileExtension,\
		local temp, local i, local openfilename
		mref _refstr, 65
		mref bmscr, 67
		
		dialogTitle = _title
		dialogFile = _file
		dialogFilter = _filter
		sdim dialogInitialDir, MAX_PATH
		dialogInitialDir = _initialDir
		
		dialogFilterLength = strlen(dialogFilter)
		sdim temp, dialogFilterLength + 4
		temp = dialogFilter
		
		repeat dialogFilterLength
			i = peek(temp, cnt)
			if (i - 129 & 0xff <= 30) {
				continue cnt + 2
			}
			if (i - 224 & 0xff <= 28) {
				continue cnt + 2
			}
			if (i == '|') {
				poke temp, cnt, 0
			}
		loop
		
		sdim dialogFile, 4096
		dialogFileTitle = ""
		dialogFileExtension = ""
		openfilename.0 = 76
		openfilename.1 = hwnd
		openfilename.2 = bmscr.14
		openfilename.3 = varptr(temp)
		openfilename.4 = 0
		openfilename.5 = 0
		openfilename.6 = _index
		openfilename.7 = varptr(dialogFile)
		openfilename.8 = 4096
		openfilename.9 = varptr(dialogFileTitle)
		openfilename.10 = 4096
		openfilename.11 = varptr(dialogInitialDir)
		openfilename.12 = varptr(dialogTitle)
		if (_mode == 0) {
			openfilename.13 = 0x81004
		}
		if (_mode == 1) {
			openfilename.13 = 0x806
		}
		if (_mode == 2) {
			openfilename.13 = 0x82004
		}
		openfilename.14 = 0
		openfilename.15 = varptr(dialogFileExtension)
		openfilename.16 = 0
		openfilename.17 = 0
		openfilename.18 = 0
		
		if ((_mode & 1) == 0) {
			_ret = GetOpenFileName(varptr(openfilename))
		}
		if (_mode & 1 == 1) {
			_ret = GetSaveFileName(varptr(openfilename))
		}
		
		if (_ret != 0) {
			_refstr = dialogFile
		}
		
		return _ret
	
#global
	
#endif
