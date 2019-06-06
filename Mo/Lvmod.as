// Listview module

#ifndef __LISTVIEW_MODULE__
#define __LISTVIEW_MODULE__

#define global WC_LISTVIEW	"SysListView32"

// ���X�g�r���[�ɑ��郁�b�Z�[�W ------------------------------------------------
#define global LVM_GETBKCOLOR		0x1000		// �w�i�F���擾
#define global LVM_SETBKCOLOR		0x1001		// �w�i�F�̐ݒ�
#define global LVM_SETIMAGELIST		0x1003		// �C���[�W���X�g�����蓖�Ă�
#define global LVM_GETITEMCOUNT		0x1004		// �A�C�e���̐����擾
#define global LVM_GETITEM			0x1005		// �A�C�e���̑������擾
#define global LVM_SETITEM			0x1006		// �A�C�e���E�T�u�A�C�e���̑�����ݒ�E�ύX
#define global LVM_INSERTITEM		0x1007		// �V�����A�C�e����}��
#define global LVM_DELETEITEM		0x1008		// �A�C�e�����폜
#define global LVM_DELETEALLITEMS	0x1009		// ���ׂẴA�C�e�����폜
#define global LVM_GETNEXTITEM		0x100C		// �w�肵�����������A�C�e�����擾
#define global LVM_FINDITEM			0x100D		// �A�C�e��������
#define global LVM_INSERTCOLUMN		0x101B		// �V�����J���� (��) ��}��
#define global LVM_DELETECOLUMN		0x101C		// �J�������폜
#define global LVM_GETHEADER		0x101F		// �w�b�_�R���g���[�����擾
#define global LVM_GETTEXTCOLOR		0x1023		// �e�L�X�g�̕����F���擾
#define global LVM_GETTEXTBKCOLOR	0x1025		// �e�L�X�g�̔w�i�F���擾
#define global LVM_SETTEXTCOLOR		0x1024		// �e�L�X�g�̕����F��ݒ�
#define global LVM_SETTEXTBKCOLOR	0x1026		// �e�L�X�g�̔w�i�F��ݒ�

#define global LVM_INSERTGROUP		0x1091		// �O���[�v��}��
#define global LVM_ENABLEGROUPVIEW	0x109D		// �O���[�v�\���ɂ���

// ���X�g�r���[�̃X�^�C��
#define global LVS_ICON				0x0000		// �u�傫���A�C�R���\���v
#define global LVS_REPORT			0x0001		// �u�ڍו\���v
#define global LVS_SMALLICON		0x0002		// �u�������A�C�R���\���v
#define global LVS_LIST				0x0003		// �u�ꗗ�\���v
#define global LVS_SINGLESEL		0x0004		// ������I���ł��Ȃ��悤�ɂ��� (�f�t�H���g�ł͕����I���\)
#define global LVS_SHOWSELALWAYS	0x0008		// �t�H�[�J�X�������ĂȂ��Ă��A�I����Ԃ��\�������悤�ɂ���
#define global LVS_SORTASCENDING	0x0010		// �e�L�X�g�����Ƃɏ����\�[�g����
#define global LVS_SORTDESCENDING	0x0020		// �e�L�X�g�����Ƃɍ~���\�[�g����
#define global LVS_SHAREIMAGELISTS	0x0040		// ListView ���j�������ۂɁAImageList ������ɔj�����Ȃ��悤�ɂ���
#define global LVS_NOLABELWRAP		0x0080		// LVS_ICON �̂Ƃ��ɁA�A�C�e���̃e�L�X�g��1�s�ŕ\�������悤�ɂ��܂��B�i�f�t�H���g�ł͕����s�ŕ\������邱�Ƃ�����܂��B�j
#define global LVS_AUTOARRANGE		0x0100		// �A�C�R���\���̂Ƃ��A�A�C�R�������񂵂���Ԃ��ێ������� ( LVS_ICON or LVS_SMALLICON )
#define global LVS_EDITLABELS		0x0200		// �e�L�X�g��ҏW�\�ɂ��� (�e�E�B���h�E�� LVN_ENDLABELEDIT ����������K�v������)
#define global LVS_OWNERDATA		0x1000		// version 4.70 �ȍ~ : ���z���X�g�r���[�ł��邱�Ƃ�����
#define global LVS_NOSCROLL			0x2000		// �X�N���[�����֎~���� (��N���C�A���g�̈悪�����Ă͂Ȃ�Ȃ�)
#define global LVS_ALIGNTOP			0x0000		// �A�C�R���\���̎��A�A�C�e�������X�g�r���[�̏�[�ɕ��ׂ���悤�ɂ��� (�f�t�H���g)
#define global LVS_ALIGNLEFT		0x0800		// �A�C�R���\���̎��A�A�C�e�������X�g�r���[�̍����ɕ��ׂ���悤�ɂ���
#define global LVS_OWNERDRAWFIXED	0x0400		// �ڍו\�� �̎��A�I�[�i�[�`��ł��邱�Ƃ������B�A�C�e���̂ݕ`��ł���B
#define global LVS_NOCOLUMNHEADER	0x4000		// �ڍו\�� �̎��A�J�����w�b�_��\�����Ȃ�
#define global LVS_NOSORTHEADER		0x8000		// �J�����w�b�_�̃{�^���@�\���g�p���Ȃ� (�J�����w�b�_���N���b�N�������ɂȂɂ����������Ȃ��Ȃ�A�w�肷�ׂ�)

// ���X�g�r���[�̊g���X�^�C��
// �������Ŏ��������X�g�r���[�̊g���X�^�C���� LVM_SETEXTENDEDLISTVIEWSTYLE
// ����� LVM_GETEXTENDEDLISTVIEWSTYLE �ɂ���Đݒ�E�擾������K�v������܂� (SetWindowLong ����ʖ�)
// version 4.70 �ȍ~�̂ݎg�p�\
#define global LVM_SETEXTENDEDLISTVIEWSTYLE	0x1036	// sendmsg hlist, LVM_SETEXTENDEDLISTVIEWSTYLE, 0 �K�p����g�����X�g�X�^�C��
#define global LVM_GETEXTENDEDLISTVIEWSTYLE	0x1037	// sendmsg hlist, LVM_GETEXTENDEDLISTVIEWSTYLE, 0, 0

#define global LVS_EX_GRIDLINES			0x0001		// �ڍו\�� �̎��A�r����\��
#define global LVS_EX_SUBITEMIMAGES		0x0002		// �ڍו\�� �̎��A�C���[�W���T�u�A�C�e���ɕ\�������悤�ɂ���
#define global LVS_EX_CHECKBOXES		0x0004		// �`�F�b�N�{�b�N�X�t��
#define global LVS_EX_TRACKSELECT		0x0008		// MouseCursor ���A�C�e����ň�莞�Ԓ�~�������A�A�C�e����I������
#define global LVS_EX_HEADERDRAGDROP	0x0010		// �ڍו\�� �̎��A�w�b�_�� �c���c ���ăJ�����̏��������ւ��\�ɂ���
#define global LVS_EX_FULLROWSELECT		0x0020		// �ڍו\�� �̎��A�A�C�e���I�����ɗ�S�̂������\������
#define global LVS_EX_ONECLICKACTIVATE	0x0040		// �A�C�e���� Click�������A�e�E�B���h�E�� LVN_ITEMACTIVATE �𑗂�B�A�C�e�����z�b�g�ɂȂ�ƁA�����\������B
#define global LVS_EX_TWOCLICKACTIVATE	0x0080		// �A�C�e����WClick�������A�e�E�B���h�E�� LVN_ITEMACTIVATE �𑗂�B�A�C�e�����z�b�g�ɂȂ�ƁA�����\������B
#define global LVS_EX_FLATSB			0x0100		// �t���b�g�X�N���[���o�[���g�p����
#define global LVS_EX_REGIONAL			0x0200		// LVS_ICON �̎��A�A�C�e���̃A�C�R���ƃe�L�X�g�݂̂��܂� Region ���쐬�� WindowRegion�ɐݒ肷��B
#define global LVS_EX_INFOTIP			0x0400		// LVS_ICON �̎��ATooltip ���\�������ꍇ�A�e�E�B���h�E�� LVN_GETINFOTIP �𑗂�B
#define global LVS_EX_UNDERLINEHOT		0x0800		// LVS_EX_ONECLICKACTIVATE or LVS_EX_TWOCLICKACTIVATE ���ݒ肳��Ă���ꍇ�ɁA�z�b�g�ȃA�C�e���̃e�L�X�g�ɉ���������
#define global LVS_EX_UNDERLINECOLD		0x1000		// LVS_EX_ONECLICKACTIVATE or LVS_EX_TWOCLICKACTIVATE ���ݒ肳��Ă���ꍇ�ɁA���ׂẴA�C�e���̃e�L�X�g�ɉ���������
#define global LVS_EX_MULTIWORKAREAS	0x2000		// LVS_AUTOARRANGE �̎��A1�ȏ��Ɨ̈悪��`�����܂Ŏ������񂵂Ȃ�

// LVCOLUMN.mask
#define global LVCF_FMT					0x0001		// fmt
#define global LVCF_WIDTH				0x0002		// cx
#define global LVCF_TEXT				0x0004		// pszText
#define global LVCF_SUBITEM				0x0008		// iSubItem
#define global LVCF_IMAGE				0x0010		// iImage	( version 4.70 �ȍ~ )
#define global LVCF_ORDER				0x0020		// iOrder	( version 4.70 �ȍ~ )

// LVCOLUMN.fmt
#define global LVCFMT_LEFT				0x0000		// ����������l�ɂ���
#define global LVCFMT_RIGHT				0x0001		// �E�l��
#define global LVCFMT_CENTER			0x0002		// ��������
#define global LVCFMT_IMAGE				0x0800		// �C���[�W					( version 4.70 �ȍ~ )
#define global LVCFMT_BITMAP_ON_RIGHT	0x1000		// �r�b�g�}�b�v���E���ɕ\��	( version 4.70 �ȍ~ )
#define global LVCFMT_COL_HAS_IMAGES	0x8000		// �w�b�_�̓C���[�W���܂�	( version 4.70 �ȍ~ )

// LVITEM.mask
#define global LVIF_TEXT				0x0001		// pszText
#define global LVIF_IMAGE				0x0002		// iImage
#define global LVIF_PARAM				0x0004		// lParam
#define global LVIF_STATE				0x0008		// state
#define global LVIF_INDENT				0x0010		// iIndent
#define global LVIF_GROUPID				0x0100		// iGroupID
#define global LVIF_COLUMNS				0x0200		// cColumns
#define global LVIF_NORECOMPUTE			0x0800		// LVM_GETITEM ���󂯎������A��������擾����̂� LVN_GETDISPINFO �𔭐������Ȃ��B����ɁApszText �����o�� -1 (LPSTR_TEXTCALLBACK) ���i�[����B
#define global LVIF_DI_SETITEM			0x1000		// �V�X�e���́A�v�����ꂽ�A�C�e�������i�[���Ă����A�ォ��������߂Ȃ��B����� LVN_GETDISPINFO �ł̂ݎg�p�\�B

// LVITEM.state
#define global LVIS_FOCUSED			0x0001	// �A�C�e�����t�H�[�J�X������ (���͂��_���ň͂܂��)�B�t�H�[�J�X�����A�C�e���͂���̂�
#define global LVIS_SELECTED		0x0002	// �A�C�e�����I������Ă���B�\�����@�� syscolor �Ɉˑ��B�����I�������蓾��
#define global LVIS_CUT				0x0004	// �A�C�e���� Cut & Paste �̑ΏۂƂ��ă}�[�N����Ă���
#define global LVIS_DROPHILITED		0x0008	// �c���c �̑ΏۂƂ��ăn�C���C�g�\������Ă���
#define global LVIS_ACTIVATING		0x0020	// (���g�p)

// �w�b�_�R���g���[���ɑ��郁�b�Z�[�W
#define global HDM_GETITEMCOUNT		0x00001200		// �A�C�e���̐����擾
#define global HDM_GETITEM			0x00001203		// 
#define global HDM_SETITEM			0x00001204		// 

#define global HDF_JUSTIFYMASK		0x00000003
#define global HDF_SORTUP			0x00000400
#define global HDF_SORTDOWN			0x00000200
#define global HDF_STRING			0x00004000

#define global HDI_FORMAT			0x00000004

//##################################################################################################

#ifdef  __USE_LVINT__
#define __IF_LPARAM_USE_ON__
#endif

#module Lvmod minfLv, mExStyle, mnItem, mnColumn, mbCustom, mbGroup, mcText, mcBack, LPRM

//------------------------------------------------
// �}�N��
//------------------------------------------------
#define ArrayIns(%1,%2=0,%3=4)    memcpy %1,%1,(length(%1) - (%2) -1)*(%3),((%2)+1)*(%3),(%2)*(%3)
#define ArrayDel(%1,%2,%3=0,%4=4) memcpy %1,%1,(length(%2) - (%3) -1)*(%4),(%3)*(%4),((%3)+1)*(%4):memset %1,0,%4,((%3)*(%4))+((length(%2)-(%3)-1)*(%4))

#define ctype RGB(%1,%2,%3) ((%1) | (%2) << 8 | (%3) << 16)
#define ctype numrg(%1,%2,%3) (((%2) <= (%1)) && ((%1) <= (%3)))

#define mv modvar Lvmod@

//------------------------------------------------
// ���W���[��������
//------------------------------------------------
#deffunc local _initialize@Lvmod
	dim  lvcolumn, 8		// LVCOLUMN �\����
	dim  lvitem  , 15		// LVITEM   �\����
	dim  lvgroup , 10		// LVGROUP  �\����
	dim  hditem  , 11		// HDITEM   �\����
	sdim pszText, 512		// pszText
	return
	
//##############################################################################
//                ���������p�֐�
//##############################################################################
// �O������̎g�p�֎~�I�I

//------------------------------------------------
// int�^�ꎟ���z����g��
//------------------------------------------------
#define RedimInt __RedimInt@Lvmod
#deffunc local __RedimInt@Lvmod array p1, int p2, local temp
	if ( length(p1) >= p2 ) { return }	// �����Ȃ��ꍇ�͖���
	dim    temp, length(p1)
	memcpy temp, p1, length(p1) * 4		// �R�s�[
	dim    p1, p2
	memcpy p1, temp, length(temp) * 4	// �߂�
	return
	
//------------------------------------------------
// �}����̏���
//------------------------------------------------
#modfunc Inserted@Lvmod int p2
	if ( p2 < 0 ) { return }
	
 #ifdef __IF_LV_LPARAM_USE_ON__
		RedimInt   LPRM, mnItem + 1 : ArrayIns   LPRM, p2
 #endif
	if ( mbCustom ) {
		RedimInt mcText, mnItem + 1 : ArrayIns mcText, p2 : mcText(p2) = 0
		RedimInt mcBack, mnItem + 1 : ArrayIns mcBack, p2 : mcBack(p2) = 0xFFFFFF
	}
	mnItem ++
	return p2
	
//------------------------------------------------
// �폜��̏���
//------------------------------------------------
#modfunc Deleted@Lvmod int p2
	if ( p2 < 0 ) { return }
 #ifdef __IF_LV_LPARAM_USE_ON__
	ArrayDel       LPRM,   LPRM, p2		// �폜���ăV�t�g������
 #endif
	if ( mbCustom ) {
		ArrayDel mcText, mcText, p2
		ArrayDel mcBack, mcBack, p2
	}
	mnItem --
	return p2
	
//##########################################################
//        �A�C�e���̕������ݒ�E�擾
//##########################################################
//------------------------------------------------
// �A�C�e��������̐ݒ�
// modvar, "new str", iItem, iSubitem
//------------------------------------------------
#modfunc LvSetStr str p2, int p3, int p4
	pszText = p2
	lvitem  = 0x01, p3, p4, 0, 0, varptr(pszText)
	sendmsg minfLv,    0x1006, 0, varptr(lvitem)	// LVM_SETITEM
	return (stat)
	
//------------------------------------------------
// �A�C�e��������̎擾
//------------------------------------------------
#define global ctype LvGetStr(%1,%2=0,%3=0,%4=520) _LvGetStr(%1,%2,%3,%4)
#defcfunc _LvGetStr mv, int p2, int p3, int p4
	sdim  pszText, p4 + 1								// �擾�o�b�t�@
	lvitem = 0x01, p2, p3, 0, 0, varptr(pszText), p4
	sendmsg minfLv,   0x1005, 0, varptr(lvitem)			// LVM_GETITEM
	if ( stat ) {
		return pszText	// ������
	}
	return ""			// ���s��
	
//------------------------------------------------
// �J����������̐ݒ�
// modvar, "new str", index
//------------------------------------------------
#modfunc LvSetColumnStr str p2, int p3
	pszText = p2
	hditem  = 0x02, 0, varptr(pszText)
	sendmsg minfLv, 0x101F, 0, 0				// LVM_GETHEADER
	sendmsg   stat, 0x1204, p3, varptr(hditem)	// HDM_SETITEM
	return    stat
	
//##########################################################
//        ���X�g�r���[�𐶐�
//##########################################################
//------------------------------------------------
// �R���X�g���N�^
//------------------------------------------------
#define global CreateListview(%1,%2,%3,%4=1) newmod %1,Lvmod@,%2,%3,%4
#modinit int p2, int p3, int p4
	winobj "SysListView32", "", 0, 0x50000000 | p4, p2, p3
	minfLv = objinfo(stat, 2), stat
	
	// �����o�ϐ����쐬
	dim mExStyle		// �g���X�^�C��
	dim mnColumn		// �J�����̐�
	dim mnItem  		// �J���� 0 �̃A�C�e���̐�
	dim mbCustom		// �J�X�^�����[�h���̃t���O
	dim mbGroup 		// �O���[�v�r���[���̃t���O
	dim mcText, 2		// �����F
	dim mcBack, 2		// �w�i�F
	
	return minfLv(1)	// oID ��Ԃ�
	
//##########################################################
//        �J�����E�A�C�e���̒ǉ�
//##########################################################
//------------------------------------------------
// �J�����̒ǉ�
// @prmlist: m,"", index, cx, iSubItem
//------------------------------------------------
#define global LvInsertColumn(%1,%2,%3=-1,%4,%5) _LvInsertColumn %1,%2,%3,%4,%5
#modfunc _LvInsertColumn str p2, int p3, int p4, int p5
	pszText  = p2
	lvcolumn = 0x0F, 0x0000, p4, varptr(pszText), 0, p5
	sendmsg  minfLv, 0x101B, p3, varptr(lvcolumn)		// LVM_INSERTCOLUMN (�J������ǉ�)
	mnColumn ++
	return (stat)
	
//------------------------------------------------
// ������A�C�e����}��
// @prmlist: m, "", index
//------------------------------------------------
#define global LvInsertItem(%1,%2,%3=-1) _LvInsertItem %1,%2,%3
#modfunc _LvInsertItem str p2, int p3
	if ( p3 < 0 ) { n = mnItem } else { n = p3 }
	
	pszText = p2
	lvitem  = 0x01, n, 0, 0, 0, varptr(pszText)
	sendmsg minfLv, 0x1007, 0,  varptr(lvitem)		// LVM_INSERTITEM (�A�C�e����}��)
	Inserted thismod, stat
	return (stat)
	
//------------------------------------------------
// �C���[�W�A�C�e����}��
//------------------------------------------------
#define global LvInsertImgItem(%1,%2,%3=-1) _LvInsertImgItem %1,%2,%3
#modfunc _LvInsertImgItem int p2, int p3
	if ( p3 < 0 ) { n = mnItem } else { n = p3 }
	
	lvitem  = 0x02, n, 0, 0, 0, 0, p2
	sendmsg minfLv, 0x1007, 0, varptr(lvitem)		// LVM_INSERTITEM
	Inserted thismod, stat
	return (stat)
	
//------------------------------------------------
// �T�u�A�C�e����ݒ�
// @prmlist: m, "", index, iSubItem
//------------------------------------------------
#modfunc LvSetSub str p2, int p3, int p4
	pszText = p2
	lvitem  = 0x01, p3, p4, 0, 0, varptr(pszText)
	sendmsg minfLv, 0x1006, 0,    varptr(lvitem)	// LVM_SETITEM
	return (stat)
	
//##########################################################
//        �A�C�e���̍폜
//##########################################################
//------------------------------------------------
// �A�C�e�����폜
//------------------------------------------------
#modfunc LvDelete int p2
	sendmsg minfLv, 0x1008, p2, 0	// LVM_DELETEITEM
	if ( stat == 0 ) {				// �폜�Ɏ��s����
		return 1
	}
	Deleted thismod
	return 0
	
//------------------------------------------------
// �A�C�e�������ׂč폜
//------------------------------------------------
#modfunc LvDeleteAll
	sendmsg minfLv, 0x1009, 0, 0	// LVM_DELETEALLITEMS
	if ( mbCustom ) {
		dim mcText, 2		// �����F
		dim mcBack, 2		// �w�i�F
	}
	dim LPRM
	return
	
//##########################################################
//        �A�C�e���̎擾
//##########################################################
//------------------------------------------------
// �A�C�e���̒T��
//------------------------------------------------
#defcfunc LvGetTarget mv, int p2, int p3
	sendmsg minfLv, 0x100C, p2, p3		// LVM_GETNEXTITEM
	return stat
	
#define global ctype LvGetFocus(%1,%2=-1)    LvGetTarget(%1,%2,LVNI_FOCUSED)
#define global ctype LvGetSelected(%1,%2=-1) LvGetTarget(%1,%2,LVNI_SELECTED)
#define global ctype LvGetCut(%1,%2=-1)      LvGetTarget(%1,%2,LVNI_CUT)
#define global ctype LvGetDropped(%1,%2=-1)  LvGetTarget(%1,%2,LVNI_DROPHILIGHT)

#define global ctype LvGetNext(%1,%2=-1)  LvGetTarget(%1,%2,LVNI_ALL)
#define global ctype LvGetAbove(%1,%2=-1) LvGetTarget(%1,%2,LVNI_ABOVE)
#define global ctype LvGetBelow(%1,%2=-1) LvGetTarget(%1,%2,LVNI_BELOW)
#define global ctype LvGetLeft(%1,%2=-1)  LvGetTarget(%1,%2,LVNI_TOLEFT)
#define global ctype LvGetRight(%1,%2=-1) LvGetTarget(%1,%2,LVNI_TORIGHT)

//##########################################################
//        �A�C�e���̐ݒ�
//##########################################################
#modfunc LvSetExStyle int p2
	mExStyle |= p2
	sendmsg minfLv, 0x1036, 0, mExStyle
	return
	
//##########################################################
//        �A�C�e���̏�Ԏ擾�֐�
//##########################################################
#defcfunc LvSelected mv, int p2
	sendmsg minfLv, 0x100C, p2, 0x0002			// LVM_GETNEXTITEM
	return stat
	
//##########################################################
//        �C���[�W���X�g�֌W
//##########################################################
#modfunc LvSetImgList int hIml
	sendmsg minfLv, 0x1001, hIml, 0				// LVM_SETIMAGELIST
	return
	
#modfunc LvSetImage int p2, int p3
	lvitem  = 0x02, p3, 0, 0, 0, 0, p2
	sendmsg minfLv, 0x1006, 0, varptr(lvitem)	// LVM_SETITEM
	return
	
//##########################################################
//        �O���[�v���֌W
//##########################################################
//------------------------------------------------
// GroupView �ɂ���
//------------------------------------------------
#modfunc LvEnbleGroupView int bEnable
	// wparam ���^�Ȃ�A�O���[�v�r���[
	mbGroup = bEnable				// �L�����Ă���
	sendmsg minfLv, 0x109D, 1, 0	// LVM_ENABLEGROUPVIEW
	return stat						// 0 = �ݒ�ς�, ���� = ����, ���� = ���s
	
//------------------------------------------------
// Group �ǉ�
//------------------------------------------------
#define global LvInsertGroup(%1,%2,%3,%4=-1) _LvInsertGroup %1,%2,%3,%4
#modfunc _LvInsertGroup str sGroupName, int gID
	cnvstow pszText, sGroupName						// Unicode �����񂶂�Ȃ��ƃ_���炵��
	lvgroup = 40, 0x11, varptr(pszText), 319		// �ݒ�
	sendmsg minfLv, 0x1091, gID, varptr(lvgroup)	// LVM_INSERTGROUP
	return stat
	
//##########################################################
//        ���̑�
//##########################################################
//------------------------------------------------
// �w�b�_�Ɂ�����\������
//------------------------------------------------
#modfunc LvSetSortMark int iCol, int dir
	sendmsg minfLv, 0x101F, 0, 0			// LVM_GETHEADER ( �J�����w�b�_�̃n���h�����擾 )
	hHDR = stat								// �w�b�_�̃n���h��
	sendmsg hHDR, 0x1200, 0, 0				// HDM_GETITEMCOUNT ( �A�C�e�������擾 )
	cntHDItem = stat						// �A�C�e����
	
	hditem(0) = 0x04		// mask (HDI_FORMAT)
	
    // �O��̃}�[�N������
	repeat cntHDItem
		sendmsg hHDR, 0x1203, cnt, varptr(hditem)	// HDM_GETITEM
		hditem(5) = hditem(5) & HDF_JUSTIFYMASK | HDF_STRING & (HDF_SORTDOWN ^ -1) & ((HDF_SORTUP ^ -1))	// fmt
		sendmsg hHDR, 0x1204, cnt, varptr(hditem)	// HDM_SETITEM
	loop
	
	// �}�[�N��\��
	sendmsg hHDR, 0x1203, iCol, varptr(hditem)		// HDM_GETITEM
	switch dir
	case 1
		hditem(5) = hditem(5) & HDF_JUSTIFYMASK | HDF_STRING | HDF_SORTUP		// fmt
		sendmsg hHDR, 0x1204, iCol, varptr(hditem)	// HDM_SETITEM
		swbreak
	case -1
		hditem(5) = hditem(5) & HDF_JUSTIFYMASK | HDF_STRING | HDF_SORTDOWN		// fmt
		sendmsg hHDR, 0x1204, iCol, varptr(hditem)	// HDM_SETITEM
		swbreak
	swend
	return
	
//##########################################################
//        �J�X�^���h���[�E���[�h
//##########################################################
//------------------------------------------------
// �J�X�^���h���[�E���[�h�ɐݒ肷��
//------------------------------------------------
#modfunc LvUseCustomMode
	LvSetExStyle thismod, 0x0020	// LVS_EX_FULLROWSELECT (��s�I�����[�h)
	mbCustom = 1
	return
	
//------------------------------------------------
// �J�X�^���h���[�E���[�h���H
//------------------------------------------------
#defcfunc LvIsCustom mv, int p2
	return mbCustom
	
//------------------------------------------------
// ���ڂ̕����F��ݒ�
//------------------------------------------------
#modfunc LvCtTextColor int iItem, int cref
	mcText(iItem) = cref
	return
	
//------------------------------------------------
// ���ڂ̔w�i�F��ݒ�
//------------------------------------------------
#modfunc LvCtBackColor int iItem, int cref
	mcBack(iItem) = cref
	return
	
//------------------------------------------------
// ���ڂ̕����F���擾
//------------------------------------------------
#defcfunc LvTextColor mv, int iItem
	return mcText( iItem )
	
//------------------------------------------------
// ���ڂ̔w�i�F���擾
//------------------------------------------------
#defcfunc LvBackColor mv, int iItem
	return mcBack( iItem )
	
// �g�p���@�̓T���v���� *Notify �Q��
	
//##########################################################
//        �֘Aint���얽��
//##########################################################
//------------------------------------------------
// �ݒ�֐�
//------------------------------------------------
#modfunc LvIntSet int p2, int p3
 #ifdef __IF_LV_LPARAM_USE_ON__
	LPRM( p2 ) = p3
 #endif
	return
	
//------------------------------------------------
// �擾�֐�
//------------------------------------------------
#defcfunc LvInt mv, int p2
 #ifdef __IF_LV_LPARAM_USE_ON__
	return LPRM( p2 )
 #else
	return 0	// �ꉞ 0 ��Ԃ�
 #endif

//##########################################################
//        �����Q�Ɗ֐�
//##########################################################
#defcfunc LvHandle mv
	return minfLv
	
#defcfunc LvColumnNum mv
	return mnColumn
	
#defcfunc LvItemNum mv
	return mnItem
	
#global
_initialize@Lvmod

//##############################################################################
//                �T���v���E�v���O����
//##############################################################################
#if 0
#undef RGB
#define ctype RGB(%1,%2,%3) ((%1) | (%2) << 8 | (%3) << 16)

	// 0x0001 : �ڍו\��
	// 0x0200 : �e�L�X�g�ҏW�\
	// 0x8000 : �J�����w�b�_�̃{�^���@�\���~
	CreateListview mLv, ginfo(12), ginfo(13), 0x0001 | 0x0200 ;| 0x8000
	hLv = objinfo(stat, 2)
	
	LvInsertColumn mLv, "���O", 0, 100, 0
	LvInsertColumn mLv, "�ǂ�", 1, 120, 1
	LvInsertColumn mLv, "���l", 2, 100, 2
	
	LvInsertItem   mLv, "�݌��ƕ�"
	LvSetSub       mLv, "������̂Ȃ�Ђ�", 0, 1
	LvCtTextColor  mLv, 0, RGB(255,   0,   0)
	LvCtBackColor  mLv, 0, RGB(  0, 255, 255)
	
	LvInsertItem   mLv, "�m���Տ�"
	LvSetSub       mLv, "�������傤�ւ񂶂傤", 1, 1
	LvCtTextColor  mLv, 1, RGB(  0,   0, 128)
	LvCtBackColor  mLv, 1, RGB(255, 255, 128)
	
	LvInsertItem   mLv, "���@�t"
	LvSetSub       mLv, "������ق���", 2, 1
	LvCtTextColor  mLv, 2, RGB(  0, 255,   0)
	LvCtBackColor  mLv, 2, RGB(255,   0, 255)
	
	LvInsertItem   mLv, "�唺����"
	LvSetSub       mLv, "�����Ƃ��̂���ʂ�", 3, 1
	LvCtTextColor  mLv, 3, RGB(128,   0, 255)
	LvCtBackColor  mLv, 3, RGB(128, 255,   0)
	
	LvInsertItem   mLv, "�����N�G"
	LvSetSub       mLv, "�ӂ��̂₷�Ђ�", 4, 1
	LvCtTextColor  mLv, 4, RGB(255, 128,   0)
	LvCtBackColor  mLv, 4, RGB(  0, 128, 255)
	
	LvInsertItem   mLv, "���쏬��"
	LvSetSub       mLv, "���̂̂��܂�", 5, 1
	LvCtTextColor  mLv, 5, RGB(255, 255, 255)
	LvCtBackColor  mLv, 5, RGB(  0,   0,   0)
	
	LvUseCustomMode mLv				// �J�X�^���h���[�E���[�h�ɂ���(�����s��)
	oncmd gosub *OnNotify, 0x004E	// ����Ɏw��
	
	// 0x0001 : �O���b�h(�\����)��\��
	// 0x0004 : �`�F�b�N�{�b�N�X
	// 0x0008 : �}�E�X����莞�Ԏ~�܂�ΑI��
	// 0x0010 : �J�����̂c���c�ɂ��ړ�
	// 0x0020 : ��s���ׂĂ�I��\��
	LvSetExStyle mLv, 0x0001 | 0x0004 | 0x0008 | 0x0010 | 0x0020
	
	// �J�����}�[�N��ݒ�
	LvSetSortMark mLv, 0, 1
	sortdir = 1
	sortcol = 0
	
	stop
	
// ����(��)�̓R�s�y�ł����ł�
*OnNotify
	dupptr nmhdr, lparam, 12
	
	if ( nmhdr(0) == hLv ) {		// hLv �� ListView �̃n���h��
		
		// NM_CUSTOMDRAW (����̓J�X�^���h���[�̏���)
		if ( nmhdr(2) == -12 ) {
			
			if ( LvIsCustom(mLv) ) {
				dupptr NMLVCUSTOMDRAW, lparam, 60		// NMLVCUSTOMDRAW �\����
				
				if ( NMLVCUSTOMDRAW(3) == 0x0001 ) {	// CDDS_REPAINT (�`��T�C�N���̑O)
					return 0x0020						// CDRF_NOTIFYITEMDRAW (�A�C�e���̕`�揈����e�ɒʒm)
				}
				
				if ( NMLVCUSTOMDRAW(3) == 0x10001 ) {	// CDDS_ITEMREPAINT (�`��O)
					NMLVCUSTOMDRAW(12) = LvTextColor(mLv, NMLVCUSTOMDRAW(9))	// �����F
					NMLVCUSTOMDRAW(13) = LvBackColor(mLv, NMLVCUSTOMDRAW(9))	// �w�i�F
					return 0x0002
				}
			}
			
		// �J�������N���b�N���ꂽ( �����}�[�N�̕`�揈�� )
		} else : if ( nmhdr(2) == 0xFFFFFF94 ) {		// LVN_COLUMNCLICK
			dupptr NM_LISTVIEW, lparam, 12 + 32				// NMLISTVIEW �\����
			iCol = NM_LISTVIEW(4)							// �N���b�N���ꂽ�J�����̃C���f�b�N�X
			if ( iCol == sortcol ) {						// �}�[�N���J�����Ȃ�
				sortdir *= -1									// �t�����ɂ���
			} else {										// �������
				sortdir = 1										// �������Ɍ�������
			}
			// �A�C�R����ݒ�( �\�[�g����� )
			sortcol = iCol
			LvSetSortMark mLv, sortcol, sortdir
		}
	}
	return
	
#endif

#endif
