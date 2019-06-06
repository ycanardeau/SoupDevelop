
#ifndef mod_FolderSelectDialog
	
#module mod_FolderSelectDialog
	
/*#uselib "ole32"
#func CoTaskMemFree "CoTaskMemFree" sptr*/
#include "ole32.as"

#deffunc FolderSelectDialogCreate str _subTitle,\
	local _ret, local subTitle, local folderName, local folderPath, local ItemIdList
	
	sdim subTitle, MAX_PATH
	sdim folderName, MAX_PATH
	sdim folderPath, MAX_PATH
	
	subTitle = _subTitle
	
	ItemIdList.0 = hwnd, 0, varptr(folderName), varptr(subTitle)
	ItemIdList.4 = 0x01, 0, 0, 0
	_ret = SHBrowseForFolder(varptr(ItemIdList))
	if (_ret == 0) {
		return 0
	}
	
	SHGetPathFromIDList _ret, varptr(folderPath)
	
	CoTaskMemFree _ret
	return folderPath
	
#global
	
#endif