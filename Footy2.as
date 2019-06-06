// =============================================
// Footy2.as ver. 1.0 2008/01/05
//     for HSP3.1 & Footy2.dll2.013
//     by eller
//     （さくらさんのスクリプトを参考とさせていただきました）
// =============================================
// Footyテキストエディタコントロール2 ver. 2.013
//     (C)2004-2007 ShinjiWatanabe
//     http://www.hpp.be/
// =============================================
// 【注意事項】
//     Footy2本体のバグと思われるものは
//     下記URLへ報告してください。
//     http://www.hpp.be:8080/trac/Footy
//
//     HSPでFooty2を使う方法などの質問は
//     Footy2の作者であるなべしんさんには
//     しないでください。
// =============================================

#ifdef	__hsp30__
#ifndef	_FOOTY2_DLL_H_
#define	global _FOOTY2_DLL_H_
#uselib	"Footy2.dll"

// ************
// 外部DLL呼び出し命令登録
// ************
// バージョン取得関数（ヘルプの3章）
#func global GetFooty2Ver "GetFooty2Ver"
#func global GetFooty2BetaVer "GetFooty2BetaVer"

// ウィンドウ操作関数（ヘルプの4章）
#func global Footy2Create "Footy2Create" int, int, int, int, int, int
#func global Footy2Delete "Footy2Delete" int
#func global Footy2Move "Footy2Move" int, int, int, int, int
#func global Footy2ChangeView "Footy2ChangeView" int, int
#func global Footy2SetFocus "Footy2SetFocus" int, int
#func global Footy2GetWnd "Footy2GetWnd" int, int
#func global Footy2GetWndVSplit "Footy2GetWndVSplit" int
#func global Footy2GetWndHSplit "Footy2GetWndHSplit" int
#func global Footy2GetActiveView "Footy2GetActiveView" int
#func global Footy2Refresh "Footy2Refresh" int

// 編集コマンド（ヘルプの5章）
#func global Footy2Copy "Footy2Copy" int
#func global Footy2Cut "Footy2Cut" int
#func global Footy2Paste "Footy2Paste" int
#func global Footy2Undo "Footy2Undo" int
#func global Footy2Redo "Footy2Redo" int
#func global _Footy2IsEdited "Footy2IsEdited" int
#define	global ctype Footy2IsEdited( %1 ) ( _Footy2IsEdited( %1 ) & 0xff )
#func global _Footy2SelectAll "Footy2SelectAll" int, int
#define	global Footy2SelectAll( %1, %2 = 1 ) _Footy2SelectAll %1, %2
#func global Footy2ShiftLock "Footy2ShiftLock" int, int
#func global _Footy2IsShiftLocked "Footy2IsShiftLocked" int
#define	global ctype Footy2IsShiftLocked( %1 ) ( _Footy2IsShiftLocked( %1 ) & 0xff )
#func global Footy2SearchA "Footy2SearchA" int, sptr, int
#func global Footy2SearchW "Footy2SearchW" int, wptr, int

// ファイル操作（ヘルプの6章）
#func global Footy2CreateNew "Footy2CreateNew" int
#func global Footy2TextFromFileA "Footy2TextFromFileA" int, sptr, int
#func global Footy2TextFromFileW "Footy2TextFromFileW" int, wptr, int
#func global Footy2SaveToFileA "Footy2SaveToFileA" int, sptr, int, int
#func global Footy2SaveToFileW "Footy2SaveToFileW" int, wptr, int, int
#func global Footy2GetCharSet "Footy2GetCharSet" int
#func global Footy2GetLineCode "Footy2GetLineCode" int

// 文字列処理（ヘルプの7章）
#func global Footy2SetSelTextA "Footy2SetSelTextA" int, sptr
#func global Footy2SetSelTextW "Footy2SetSelTextW" int, wptr
#func global Footy2SetTextA "Footy2SetTextA" int, sptr
#func global Footy2SetTextW "Footy2SetTextW" int, wptr
#func global Footy2GetCaretPosition "Footy2GetCaretPosition" int, int, int	// 第2～第3引数はvarptr()を使ってポインタを渡すこと
#func global _Footy2SetCaretPosition "Footy2SetCaretPosition" int, int, int, int
#define	global Footy2SetCaretPosition( %1, %2, %3, %4 = 1 ) _Footy2SetCaretPosition %1, %2, %3, %4
#func global Footy2GetSel "Footy2GetSel" int, int, int, int, int	// 第2～第4引数はvarptr()を使ってポインタを渡すこと
#func global _Footy2SetSel "Footy2SetSel" int, int, int, int, int, int
#define	global Footy2SetSel( %1, %2, %3, %4, %5, %6 = 1 ) _Footy2SetSel %1, %2, %3, %4, %5, %6
#func global Footy2GetTextLengthA "Footy2GetTextLengthA" int, int
#func global Footy2GetTextLengthW "Footy2GetTextLengthW" int, int
#func global Footy2GetSelLength "Footy2GetSelLengthA" int, int
#func global Footy2GetTextA "Footy2GetTextA" int, sptr, int, int
#func global Footy2GetTextW "Footy2GetTextW" int, wptr, int, int
#func global Footy2GetSelTextA "Footy2GetSelTextA" int, sptr, int, int
#func global Footy2GetSelTextW "Footy2GetSelTextW" int, wptr, int, int
#func global Footy2GetLineW "Footy2GetLineW" int, int
#func global Footy2GetLineA "Footy2GetLineA" int, int, sptr, int
#func global Footy2GetLineLengthW "Footy2GetLineLengthW" int, int
#func global Footy2GetLineLengthA "Footy2GetLineLengthA" int, int
#func global Footy2GetLines "Footy2GetLines" int

// 表示設定（ヘルプの8章）
#func global Footy2AddEmphasisA "Footy2AddEmphasisA" int, sptr, sptr, int, int, int, int, int, int
#func global Footy2AddEmphasisW "Footy2AddEmphasisW" int, wptr, wptr, int, int, int, int, int, int
#func global Footy2FlushEmphasis "Footy2FlushEmphasis" int
#func global Footy2ClearEmphasis "Footy2ClearEmphasis" int
#func global _Footy2SetFontFaceA "Footy2SetFontFaceA" int, int, sptr, int
#define	global Footy2SetFontFaceA( %1, %2, %3, %4 = 1 ) _Footy2SetFontFaceA %1, %2, %3, %4
#func global _Footy2SetFontFaceW "Footy2SetFontFaceW" int, int, wptr, int
#define	global Footy2SetFontFaceW( %1, %2, %3, %4 = 1 ) _Footy2SetFontFaceW %1, %2, %3, %4
#func global _Footy2SetFontSize "Footy2SetFontSize" int, int, int
#define	global Footy2SetFontSize( %1, %2, %3 = 1 ) _Footy2SetFontSize %1, %2, %3
#func global _Footy2SetLineIcon "Footy2SetLineIcon" int, int, int, int
#define	global Footy2SetLineIcon( %1, %2, %3, %4 = 1 ) _Footy2SetLineIcon %1, %2, %3, %4
#func global Footy2GetLineIcon "Footy2GetLineIcon" int, int, int	// 第3引数はvarptr()を使ってポインタを渡すこと
#func global _Footy2SetMetrics "Footy2SetMetrics" int, int, int, int
#define	global Footy2SetMetrics( %1, %2, %3, %4 = 1 ) _Footy2SetMetrics %1, %2, %3, %4
#func global Footy2GetMetrics "Footy2GetMetrics" int, int, int	// 第3引数はvarptr()を使ってポインタを渡すこと
#func global Footy2GetVisibleColumns "Footy2GetVisibleColumns" int, int
#func global Footy2GetVisibleLines "Footy2GetVisibleLines" int, int
#func global _Footy2SetLepal "Footy2SetLepal" int, int, int, int
#define	global Footy2SetLepal( %1, %2, %3, %4 = 1 ) _Footy2SetLepal %1, %2, %3, %4
#func global _Footy2SetColor "Footy2SetColor" int, int, int, int
#define	global Footy2SetColor( %1, %2, %3, %4 = 1 ) _Footy2SetColor %1, %2, %3, %4

// イベントの監視（ヘルプの9章）
#func global Footy2SetFuncFocus "Footy2SetFuncFocus" int, int, int, int
#func global Footy2SetFuncMoveCaret "Footy2SetFuncMoveCaret" int, int, int, int
#func global Footy2SetFuncTextModified "Footy2SetFuncTextModified" int, int, int
#func global Footy2SetFuncInsertModeChanged "Footy2SetFuncInsertModeChanged" int, int, int

#ifdef _UNICODE
// "～W"で終わる命令・関数を"W"なしで呼び出せるように定義
#define	global Footy2AddEmphasis			Footy2AddEmphasisW
#define	global Footy2SetText				Footy2SetTextW
#define	global Footy2SetSelText				Footy2SetSelTextW
#define	global ctype Footy2GetTextLength	Footy2GetTextLengthW
#define	global ctype Footy2GetLine			Footy2GetLineW
#define	global Footy2SetLine				Footy2SetLineW
#define	global ctype Footy2GetLineLength	Footy2GetLineLengthW
#define	global Footy2TextFromFile			Footy2TextFromFileW
#define	global Footy2SaveToFile				Footy2SaveToFileW
#define	global Footy2SetFontFace			Footy2SetFontFaceW
#define	global Footy2Search					Footy2SearchW
#define	global Footy2GetText				Footy2GetTextW
#define	global Footy2GetSelText				Footy2GetSelTextW
#else
// "～A"で終わる命令・関数を"A"なしで呼び出せるように定義
#define	global Footy2AddEmphasis			Footy2AddEmphasisA
#define	global Footy2SetText				Footy2SetTextA
#define	global Footy2SetSelText				Footy2SetSelTextA
#define	global ctype Footy2GetTextLength	Footy2GetTextLengthA
#define	global ctype Footy2GetLine			Footy2GetLineA
#define	global Footy2SetLine				Footy2SetLineA
#define	global ctype Footy2GetLineLength	Footy2GetLineLengthA
#define	global Footy2TextFromFile			Footy2TextFromFileA
#define	global Footy2SaveToFile				Footy2SaveToFileA
#define	global Footy2SetFontFace			Footy2SetFontFaceA
#define	global Footy2Search					Footy2SearchA
#define	global Footy2GetText				Footy2GetTextA
#define	global Footy2GetSelText				Footy2GetSelTextA
#endif


// ************
// マクロの宣言
// ************
#define	global ctype PERMIT_LEVEL(%1)		(1 << (%1))


// ************
// 定数の宣言
// ************
// URLタイプ（UrlType）
#enum	global URLTYPE_HTTP = 0						//!< http
#enum	global URLTYPE_HTTPS						//!< https
#enum	global URLTYPE_FTP							//!< ftp
#enum	global URLTYPE_MAIL							//!< メールアドレス

// テキストが編集された原因（TextModifiedCause）
#enum	global MODIFIED_CAUSE_CHAR = 0				//!< 文字が入力された(IMEオフ)
#enum	global MODIFIED_CAUSE_IME					//!< 文字が入力された(IMEオン)
#enum	global MODIFIED_CAUSE_DELETE				//!< Deleteキーが押下された
#enum	global MODIFIED_CAUSE_BACKSPACE				//!< BackSpaceが押下された
#enum	global MODIFIED_CAUSE_ENTER					//!< Enterキーが押下された
#enum	global MODIFIED_CAUSE_UNDO					//!< 元に戻す処理が実行された
#enum	global MODIFIED_CAUSE_REDO					//!< やり直し処理が実行された
#enum	global MODIFIED_CAUSE_CUT					//!< 切り取り処理が実行された
#enum	global MODIFIED_CAUSE_PASTE					//!< 貼り付け処理が実行された
#enum	global MODIFIED_CAUSE_INDENT				//!< インデントされた
#enum	global MODIFIED_CAUSE_UNINDENT				//!< 逆インデントされた
#enum	global MODIFIED_CAUSE_TAB					//!< タブキーが押されて、タブ文字が挿入された

// ビュー状態（ViewMode）
#enum	global VIEWMODE_NORMAL = 0
#enum	global VIEWMODE_VERTICAL
#enum	global VIEWMODE_HORIZONTAL
#enum	global VIEWMODE_QUAD
#enum	global VIEWMODE_INVISIBLE

// （EmpMode）
#enum	global EMP_INVALIDITY = 0				 	//!< 無効
#enum	global EMP_WORD								//!< 単語を強調
#enum	global EMP_LINE_AFTER						//!< それ以降～行末
#enum	global EMP_LINE_BETWEEN						//!< 二つの文字の間（同一行に限る・二つの文字列を指定）
#enum	global EMP_MULTI_BETWEEN					//!< 二つの文字の間（複数行にわたる・二つの文字列を指定）

// （ColorPos）
#enum	global CP_TEXT = 0							//!< 通常の文字
#enum	global CP_BACKGROUND						//!< 背景色
#enum	global CP_CRLF								//!< 改行マーク
#enum	global CP_HALFSPACE							//!< 半角スペース
#enum	global CP_NORMALSPACE						//!< 全角スペース
#enum	global CP_TAB								//!< タブ文字
#enum	global CP_EOF								//!< [EOF]
#enum	global CP_UNDERLINE							//!< キャレットの下のアンダーライン
#enum	global CP_LINENUMBORDER						//!< 行番号とテキストエディタの境界線
#enum	global CP_LINENUMTEXT						//!< 行番号テキスト
#enum	global CP_CARETLINE							//!< 行番号領域におけるキャレット位置強調
#enum	global CP_RULERBACKGROUND					//!< ルーラーの背景色
#enum	global CP_RULERTEXT							//!< ルーラーのテキスト
#enum	global CP_RULERLINE							//!< ルーラー上の線
#enum	global CP_CARETPOS							//!< ルーラーにおけるキャレット位置強調
#enum	global CP_URLTEXT							//!< URL文字
#enum	global CP_URLUNDERLINE						//!< URL下に表示されるアンダーライン
#enum	global CP_MAILTEXT							//!< メールアドレス文字
#enum	global CP_MAILUNDERLINE						//!< メール下に表示される文字列
#enum	global CP_HIGHLIGHTTEXT						//!< ハイライトテキスト
#enum	global CP_HIGHLIGHTBACKGROUND				//!< ハイライト背景色

// nLimeMode引数：保存するときの改行コード（LineMode）
#enum	global LM_AUTOMATIC = 0						//!< 自動
#enum	global LM_CRLF								//!< CrLfコード
#enum	global LM_CR								//!< Crコード
#enum	global LM_LF								//!< Lfコード
#enum	global LM_ERROR								//!< エラー識別用：戻り値専用です

// キャラクタセット（CharSetMode）
#enum	global CSM_AUTOMATIC = 0					//!< 自動モード(通常はこれを使用する)
#enum	global CSM_PLATFORM							//!< プラットフォーム依存
/*日本語*/
#enum	global CSM_SHIFT_JIS_2004					//!< ShiftJISのJIS X 0213:2004拡張(WindowsVista標準)
#enum	global CSM_EUC_JIS_2004						//!< EUC-JPのJIS X 0213:2004拡張
#enum	global CSM_ISO_2022_JP_2004					//!< JISコードのJIS X 0213:2004拡張
/*ISO 8859*/
#enum	global CSM_ISO8859_1						//!< 西ヨーロッパ(Latin1)
#enum	global CSM_ISO8859_2						//!< 東ヨーロッパ(Latin2)
#enum	global CSM_ISO8859_3						//!< エスペラント語他(Latin3)
#enum	global CSM_ISO8859_4						//!< 北ヨーロッパ(Latin4)
#enum	global CSM_ISO8859_5						//!< キリル
#enum	global CSM_ISO8859_6						//!< アラビア
#enum	global CSM_ISO8859_7						//!< ギリシャ
#enum	global CSM_ISO8859_8						//!< ヘブライ
#enum	global CSM_ISO8859_9						//!< トルコ(Latin5)
#enum	global CSM_ISO8859_10						//!< 北欧(Latin6)
#enum	global CSM_ISO8859_11						//!< タイ
/*ISO8859-12は1997年に破棄されました*/
#enum	global CSM_ISO8859_13						//!< バルト諸国の言語
#enum	global CSM_ISO8859_14						//!< ケルト語
#enum	global CSM_ISO8859_15						//!< ISO 8859-1の変形版
#enum	global CSM_ISO8859_16						//!< 東南ヨーロッパ

/*Unicode*/
#enum	global CSM_UTF8								//!< BOM無しUTF8
#enum	global CSM_UTF8_BOM							//!< BOM付きUTF8
#enum	global CSM_UTF16_LE							//!< BOM無しUTF16リトルエンディアン
#enum	global CSM_UTF16_LE_BOM						//!< BOM付きUTF16リトルエンディアン
#enum	global CSM_UTF16_BE							//!< BOM無しUTF16ビッグエンディアン
#enum	global CSM_UTF16_BE_BOM						//!< BOM付きUTF16ビッグエンディアン
#enum	global CSM_UTF32_LE							//!< BOM無しUTF32リトルエンディアン
#enum	global CSM_UTF32_LE_BOM						//!< BOM付きUTF32リトルエンディアン
#enum	global CSM_UTF32_BE							//!< BOM無しUTF32ビッグエンディアン
#enum	global CSM_UTF32_BE_BOM						//!< BOM付きUTF32ビッグエンディアン
/*内部処理用(使用しないでください)*/
#enum	global CSM_ERROR							//!< エラー

// フォント（FontMode）
#enum	global FFM_ANSI_CHARSET = 0					//!< ANSI文字
#enum	global FFM_BALTIC_CHARSET					//!< バルト文字
#enum	global FFM_BIG5_CHARSET						//!< 繁体字中国語文字
#enum	global FFM_EASTEUROPE_CHARSET				//!< 東ヨーロッパ文字
#enum	global FFM_GB2312_CHARSET					//!< 簡体中国語文字
#enum	global FFM_GREEK_CHARSET					//!< ギリシャ文字
#enum	global FFM_HANGUL_CHARSET					//!< ハングル文字
#enum	global FFM_RUSSIAN_CHARSET					//!< キリル文字
#enum	global FFM_SHIFTJIS_CHARSET					//!< 日本語
#enum	global FFM_TURKISH_CHARSET					//!< トルコ語
#enum	global FFM_VIETNAMESE_CHARSET				//!< ベトナム語
#enum	global FFM_ARABIC_CHARSET					//!< アラビア語
#enum	global FFM_HEBREW_CHARSET					//!< ヘブライ語
#enum	global FFM_THAI_CHARSET						//!< タイ語
/*内部処理用(使用しないでください)*/
#enum	global FFM_NUM_FONTS						//!< フォントの数

// 行アイコン（LineIcons）
#define	global LINEICON_ATTACH			0x00000001
#define	global LINEICON_BACK			0x00000002
#define	global LINEICON_CHECKED			0x00000004
#define	global LINEICON_UNCHECKED		0x00000008
#define	global LINEICON_CANCEL			0x00000010
#define	global LINEICON_CLOCK			0x00000020
#define	global LINEICON_CONTENTS		0x00000040
#define	global LINEICON_DB_CANCEL		0x00000080
#define	global LINEICON_DB_DELETE		0x00000100
#define	global LINEICON_DB_FIRST		0x00000200
#define	global LINEICON_DB_EDIT			0x00000400
#define	global LINEICON_DB_INSERT		0x00000800
#define	global LINEICON_DB_LAST			0x00001000
#define	global LINEICON_DB_NEXT			0x00002000
#define	global LINEICON_DB_POST			0x00004000
#define	global LINEICON_DB_PREVIOUS		0x00008000
#define	global LINEICON_DB_REFRESH		0x00010000
#define	global LINEICON_DELETE			0x00020000
#define	global LINEICON_EXECUTE			0x00040000
#define	global LINEICON_FAVORITE		0x00080000
#define	global LINEICON_BLUE			0x00100000
#define	global LINEICON_GREEN			0x00200000
#define	global LINEICON_RED				0x00400000
#define	global LINEICON_FORWARD			0x00800000
#define	global LINEICON_HELP			0x01000000
#define	global LINEICON_INFORMATION		0x02000000
#define	global LINEICON_KEY				0x04000000
#define	global LINEICON_LOCK			0x08000000
#define	global LINEICON_RECORD			0x10000000
#define	global LINEICON_TICK			0x20000000
#define	global LINEICON_TIPS			0x40000000
#define	global LINEICON_WARNING			0x80000000

// 強調表示モード（EmpType）
#define	global EMPFLAG_BOLD				0x00000001	//!< 太字にする
#define	global EMPFLAG_NON_CS			0x00000002	//!< 大文字と小文字を区別しない
#define	global EMPFLAG_HEAD				0x00000004	//!< 頭にあるときのみ

// エディタマーク表示、非表示の設定（EditorMarks）
#define	global EDM_HALF_SPACE			0x00000001	//!< 半角スペースを表示するか
#define	global EDM_FULL_SPACE			0x00000002	//!< 全角スペースを表示するか
#define	global EDM_TAB					0x00000004	//!< タブマークを表示するか
#define	global EDM_LINE					0x00000008	//!< 改行マークを表示するか
#define	global EDM_EOF					0x00000010	//!< [EOF]マークを表示するか
#define	global EDM_SHOW_ALL				0xFFFFFFFF	//!< 全て表示する
#define	global EDM_SHOW_NONE			0x00000000	//!< 何も表示しない

// 検索フラグ（SearchFlags）
#define	global SEARCH_FROMCURSOR		0x00000001	//!< 現在のカーソル位置から検索する
#define	global SEARCH_BACK				0x00000002	//!< 後ろ方向に検索処理を実行する
#define	global SEARCH_REGEXP			0x00000004	//!< 正規表現を利用する
#define	global SEARCH_NOT_REFRESH		0x00000008	//!< 検索結果を再描画しない
#define	global SEARCH_BEEP_ON_404		0x00000010	//!< 見つからなかったときにビープ音をならす
#define	global SEARCH_NOT_ADJUST_VIEW	0x00000020	//!< 見つかったときにキャレット位置へスクロールバーを追随させない

// 独立レベル（IndependentFlags）
/*ASCII記号用フラグ*/
#define	global EMP_IND_PARENTHESIS		0x00000001	//!< 前後に丸括弧()があることを許可する
#define	global EMP_IND_BRACE			0x00000002	//!< 前後に中括弧{}があることを許可する
#define	global EMP_IND_ANGLE_BRACKET	0x00000004	//!< 前後に山形括弧<>があることを許可する
#define	global EMP_IND_SQUARE_BRACKET	0x00000008	//!< 前後に各括弧[]があることを許可する
#define	global EMP_IND_QUOTATION		0x00000010	//!< 前後にコーテーション'"があることを許可する
#define	global EMP_IND_UNDERBAR			0x00000020	//!< 前後にアンダーバー_があることを許可する
#define	global EMP_IND_OPERATORS		0x00000040	//!< 前後に演算子 + - * / % ^  があることを許可する
#define	global EMP_IND_OTHER_ASCII_SIGN	0x00000080	//!< 前述のものを除く全てのASCII記号 # ! $ & | \ @ ?  .
/*ASCII文字列を指定するフラグ*/
#define	global EMP_IND_NUMBER			0x00000100	//!< 前後に数字を許可する
#define	global EMP_IND_CAPITAL_ALPHABET	0x00000200	//!< 前後に大文字アルファベットを許可する
#define	global EMP_IND_SMALL_ALPHABET	0x00000400	//!< 前後に小文字アルファベットを許可する
/*空白を指定するフラグ*/
#define	global EMP_IND_SPACE			0x00001000	//!< 前後に半角スペースを許可する
#define	global EMP_IND_FULL_SPACE		0x00002000	//!< 前後に全角スペースを許可する
#define	global EMP_IND_TAB				0x00004000	//!< 前後にタブを許可する
/*そのほかの文字列*/
#define	global EMP_IND_JAPANESE			0x00010000	//!< 日本語
#define	global EMP_IND_KOREAN			0x00020000	//!< 韓国語
#define	global EMP_IND_EASTUROPE		0x00040000	//!< 東ヨーロッパ
#define	global EMP_IND_OTHERS			0x80000000	//!< 上記以外
/*省略形(主にこれらを使用すると指定が楽です)*/
#define	global EMP_IND_ASCII_SIGN		0x000000FF	//!< 全てのASCII記号列を許可する
#define	global EMP_IND_ASCII_LETTER 	0x00000F00	//!< 全てのASCII文字を許可する(数字とアルファベット)
#define	global EMP_IND_BLANKS			0x0000F000	//!< 全ての空白文字列を許可する
#define	global EMP_IND_OTHER_CHARSETS	0xFFFF0000	//!< 全てのキャラクタセットを許可する
#define	global EMP_IND_ALLOW_ALL		0xFFFFFFFF	//!< 何でもOK

// 折り返しモード（LapelMode）
#define	global LAPELFLAG_ALL			0xFFFFFFFF	//!< 以下のフラグ全てを選択する
#define	global LAPELFLAG_NONE			0x00000000	//!< 何も有効にしない
#define	global LAPELFLAG_WORDBREAK		0x00000001	//!< 英文ワードラップ
#define	global LAPELFLAG_JPN_PERIOD		0x00000002	//!< 日本語の句読点に関する禁則処理
#define	global LAPELFLAG_JPN_QUOTATION	0x00000004	//!< 日本語のカギ括弧に関する禁則処理

// 数値取得（SetMetricsCode）
#enum	global SM_LAPEL_COLUMN = 0					//!< 折り返し位置(桁数)
#enum	global SM_LAPEL_MODE						//!< 折り返しモード
#enum	global SM_MARK_VISIBLE						//!< マークの表示状態
#enum	global SM_LINENUM_WIDTH						//!< 左端の行番号の幅(ピクセル、-1でデフォルト)
#enum	global SM_RULER_HEIGHT						//!< 上のルーラーの高さ(ピクセル、-1でデフォルト)
#enum	global SM_UNDERLINE_VISIBLE

// エラー（ErrCode）
#define	global FOOTY2ERR_NONE			0			//!< 関数が成功した
#define	global FOOTY2ERR_ARGUMENT		-1			//!< 引数おかしい
#define	global FOOTY2ERR_NOID			-2			//!< IDが見つからない
#define	global FOOTY2ERR_MEMORY			-3			//!< メモリー不足
#define	global FOOTY2ERR_NOUNDO			-4			//!< アンドゥ情報がこれ以前に見つからない
#define	global FOOTY2ERR_NOTSELECTED	-5			//!< 選択されていない
#define	global FOOTY2ERR_UNKNOWN		-6			//!< 不明なエラー
#define	global FOOTY2ERR_NOTYET			-7			//!< 未実装(ごめんなさい)
#define	global FOOTY2ERR_404			-8			//!< ファイルが見つからない、検索文字列が見つからない
#define	global FOOTY2ERR_NOACTIVE		-9			//!< アクティブなビューは存在しません
#define	global FOOTY2ERR_ENCODER		-10			//!< 文字コードのエンコーダが見つかりません(ファイルのエンコード形式が不正です、バイナリとか)

#endif	/*_FOOTY2_DLL_H_*/
#endif	/*__hsp30__*/