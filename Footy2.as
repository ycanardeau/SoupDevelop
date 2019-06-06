// =============================================
// Footy2.as ver. 1.0 2008/01/05
//     for HSP3.1 & Footy2.dll2.013
//     by eller
//     �i�����炳��̃X�N���v�g���Q�l�Ƃ����Ă��������܂����j
// =============================================
// Footy�e�L�X�g�G�f�B�^�R���g���[��2 ver. 2.013
//     (C)2004-2007 ShinjiWatanabe
//     http://www.hpp.be/
// =============================================
// �y���ӎ����z
//     Footy2�{�̂̃o�O�Ǝv������̂�
//     ���LURL�֕񍐂��Ă��������B
//     http://www.hpp.be:8080/trac/Footy
//
//     HSP��Footy2���g�����@�Ȃǂ̎����
//     Footy2�̍�҂ł���Ȃׂ��񂳂�ɂ�
//     ���Ȃ��ł��������B
// =============================================

#ifdef	__hsp30__
#ifndef	_FOOTY2_DLL_H_
#define	global _FOOTY2_DLL_H_
#uselib	"Footy2.dll"

// ************
// �O��DLL�Ăяo�����ߓo�^
// ************
// �o�[�W�����擾�֐��i�w���v��3�́j
#func global GetFooty2Ver "GetFooty2Ver"
#func global GetFooty2BetaVer "GetFooty2BetaVer"

// �E�B���h�E����֐��i�w���v��4�́j
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

// �ҏW�R�}���h�i�w���v��5�́j
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

// �t�@�C������i�w���v��6�́j
#func global Footy2CreateNew "Footy2CreateNew" int
#func global Footy2TextFromFileA "Footy2TextFromFileA" int, sptr, int
#func global Footy2TextFromFileW "Footy2TextFromFileW" int, wptr, int
#func global Footy2SaveToFileA "Footy2SaveToFileA" int, sptr, int, int
#func global Footy2SaveToFileW "Footy2SaveToFileW" int, wptr, int, int
#func global Footy2GetCharSet "Footy2GetCharSet" int
#func global Footy2GetLineCode "Footy2GetLineCode" int

// �����񏈗��i�w���v��7�́j
#func global Footy2SetSelTextA "Footy2SetSelTextA" int, sptr
#func global Footy2SetSelTextW "Footy2SetSelTextW" int, wptr
#func global Footy2SetTextA "Footy2SetTextA" int, sptr
#func global Footy2SetTextW "Footy2SetTextW" int, wptr
#func global Footy2GetCaretPosition "Footy2GetCaretPosition" int, int, int	// ��2�`��3������varptr()���g���ă|�C���^��n������
#func global _Footy2SetCaretPosition "Footy2SetCaretPosition" int, int, int, int
#define	global Footy2SetCaretPosition( %1, %2, %3, %4 = 1 ) _Footy2SetCaretPosition %1, %2, %3, %4
#func global Footy2GetSel "Footy2GetSel" int, int, int, int, int	// ��2�`��4������varptr()���g���ă|�C���^��n������
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

// �\���ݒ�i�w���v��8�́j
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
#func global Footy2GetLineIcon "Footy2GetLineIcon" int, int, int	// ��3������varptr()���g���ă|�C���^��n������
#func global _Footy2SetMetrics "Footy2SetMetrics" int, int, int, int
#define	global Footy2SetMetrics( %1, %2, %3, %4 = 1 ) _Footy2SetMetrics %1, %2, %3, %4
#func global Footy2GetMetrics "Footy2GetMetrics" int, int, int	// ��3������varptr()���g���ă|�C���^��n������
#func global Footy2GetVisibleColumns "Footy2GetVisibleColumns" int, int
#func global Footy2GetVisibleLines "Footy2GetVisibleLines" int, int
#func global _Footy2SetLepal "Footy2SetLepal" int, int, int, int
#define	global Footy2SetLepal( %1, %2, %3, %4 = 1 ) _Footy2SetLepal %1, %2, %3, %4
#func global _Footy2SetColor "Footy2SetColor" int, int, int, int
#define	global Footy2SetColor( %1, %2, %3, %4 = 1 ) _Footy2SetColor %1, %2, %3, %4

// �C�x���g�̊Ď��i�w���v��9�́j
#func global Footy2SetFuncFocus "Footy2SetFuncFocus" int, int, int, int
#func global Footy2SetFuncMoveCaret "Footy2SetFuncMoveCaret" int, int, int, int
#func global Footy2SetFuncTextModified "Footy2SetFuncTextModified" int, int, int
#func global Footy2SetFuncInsertModeChanged "Footy2SetFuncInsertModeChanged" int, int, int

#ifdef _UNICODE
// "�`W"�ŏI��閽�߁E�֐���"W"�Ȃ��ŌĂяo����悤�ɒ�`
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
// "�`A"�ŏI��閽�߁E�֐���"A"�Ȃ��ŌĂяo����悤�ɒ�`
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
// �}�N���̐錾
// ************
#define	global ctype PERMIT_LEVEL(%1)		(1 << (%1))


// ************
// �萔�̐錾
// ************
// URL�^�C�v�iUrlType�j
#enum	global URLTYPE_HTTP = 0						//!< http
#enum	global URLTYPE_HTTPS						//!< https
#enum	global URLTYPE_FTP							//!< ftp
#enum	global URLTYPE_MAIL							//!< ���[���A�h���X

// �e�L�X�g���ҏW���ꂽ�����iTextModifiedCause�j
#enum	global MODIFIED_CAUSE_CHAR = 0				//!< ���������͂��ꂽ(IME�I�t)
#enum	global MODIFIED_CAUSE_IME					//!< ���������͂��ꂽ(IME�I��)
#enum	global MODIFIED_CAUSE_DELETE				//!< Delete�L�[���������ꂽ
#enum	global MODIFIED_CAUSE_BACKSPACE				//!< BackSpace���������ꂽ
#enum	global MODIFIED_CAUSE_ENTER					//!< Enter�L�[���������ꂽ
#enum	global MODIFIED_CAUSE_UNDO					//!< ���ɖ߂����������s���ꂽ
#enum	global MODIFIED_CAUSE_REDO					//!< ��蒼�����������s���ꂽ
#enum	global MODIFIED_CAUSE_CUT					//!< �؂��菈�������s���ꂽ
#enum	global MODIFIED_CAUSE_PASTE					//!< �\��t�����������s���ꂽ
#enum	global MODIFIED_CAUSE_INDENT				//!< �C���f���g���ꂽ
#enum	global MODIFIED_CAUSE_UNINDENT				//!< �t�C���f���g���ꂽ
#enum	global MODIFIED_CAUSE_TAB					//!< �^�u�L�[��������āA�^�u�������}�����ꂽ

// �r���[��ԁiViewMode�j
#enum	global VIEWMODE_NORMAL = 0
#enum	global VIEWMODE_VERTICAL
#enum	global VIEWMODE_HORIZONTAL
#enum	global VIEWMODE_QUAD
#enum	global VIEWMODE_INVISIBLE

// �iEmpMode�j
#enum	global EMP_INVALIDITY = 0				 	//!< ����
#enum	global EMP_WORD								//!< �P�������
#enum	global EMP_LINE_AFTER						//!< ����ȍ~�`�s��
#enum	global EMP_LINE_BETWEEN						//!< ��̕����̊ԁi����s�Ɍ���E��̕�������w��j
#enum	global EMP_MULTI_BETWEEN					//!< ��̕����̊ԁi�����s�ɂ킽��E��̕�������w��j

// �iColorPos�j
#enum	global CP_TEXT = 0							//!< �ʏ�̕���
#enum	global CP_BACKGROUND						//!< �w�i�F
#enum	global CP_CRLF								//!< ���s�}�[�N
#enum	global CP_HALFSPACE							//!< ���p�X�y�[�X
#enum	global CP_NORMALSPACE						//!< �S�p�X�y�[�X
#enum	global CP_TAB								//!< �^�u����
#enum	global CP_EOF								//!< [EOF]
#enum	global CP_UNDERLINE							//!< �L�����b�g�̉��̃A���_�[���C��
#enum	global CP_LINENUMBORDER						//!< �s�ԍ��ƃe�L�X�g�G�f�B�^�̋��E��
#enum	global CP_LINENUMTEXT						//!< �s�ԍ��e�L�X�g
#enum	global CP_CARETLINE							//!< �s�ԍ��̈�ɂ�����L�����b�g�ʒu����
#enum	global CP_RULERBACKGROUND					//!< ���[���[�̔w�i�F
#enum	global CP_RULERTEXT							//!< ���[���[�̃e�L�X�g
#enum	global CP_RULERLINE							//!< ���[���[��̐�
#enum	global CP_CARETPOS							//!< ���[���[�ɂ�����L�����b�g�ʒu����
#enum	global CP_URLTEXT							//!< URL����
#enum	global CP_URLUNDERLINE						//!< URL���ɕ\�������A���_�[���C��
#enum	global CP_MAILTEXT							//!< ���[���A�h���X����
#enum	global CP_MAILUNDERLINE						//!< ���[�����ɕ\������镶����
#enum	global CP_HIGHLIGHTTEXT						//!< �n�C���C�g�e�L�X�g
#enum	global CP_HIGHLIGHTBACKGROUND				//!< �n�C���C�g�w�i�F

// nLimeMode�����F�ۑ�����Ƃ��̉��s�R�[�h�iLineMode�j
#enum	global LM_AUTOMATIC = 0						//!< ����
#enum	global LM_CRLF								//!< CrLf�R�[�h
#enum	global LM_CR								//!< Cr�R�[�h
#enum	global LM_LF								//!< Lf�R�[�h
#enum	global LM_ERROR								//!< �G���[���ʗp�F�߂�l��p�ł�

// �L�����N�^�Z�b�g�iCharSetMode�j
#enum	global CSM_AUTOMATIC = 0					//!< �������[�h(�ʏ�͂�����g�p����)
#enum	global CSM_PLATFORM							//!< �v���b�g�t�H�[���ˑ�
/*���{��*/
#enum	global CSM_SHIFT_JIS_2004					//!< ShiftJIS��JIS X 0213:2004�g��(WindowsVista�W��)
#enum	global CSM_EUC_JIS_2004						//!< EUC-JP��JIS X 0213:2004�g��
#enum	global CSM_ISO_2022_JP_2004					//!< JIS�R�[�h��JIS X 0213:2004�g��
/*ISO 8859*/
#enum	global CSM_ISO8859_1						//!< �����[���b�p(Latin1)
#enum	global CSM_ISO8859_2						//!< �����[���b�p(Latin2)
#enum	global CSM_ISO8859_3						//!< �G�X�y�����g�ꑼ(Latin3)
#enum	global CSM_ISO8859_4						//!< �k���[���b�p(Latin4)
#enum	global CSM_ISO8859_5						//!< �L����
#enum	global CSM_ISO8859_6						//!< �A���r�A
#enum	global CSM_ISO8859_7						//!< �M���V��
#enum	global CSM_ISO8859_8						//!< �w�u���C
#enum	global CSM_ISO8859_9						//!< �g���R(Latin5)
#enum	global CSM_ISO8859_10						//!< �k��(Latin6)
#enum	global CSM_ISO8859_11						//!< �^�C
/*ISO8859-12��1997�N�ɔj������܂���*/
#enum	global CSM_ISO8859_13						//!< �o���g�����̌���
#enum	global CSM_ISO8859_14						//!< �P���g��
#enum	global CSM_ISO8859_15						//!< ISO 8859-1�̕ό`��
#enum	global CSM_ISO8859_16						//!< ���새�[���b�p

/*Unicode*/
#enum	global CSM_UTF8								//!< BOM����UTF8
#enum	global CSM_UTF8_BOM							//!< BOM�t��UTF8
#enum	global CSM_UTF16_LE							//!< BOM����UTF16���g���G���f�B�A��
#enum	global CSM_UTF16_LE_BOM						//!< BOM�t��UTF16���g���G���f�B�A��
#enum	global CSM_UTF16_BE							//!< BOM����UTF16�r�b�O�G���f�B�A��
#enum	global CSM_UTF16_BE_BOM						//!< BOM�t��UTF16�r�b�O�G���f�B�A��
#enum	global CSM_UTF32_LE							//!< BOM����UTF32���g���G���f�B�A��
#enum	global CSM_UTF32_LE_BOM						//!< BOM�t��UTF32���g���G���f�B�A��
#enum	global CSM_UTF32_BE							//!< BOM����UTF32�r�b�O�G���f�B�A��
#enum	global CSM_UTF32_BE_BOM						//!< BOM�t��UTF32�r�b�O�G���f�B�A��
/*���������p(�g�p���Ȃ��ł�������)*/
#enum	global CSM_ERROR							//!< �G���[

// �t�H���g�iFontMode�j
#enum	global FFM_ANSI_CHARSET = 0					//!< ANSI����
#enum	global FFM_BALTIC_CHARSET					//!< �o���g����
#enum	global FFM_BIG5_CHARSET						//!< �ɑ̎������ꕶ��
#enum	global FFM_EASTEUROPE_CHARSET				//!< �����[���b�p����
#enum	global FFM_GB2312_CHARSET					//!< �ȑ̒����ꕶ��
#enum	global FFM_GREEK_CHARSET					//!< �M���V������
#enum	global FFM_HANGUL_CHARSET					//!< �n���O������
#enum	global FFM_RUSSIAN_CHARSET					//!< �L��������
#enum	global FFM_SHIFTJIS_CHARSET					//!< ���{��
#enum	global FFM_TURKISH_CHARSET					//!< �g���R��
#enum	global FFM_VIETNAMESE_CHARSET				//!< �x�g�i����
#enum	global FFM_ARABIC_CHARSET					//!< �A���r�A��
#enum	global FFM_HEBREW_CHARSET					//!< �w�u���C��
#enum	global FFM_THAI_CHARSET						//!< �^�C��
/*���������p(�g�p���Ȃ��ł�������)*/
#enum	global FFM_NUM_FONTS						//!< �t�H���g�̐�

// �s�A�C�R���iLineIcons�j
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

// �����\�����[�h�iEmpType�j
#define	global EMPFLAG_BOLD				0x00000001	//!< �����ɂ���
#define	global EMPFLAG_NON_CS			0x00000002	//!< �啶���Ə���������ʂ��Ȃ�
#define	global EMPFLAG_HEAD				0x00000004	//!< ���ɂ���Ƃ��̂�

// �G�f�B�^�}�[�N�\���A��\���̐ݒ�iEditorMarks�j
#define	global EDM_HALF_SPACE			0x00000001	//!< ���p�X�y�[�X��\�����邩
#define	global EDM_FULL_SPACE			0x00000002	//!< �S�p�X�y�[�X��\�����邩
#define	global EDM_TAB					0x00000004	//!< �^�u�}�[�N��\�����邩
#define	global EDM_LINE					0x00000008	//!< ���s�}�[�N��\�����邩
#define	global EDM_EOF					0x00000010	//!< [EOF]�}�[�N��\�����邩
#define	global EDM_SHOW_ALL				0xFFFFFFFF	//!< �S�ĕ\������
#define	global EDM_SHOW_NONE			0x00000000	//!< �����\�����Ȃ�

// �����t���O�iSearchFlags�j
#define	global SEARCH_FROMCURSOR		0x00000001	//!< ���݂̃J�[�\���ʒu���猟������
#define	global SEARCH_BACK				0x00000002	//!< �������Ɍ������������s����
#define	global SEARCH_REGEXP			0x00000004	//!< ���K�\���𗘗p����
#define	global SEARCH_NOT_REFRESH		0x00000008	//!< �������ʂ��ĕ`�悵�Ȃ�
#define	global SEARCH_BEEP_ON_404		0x00000010	//!< ������Ȃ������Ƃ��Ƀr�[�v�����Ȃ炷
#define	global SEARCH_NOT_ADJUST_VIEW	0x00000020	//!< ���������Ƃ��ɃL�����b�g�ʒu�փX�N���[���o�[��ǐ������Ȃ�

// �Ɨ����x���iIndependentFlags�j
/*ASCII�L���p�t���O*/
#define	global EMP_IND_PARENTHESIS		0x00000001	//!< �O��Ɋۊ���()�����邱�Ƃ�������
#define	global EMP_IND_BRACE			0x00000002	//!< �O��ɒ�����{}�����邱�Ƃ�������
#define	global EMP_IND_ANGLE_BRACKET	0x00000004	//!< �O��ɎR�`����<>�����邱�Ƃ�������
#define	global EMP_IND_SQUARE_BRACKET	0x00000008	//!< �O��Ɋe����[]�����邱�Ƃ�������
#define	global EMP_IND_QUOTATION		0x00000010	//!< �O��ɃR�[�e�[�V����'"�����邱�Ƃ�������
#define	global EMP_IND_UNDERBAR			0x00000020	//!< �O��ɃA���_�[�o�[_�����邱�Ƃ�������
#define	global EMP_IND_OPERATORS		0x00000040	//!< �O��ɉ��Z�q + - * / % ^  �����邱�Ƃ�������
#define	global EMP_IND_OTHER_ASCII_SIGN	0x00000080	//!< �O�q�̂��̂������S�Ă�ASCII�L�� # ! $ & | \ @ ?  .
/*ASCII��������w�肷��t���O*/
#define	global EMP_IND_NUMBER			0x00000100	//!< �O��ɐ�����������
#define	global EMP_IND_CAPITAL_ALPHABET	0x00000200	//!< �O��ɑ啶���A���t�@�x�b�g��������
#define	global EMP_IND_SMALL_ALPHABET	0x00000400	//!< �O��ɏ������A���t�@�x�b�g��������
/*�󔒂��w�肷��t���O*/
#define	global EMP_IND_SPACE			0x00001000	//!< �O��ɔ��p�X�y�[�X��������
#define	global EMP_IND_FULL_SPACE		0x00002000	//!< �O��ɑS�p�X�y�[�X��������
#define	global EMP_IND_TAB				0x00004000	//!< �O��Ƀ^�u��������
/*���̂ق��̕�����*/
#define	global EMP_IND_JAPANESE			0x00010000	//!< ���{��
#define	global EMP_IND_KOREAN			0x00020000	//!< �؍���
#define	global EMP_IND_EASTUROPE		0x00040000	//!< �����[���b�p
#define	global EMP_IND_OTHERS			0x80000000	//!< ��L�ȊO
/*�ȗ��`(��ɂ������g�p����Ǝw�肪�y�ł�)*/
#define	global EMP_IND_ASCII_SIGN		0x000000FF	//!< �S�Ă�ASCII�L�����������
#define	global EMP_IND_ASCII_LETTER 	0x00000F00	//!< �S�Ă�ASCII������������(�����ƃA���t�@�x�b�g)
#define	global EMP_IND_BLANKS			0x0000F000	//!< �S�Ă̋󔒕������������
#define	global EMP_IND_OTHER_CHARSETS	0xFFFF0000	//!< �S�ẴL�����N�^�Z�b�g��������
#define	global EMP_IND_ALLOW_ALL		0xFFFFFFFF	//!< ���ł�OK

// �܂�Ԃ����[�h�iLapelMode�j
#define	global LAPELFLAG_ALL			0xFFFFFFFF	//!< �ȉ��̃t���O�S�Ă�I������
#define	global LAPELFLAG_NONE			0x00000000	//!< �����L���ɂ��Ȃ�
#define	global LAPELFLAG_WORDBREAK		0x00000001	//!< �p�����[�h���b�v
#define	global LAPELFLAG_JPN_PERIOD		0x00000002	//!< ���{��̋�Ǔ_�Ɋւ���֑�����
#define	global LAPELFLAG_JPN_QUOTATION	0x00000004	//!< ���{��̃J�M���ʂɊւ���֑�����

// ���l�擾�iSetMetricsCode�j
#enum	global SM_LAPEL_COLUMN = 0					//!< �܂�Ԃ��ʒu(����)
#enum	global SM_LAPEL_MODE						//!< �܂�Ԃ����[�h
#enum	global SM_MARK_VISIBLE						//!< �}�[�N�̕\�����
#enum	global SM_LINENUM_WIDTH						//!< ���[�̍s�ԍ��̕�(�s�N�Z���A-1�Ńf�t�H���g)
#enum	global SM_RULER_HEIGHT						//!< ��̃��[���[�̍���(�s�N�Z���A-1�Ńf�t�H���g)
#enum	global SM_UNDERLINE_VISIBLE

// �G���[�iErrCode�j
#define	global FOOTY2ERR_NONE			0			//!< �֐�����������
#define	global FOOTY2ERR_ARGUMENT		-1			//!< ������������
#define	global FOOTY2ERR_NOID			-2			//!< ID��������Ȃ�
#define	global FOOTY2ERR_MEMORY			-3			//!< �������[�s��
#define	global FOOTY2ERR_NOUNDO			-4			//!< �A���h�D��񂪂���ȑO�Ɍ�����Ȃ�
#define	global FOOTY2ERR_NOTSELECTED	-5			//!< �I������Ă��Ȃ�
#define	global FOOTY2ERR_UNKNOWN		-6			//!< �s���ȃG���[
#define	global FOOTY2ERR_NOTYET			-7			//!< ������(���߂�Ȃ���)
#define	global FOOTY2ERR_404			-8			//!< �t�@�C����������Ȃ��A���������񂪌�����Ȃ�
#define	global FOOTY2ERR_NOACTIVE		-9			//!< �A�N�e�B�u�ȃr���[�͑��݂��܂���
#define	global FOOTY2ERR_ENCODER		-10			//!< �����R�[�h�̃G���R�[�_��������܂���(�t�@�C���̃G���R�[�h�`�����s���ł��A�o�C�i���Ƃ�)

#endif	/*_FOOTY2_DLL_H_*/
#endif	/*__hsp30__*/