; (uxtheme.as)
#ifdef __hsp30__
#ifndef __UXTHEME__
#define global __UXTHEME__
#uselib "UxTheme.dll"
        #func global CloseThemeData "CloseThemeData" int
        #func global DrawThemeBackground "DrawThemeBackground" int, int, int, int, sptr, sptr
        #func global DrawThemeBackgroundEx "DrawThemeBackgroundEx" int, int, int, int, sptr, sptr
        #func global DrawThemeEdge "DrawThemeEdge" int, int, int, int, sptr, int, int, sptr
        #func global DrawThemeIcon "DrawThemeIcon" int, int, int, int, sptr, int, int
        #func global DrawThemeParentBackground "DrawThemeParentBackground" int, int, sptr
        #func global DrawThemeText "DrawThemeText" int, int, int, int, wstr, int, int, int, sptr
        #func global EnableThemeDialogTexture "EnableThemeDialogTexture" int, int
        #func global EnableTheming "EnableTheming" int
        #func global GetCurrentThemeName "GetCurrentThemeName" wptr, int, wptr, int, wptr, int
        #func global GetThemeAppProperties "GetThemeAppProperties"
        #func global GetThemeBackgroundContentRect "GetThemeBackgroundContentRect" int, int, int, int, sptr, sptr
        #func global GetThemeBackgroundExtent "GetThemeBackgroundExtent" int, int, int, int, sptr, sptr
        #func global GetThemeBackgroundRegion "GetThemeBackgroundRegion" int, int, int, int, sptr, sptr
        #func global GetThemeBool "GetThemeBool" int, int, int, int, sptr
        #func global GetThemeColor "GetThemeColor" int, int, int, int, sptr
        #func global GetThemeDocumentationProperty "GetThemeDocumentationProperty" wstr, wstr, wptr, int
        #func global GetThemeEnumValue "GetThemeEnumValue" int, int, int, int, sptr
        #func global GetThemeFilename "GetThemeFilename" int, int, int, int, wptr, int
        #func global GetThemeFont "GetThemeFont" int, int, int, int, int, sptr ; (wptr)
        #func global GetThemeInt "GetThemeInt" int, int, int, int, sptr
        #func global GetThemeIntList "GetThemeIntList" int, int, int, int, sptr
        #func global GetThemeMargins "GetThemeMargins" int, int, int, int, int, sptr, sptr
        #func global GetThemeMetric "GetThemeMetric" int, int, int, int, int, sptr
        #func global GetThemePartSize "GetThemePartSize" int, int, int, int, sptr, int, sptr
        #func global GetThemePosition "GetThemePosition" int, int, int, int, sptr
        #func global GetThemePropertyOrigin "GetThemePropertyOrigin" int, int, int, int, sptr
        #func global GetThemeRect "GetThemeRect" int, int, int, int, sptr
        #func global GetThemeString "GetThemeString" int, int, int, int, wptr, int
        #func global GetThemeSysBool "GetThemeSysBool" int, int
        #func global GetThemeSysColor "GetThemeSysColor" int, int
        #func global GetThemeSysColorBrush "GetThemeSysColorBrush" int, int
        #func global GetThemeSysFont "GetThemeSysFont" int, int, sptr ; (wptr)
        #func global GetThemeSysInt "GetThemeSysInt" int, int, sptr
        #func global GetThemeSysSize "GetThemeSysSize" int, int
        #func global GetThemeSysString "GetThemeSysString" int, int, wptr, int
        #func global GetThemeTextMetrics "GetThemeTextMetrics" int, int, int, int, sptr
        #func global GetWindowTheme "GetWindowTheme" int
        #func global HitTestThemeBackground "HitTestThemeBackground" int, int, int, int, int, sptr, int, int, int, sptr
        #func global IsAppThemed "IsAppThemed"
        #func global IsThemeActive "IsThemeActive"
        #func global IsThemeBackgroundPartiallyTransparent "IsThemeBackgroundPartiallyTransparent" int, int ,int
        #func global IsThemeDialogTextureEnabled "IsThemeDialogTextureEnabled" int
        #func global IsThemePartDefined "IsThemePartDefined" int, int, int
        #func global OpenThemeData "OpenThemeData" int, wstr
        #func global SetThemeAppProperties "SetThemeAppProperties" int
        #func global SetWindowTheme "SetWindowTheme" int, wstr, wstr
        ; ñ¢äÆÅH
#endif
#endif