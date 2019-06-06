
#ifndef mod_FormPainter
	
#include "user32.as"
#include "gdi32.as"
#include "uxtheme.as"

#module mod_FormPainter

	#define BP_PUSHBUTTON 1
	#define BP_RADIOBUTTON 2
	#define BP_CHECKBOX 3
	
	#define PBS_NORMAL 1
	#define PBS_HOT 2
	#define PBS_PRESSED 3
	
	#define RBS_UNCHECKEDNORMAL 1
	
	#define CBS_UNCHECKEDNORMAL 0
	#define CBS_CHECKEDNORMAL 1
	#define CBS_MIXEDNORMAL 2
	
	#define EP_BACKGROUNDWITHBORDER 5
	
	#define EBWBS_NORMAL 1
	#define EBWBS_HOT 2
	#define EBWBS_DISABLED 3
	#define EBWBS_FOCUSED 4
	
	#define CP_READONLY 5
	#define CP_DROPDOWNBUTTONRIGHT 6
	#define CP_DROPDOWNBUTTONLEFT 7
	
	#define CBRO_NORMAL 1
	
	#define CBXSR_NORMAL 1
	
	#deffunc FormPainterDrawButton int _x, int _y, int _width, int _height, str _string,\
		local isAvailableVisualStyle,\
		local hTheme,\
		local rect
		
		if (varptr(OpenThemeData) == 0) {
			isAvailableVisualStyle = false
		} else {
			hTheme = OpenThemeData(hwnd, "BUTTON")
			if (hTheme == 0) {
				isAvailableVisualStyle = false
			} else {
				isAvailableVisualStyle = true
			}
		}
		
		rect = _x, _y, _x + _width, _y + _height
		FillRect hdc, varptr(rect), GetSysColorBrush($0000000F/*COLOR_BTNFACE*/)
		
		rect = _x, _y, _x + _width, _y + _height
		if (isAvailableVisualStyle == false) {
			DrawFrameControl hdc, varptr(rect), DFC_BUTTON, DFCS_BUTTONPUSH
		} else {
			DrawThemeBackground hTheme, hdc, BP_PUSHBUTTON, PBS_NORMAL, varptr(rect), null
		}
		sysfont 17 : syscolor 18
		DrawText hdc, _string, strlen(_string), varptr(rect), DT_CENTER | DT_SINGLELINE | DT_VCENTER
		
		CloseThemeData hTheme
		return
		
	#deffunc FormPainterDrawCheckBox int _x, int _y, int _width, int _height, str _string,\
		local isAvailableVisualStyle,\
		local hTheme,\
		local rect
		
		if (varptr(OpenThemeData) == 0) {
			isAvailableVisualStyle = false
		} else {
			hTheme = OpenThemeData(hwnd, "BUTTON")
			if (hTheme == 0) {
				isAvailableVisualStyle = false
			} else {
				isAvailableVisualStyle = true
			}
		}
		
		rect = _x, _y, _x + _width, _y + _height
		FillRect hdc, varptr(rect), GetSysColorBrush($0000000F/*COLOR_BTNFACE*/)
		
		rect = _x, (_height - 13) / 2 + _y, rect(0) + 13, rect(1) + 13
		if (isAvailableVisualStyle == false) {
			DrawFrameControl hdc, varptr(rect), DFC_BUTTON, $00000000/*DFCS_BUTTONCHECK*/
		} else {
			DrawThemeBackground hTheme, hdc, BP_CHECKBOX, CBS_UNCHECKEDNORMAL, varptr(rect), null
		}
		rect = _x + 13 + 3, (_height - 13) / 2 + _y, _x + _width, rect(1) + 13
		sysfont 17 : syscolor 18
		DrawText hdc, _string, strlen(_string), varptr(rect), DT_SINGLELINE | DT_VCENTER
		
		CloseThemeData hTheme
		return
		
	#deffunc FormPainterDrawTextBox int _x, int _y, int _width, int _height, str _string,\
		local isAvailableVisualStyle,\
		local hTheme,\
		local rect
		
		if (varptr(OpenThemeData) == 0) {
			isAvailableVisualStyle = false
		} else {
			hTheme = OpenThemeData(hwnd, "EDIT")
			if (hTheme == 0) {
				isAvailableVisualStyle = false
			} else {
				isAvailableVisualStyle = true
			}
		}
		
		rect = _x, _y, _x + _width, _y + _height
		FillRect hdc, varptr(rect), GetSysColorBrush($0000000F/*COLOR_BTNFACE*/)
		
		rect = _x, _y, _x + _width, _y + _height
		if (isAvailableVisualStyle == false) {
			FillRect hdc, varptr(rect), GetSysColorBrush($00000005/*COLOR_WINDOW*/)
			DrawEdge hdc, varptr(rect), EDGE_SUNKEN, BF_RECT
		} else {
			DrawThemeBackground hTheme, hdc, EP_BACKGROUNDWITHBORDER, EBWBS_NORMAL, varptr(rect), null
		}
		rect = _x + 4, _y, _x + _width, _y + _height
		sysfont 17 : syscolor 18
		DrawText hdc, _string, strlen(_string), varptr(rect), DT_SINGLELINE | DT_VCENTER
		
		CloseThemeData hTheme
		return
		
	#deffunc FormPainterDrawRadioButton int _x, int _y, int _width, int _height, str _string,\
		local isAvailableVisualStyle,\
		local hTheme,\
		local rect
		
		if (varptr(OpenThemeData) == 0) {
			isAvailableVisualStyle = false
		} else {
			hTheme = OpenThemeData(hwnd, "BUTTON")
			if (hTheme == 0) {
				isAvailableVisualStyle = false
			} else {
				isAvailableVisualStyle = true
			}
		}
		
		rect = _x, _y, _x + _width, _y + _height
		FillRect hdc, varptr(rect), GetSysColorBrush($0000000F/*COLOR_BTNFACE*/)
		
		rect = _x, (_height - 13) / 2 + _y, rect(0) + 13, rect(1) + 13
		if (isAvailableVisualStyle == false) {
			DrawFrameControl hdc, varptr(rect), DFC_BUTTON, $00000004/*DFCS_BUTTONRADIO*/
		} else {
			DrawThemeBackground hTheme, hdc, BP_RADIOBUTTON, RBS_UNCHECKEDNORMAL, varptr(rect), null
		}
		rect = _x + 13 + 3, (_height - 13) / 2 + _y, _x + _width, rect(1) + 13
		sysfont 17 : syscolor 18
		DrawText hdc, _string, strlen(_string), varptr(rect), DT_SINGLELINE | DT_VCENTER
		
		CloseThemeData hTheme
		return
		
	#deffunc FormPainterDrawComboBox int _x, int _y, int _width, int _height, str _string,\
		local isAvailableVisualStyle,\
		local hTheme,\
		local rect
		
		if (varptr(OpenThemeData) == 0) {
			isAvailableVisualStyle = false
		} else {
			hTheme = OpenThemeData(hwnd, "COMBOBOX")
			if (hTheme == 0) {
				isAvailableVisualStyle = false
			} else {
				isAvailableVisualStyle = true
			}
		}
		
		rect = _x, _y, _x + _width, _y + _height
		FillRect hdc, varptr(rect), GetSysColorBrush($0000000F/*COLOR_BTNFACE*/)
		
		rect = _x, _y, _x + _width, _y + _height
		if (isAvailableVisualStyle == false) {
			FillRect hdc, varptr(rect), GetSysColorBrush($00000005/*COLOR_WINDOW*/)
			DrawEdge hdc, varptr(rect), EDGE_SUNKEN, BF_RECT
			rect = _x + _width - 16 - 2, _y + 2, _x + _width - 2, _y + _height - 2
			DrawFrameControl hdc, varptr(rect), DFC_SCROLL, $00000005/*DFCS_SCROLLCOMBOBOX*/
		} else {
			DrawThemeBackground hTheme, hdc, CP_READONLY, EBWBS_NORMAL, varptr(rect), null
			rect = _x + _width - 16 - 1, _y, _x + _width - 1, _y + _height
			DrawThemeBackground hTheme, hdc, CP_DROPDOWNBUTTONRIGHT, CBXSR_NORMAL, varptr(rect), null
		}
		rect = _x + 4, _y, _x + _width, _y + _height
		sysfont 17 : syscolor 18
		DrawText hdc, _string, strlen(_string), varptr(rect), DT_SINGLELINE | DT_VCENTER
		
		CloseThemeData hTheme
		return
	
	#deffunc FormPainterDrawLabel int _x, int _y, int _width, int _height, str _string,\
		local isAvailableVisualStyle,\
		local hTheme,\
		local rect
		
		rect = _x, _y, _x + _width, _y + _height
		FillRect hdc, varptr(rect), GetSysColorBrush($0000000F/*COLOR_BTNFACE*/)
		sysfont 17 : syscolor 18
		DrawText hdc, _string, strlen(_string), varptr(rect), DT_LEFT
		return
	
#define RP_BACKGROUND 6
	
	#deffunc FormPainterDrawMenuBar int _x, int _y, int _width, int _height,\
		local isAvailableVisualStyle,\
		local hTheme,\
		local rect
		
		if (varptr(OpenThemeData) == 0) {
			isAvailableVisualStyle = false
		} else {
			hTheme = OpenThemeData(hwnd, "REBAR")
			if (hTheme == 0) {
				isAvailableVisualStyle = false
			} else {
				isAvailableVisualStyle = true
			}
		}
		
		rect = _x, _y, _x + _width, _y + _height
		FillRect hdc, varptr(rect), GetSysColorBrush($0000000F/*COLOR_BTNFACE*/)
		
		rect = _x, _y, _x + _width, _y + _height
		if (isAvailableVisualStyle == false) {
			//
		} else {
			DrawThemeBackground hTheme, hdc, RP_BACKGROUND, null, varptr(rect), null
		}
		
		CloseThemeData hTheme
		return
	
#global

#endif