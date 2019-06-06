
#ifndef mod_INI
	
#include "kernel32.as"
	
#module mod_INI
	
#defcfunc INIGetString str _appName, str _keyName, str _default, int _size, str _fileName,\
	local returnedString
	
	sdim returnedString, _size
	GetPrivateProfileString _appName, _keyName, _default, varptr(returnedString), _size, _fileName
	return returnedString
	
#global
	
#endif
