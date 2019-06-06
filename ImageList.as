
#ifndef mod_ImageList
	
#include "comctl32.as"
#include "BitmapObject.as"
	
#module mod_ImageList\
	m_hImageList
	
	#modinit int _width, int _height, int _type, int _number
		InitCommonControls
		m_hImageList = ImageList_Create(_width, _height, _type, _number, 0)
		return
	
	#modterm
		ImageList_Destroy m_hImageList
		return
	
	#modcfunc ImageListGet
		return m_hImageList
	
	#modfunc ImageListAdd int _x, int _y, int _width, int _height, int _maskColor,\
		local hbitmap, local index
	
		hbitmap = CreateDIB(_x, _y, _width, _height)
		index = imageList_AddMasked(m_hImageList, hbitmap, _maskColor)
		return index
	
	#modfunc ImageListDraw int _index, int _x, int _y,\
		local bmscr
		
		mref bmscr, 67
		ImageList_Draw m_hImageList, _index, bmscr(4), _x, _y, 0x0001
		return
	
#global
	
#endif
