
// http://fs-cgi-basic01.freespace.jp/~hsp/ver3/hsp3.cgi?print+200509/05090024.txt

#ifndef mod_FindReplaceDialog
	
#include "comdlg32.as"
#include "user32.as"
	
#module mod_FindReplaceDialog
	
#defcfunc FindReplaceDialogGetMessageID
	return RegisterWindowMessage("commdlg_FindReplace")
	
#deffunc FindReplaceDialogCreate int _mode, int _style, int _findStringPointer, int _replaceStringPointer, var _message,\
	local findreplace
	
	dim findreplace, 10
	findreplace(0) = 40
	findreplace(1) = hwnd
	findreplace(2) = hinstance
	findreplace(3) = _style
	findreplace(4) = _findStringPointer
	findreplace(5) = _replaceStringPointer
	findreplace(6) = MAKELONG(255, 255)
	findreplace(7) = 0
	findreplace(8) = 0
	findreplace(9) = 0
	
	dup _message, findreplace(3)
	
	if (_mode == 0) {
		return FindText(varptr(findreplace))
	} else {
		return ReplaceText(varptr(findreplace))
	}
	return null
	
#global
	
#if 0

	findString = ""
	FindReplaceDialogCreate 0, FR_DOWN | FR_FINDNEXT | FR_HIDEWHOLEWORD, varptr(findString), null
	stop

#endif
	
#endif