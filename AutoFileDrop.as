
#ifndef mod_AutoFileDrop

#include "shell32.as"
#include "kernel32.as"
#include "user32.as"

//Define
#define global GMEM_ZEROINIT	$00000040		//メモリの内容を 0 へ初期化

#module mod_AutoFileDrop
//p1: ファイルがドロップされるハンドル
//p2: ドロップするファイルのパス
//p3: ウィンドウの左上からのマウス位置X
//p4: ウィンドウの右上からのマウス位置Y
//p5: ファイルパスの形式 0(規定)=Unicode(NT専用) 1=通常の文字列
#deffunc autodrop int p1,str p2,int p3,int p4,int p5
c1=20 + strlen(p2)*4			//DROPFILES構造体のデータサイズ + 文字列
GlobalAlloc GMEM_ZEROINIT,c1	//グローバルヒープのメモリを初期化
hMem=stat						//初期化されたメモリアドレスを代入
GlobalLock hMem					//グローバルヒープ領域のメモリをロック
p=stat							//構造体の先頭のアドレスを取得
dupptr DropFiles,p,c1			//構造体の取得
DropFiles.0=20					//DROPFILES構造体のデータサイズ
DropFiles.1=p3					//マウスX
DropFiles.2=p4					//マウスY
DropFiles.3=1					//ポインタ取得ON

//Unicodeを使うか使わないか指定[p5](バグがあるかも)
if p5=0{
	//NT用
	DropFiles.4=1
	cnvstow DropFiles.5,p2
}else{
	//9x用
	DropFiles.4=1				//NT系OSの環境ではここを0にするとパスを取得できないらしい
								//9x系OSを持っていないので詳細は不明
	s3=0						//文字列を数値に変換するための変数をint型に変換
	s1=p2						//ファイルパスを変数にする
	repeat strlen(p2)
		s2=strmid(s1,cnt,1)				//一文字だけ取り出す
		poke s3,0,s2					//文字列のを取得
		memcpy DropFiles.5,s3,1,cnt*2	//アスキー文字コード
		memset DropFiles.5,0,1,cnt*2+1	//NULL文字
		locnt=cnt
	loop
	memset DropFiles.5,0,1,locnt*2+2	//一応NULL文字を付加
}
PostMessage p1,WM_DROPFILES,hMem,0	//ドロップメッセージを指定されたウィンドウに送信
GlobalUnlock hMem					//メモリ領域のロックを解除
return 1
#global

#endif