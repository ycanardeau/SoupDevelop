// 指定の検索パスを使って、ファイルを検索する

#ifndef __SEARCH_FILE_EX_MODULE_AS__
#define __SEARCH_FILE_EX_MODULE_AS__

#include "MCStrSet.as"

#module SearchFileEx_mod

#uselib "kernel32.dll"
#func   GetFullPathName@SearchFileEx_mod "GetFullPathNameA" sptr,int,int,nullptr

#define MAX_PATH 260

#deffunc SearchFileEx str p1, str fname
	newmod pathset, MCStrSet, p1, ";"
	sdim   filepath, MAX_PATH
	sdim   curdir, 320
	
	curdir = dirinfo(0)
	
	repeat StrSet_CntItems(pathset) + 1
		
		if ( cnt == 0 ) {
			path = curdir		// カレントディレクトリでも検索する
		} else {
			path = StrSet_getnext(pathset)		// 次の検索パス
		}
		
		if ( path == "" ) { continue }
		
		chdir path
		exist fname
		if ( strsize >= 0 ) {
			GetFullPathName fname, MAX_PATH, varptr(filepath)
			break
		}
	loop
	
	// カレントディレクトリを元に戻す
	chdir curdir
	
	delmod pathset
	
	return filepath
	
#global

#if 0

*main
	// "path;path;..." , "filename"
;	SearchFileEx "D:\\D_MyDocuments;D:\\D_MyDocuments\\DProgramFiles\\hsp31\\common", "Mo/StrSet.as"
	SearchFileEx "D:\\D_MyDocuments\\DProgramFiles\\hsp31\\common;", "Mo/hsptohs.as"
	mes refstr
	stop
	
#endif

#endif
