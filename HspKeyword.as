
#ifndef mod_HspKeyword

#module mod_HspKeyword

#defcfunc HspKeywordGetStartPos str _strText, int _nIndex,\
		local strText,\
		local strCharSet,\
		local nStart,\
		local strChar,\
		local nFoundIndex
		
		strText = _strText
		
		sdim strCharSet, 256
		strCharSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_#"
	
		nStart = _nIndex - 1
		repeat
			if (nStart < 0) {
				nStart = 0
				break
			}
			strChar = strmid(strText, nStart, 1)
			nFoundIndex = instr(strCharSet, 0, strChar)
			if (nFoundIndex < 0) {
				nStart++
				break
			}
			nStart--
		loop
		return nStart
	
	#defcfunc HspKeywordGetEndPos str _strText, int _nIndex,\
		local strText,\
		local strCharSet,\
		local nLength,\
		local nEnd,\
		local strChar,\
		local nFoundIndex
	
		strText = _strText
		
		sdim strCharSet, 256
		strCharSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_#"
		
		nLength = strlen(strText)
		nEnd = _nIndex
		repeat
			if (nEnd >= nLength) {
				nEnd = nLength
				break
			}
			strChar = strmid(strText, nEnd, 1)
			nFoundIndex = instr(strCharSet, 0, strChar)
			if (nFoundIndex < 0) {
				break
			}
			nEnd++
		loop
		return nEnd

#global

#endif