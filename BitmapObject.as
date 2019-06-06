
#ifndef mod_BitmapObject
	
#include "gdi32.as"
	
#module mod_BitmapObject
	
	#defcfunc CreateDDB int _x, int _y, int _width, int _height,\
		local hdcDisplay,\
		local hbitmap,\
		local hdcDib
	
		hdcDisplay = CreateDC("DISPLAY", 0, 0, 0)
		hbitmap = CreateCompatibleBitmap(hdcDisplay, _width, _height)
		hdcDib = CreateCompatibleDC(hdcDisplay)
		SelectObject hdcDib, hbitmap
		BitBlt hdcDib, 0, 0, _width, _height, hdc, _x, _y, SRCCOPY
		DeleteDC hdcDisplay
		DeleteDC hdcDib
		return hbitmap
	
	#defcfunc CreateDIB int _x, int _y, int _width, int _height,\
		local hbitmap, local hdcMemory
	
		hbitmap = CreateCompatibleBitmap(hdc, _width, _height)
		hdcMemory = CreateCompatibleDC(hdc)
		SelectObject hdcMemory, hbitmap
		BitBlt hdcMemory, 0, 0, _width, _height, hdc, _x, _y, SRCCOPY
		DeleteDC hdcMemory
		return hbitmap
	
#global
	
#endif
