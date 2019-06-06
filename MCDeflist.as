// definition list

#ifndef __MODULECLASS_DEFINITION_LIST_AS__
#define __MODULECLASS_DEFINITION_LIST_AS__

#include "Mo/strutil.as"
#include "Mo/HPM_split.as"
#include "Mo/pvalptr.as"

#module MCDeflist mScript, mCount, mFileName, mFilePath, mIdent, mLn, mType, mScope, mInclude, mCntInclude

#include "Mo/HPM_header.as"

//##############################################################################
//        �萔�E�}�N��
//##############################################################################
#define true  1
#define false 0

//------------------------------------------------
// DEFTYPE
//------------------------------------------------
#const global DEFTYPE_LABEL		0x0001		// ���x��
#const global DEFTYPE_MACRO		0x0002		// �}�N��
#const global DEFTYPE_CONST		0x0004		// �萔
#const global DEFTYPE_FUNC		0x0008		// ���߁E�֐�
#const global DEFTYPE_DLL		0x0010		// DLL����
#const global DEFTYPE_CMD		0x0020		// HPI�R�}���h
#const global DEFTYPE_COM		0x0040		// COM����
#const global DEFTYPE_IFACE		0x0080		// �C���^�[�t�F�[�X

#const global DEFTYPE_CTYPE		0x0100		// CTYPE
#const global DEFTYPE_MODULE	0x0200		// ���W���[�������o

//------------------------------------------------
// ����ȋ�Ԗ�
//------------------------------------------------
#define global AREA_GLOBAL "global"
#define global AREA_ALL    "*"

//##############################################################################
//                �R���X�g���N�^�E�f�X�g���N�^
//##############################################################################
//------------------------------------------------
// �R���X�g���N�^
//------------------------------------------------
#define global deflist_new(%1,%2) newmod %1, MCDeflist@, %2
#modinit str path
	// �����o�ϐ���������
	sdim mIdent,, 5
	dim  mLn,     5
	dim  mType,   5
	sdim mScope,, 5
	sdim mFileName
	sdim mFilePath, MAX_PATH
	sdim mInclude,  MAX_PATH
	dim  mCntInclude
	
	mFilePath = path
	mFileName = getpath(mFilePath, 8)
	
	// �X�N���v�g��ǂݍ���
	notesel  mScript
	noteload mFilePath
	noteunsel
	
	// ��`�����X�g�A�b�v
	deflist_listup thismod
	
	return getaptr(thismod)
	
//------------------------------------------------
// �f�X�g���N�^
//------------------------------------------------
#define global deflist_delete(%1) delmod %1
	
//##############################################################################
//                �����o�֐�
//##############################################################################
//------------------------------------------------
// �ꊇ���Ċi�[����
// 
// @ p2 �𕉐��ɂ���ƒǉ��ɂȂ� -> deflist_add
//------------------------------------------------
#define global deflist_set(%1,%2,%3,%4,%5,%6) _deflist_set %1,%2,%3,%4,%5,%6
#define global deflist_add(%1,%2,%3,%4,%5)    _deflist_set %1,-1,%2,%3,%4,%5
#modfunc _deflist_set int p2, str ident, int linenum, int deftype, str scope,  local iItem
	if ( p2 < 0 ) { iItem = mCount : mCount ++ } else { iItem = p2 }
	mIdent(iItem) = ident
	mLn   (iItem) = linenum
	mType (iItem) = deftype
	mScope(iItem) = scope
	return iItem
	
//------------------------------------------------
// �ꊇ���Ď擾����
//------------------------------------------------
#modfunc deflist_get int p2, var ident, var linenum, var deftype, var scope
	ident   = mIdent(p2)
	linenum = mLn   (p2)
	deftype = mType (p2)
	scope   = mScope(p2)
	return
	
//------------------------------------------------
// �e�����o���Ƃ� getter
//------------------------------------------------
#modfunc deflist_getScript var script
	script = mScript
	return
	
#modcfunc deflist_getCount
	return mCount
	
#modcfunc deflist_getFilePath
	return mFilePath
	
#modcfunc deflist_getFileName
	return mFileName
	
#modcfunc deflist_getIdent int p2
	return mIdent(p2)
	
#modcfunc deflist_getLn int p2
	return mLn(p2)
	
#modcfunc deflist_getDefType int p2
	return mType(p2)
	
#modcfunc deflist_getScope int p2
	return mScope(p2)
	
#modcfunc deflist_getCntInclude
	return mCntInclude
	
#modcfunc deflist_getInclude int p2
	return mInclude(p2)
	
//------------------------------------------------
// include �t�@�C����z��ɂ��ĕԂ�
//------------------------------------------------
#modfunc deflist_getIncludeArray array p2
	sdim p2,, mCntInclude
	repeat    mCntInclude
		p2(cnt) = mInclude(cnt)
	loop
	return
	
//##############################################################################
//                ��`�����X�g�A�b�v����
//##############################################################################
//------------------------------------------------
// �͈͖����쐬����
// @private
// @static
//------------------------------------------------
#deffunc MakeScope@MCDeflist var scope, str defscope, int deftype, int bGlobal, int bLocal
	if ( bGlobal ) { scope = AREA_ALL : return }
	
	scope = defscope
	
	if ( bLocal ) { scope += " [local]" }
	return
	
//------------------------------------------------
// ��`�����X�g�A�b�v����
//------------------------------------------------
#define nowTkType tktypelist(idx)
#define nowTkStr  tkstrlist (idx)

#modfunc deflist_listup  local tktypelist, local tkstrlist, local befTkType, local idx, local cntToken, local sIdent, local areaScope, local scope, local nowline, local bGlobal, local bLocal, local deftype, local uniqueCount, local fSplit
	fSplit  = HPM_SPLIT_FLAG_NO_BLANK
	fSplit |= HPM_SPLIT_FLAG_NO_RESERVED
	
	hpm_split tktypelist, tkstrlist, mScript, fSplit
	
	cntToken = stat
	if ( cntToken <= 0 ) {
		return 0
	}
	
	sdim sIdent
	sdim scope
	sdim areaScope
	
	dim listIndex, 5	// �����C���f�b�N�X�̃��X�g( �������̂��߂Ɏg�� )
	
	nowline     = 0
	uniqueCount = 0
	areaScope   = AREA_GLOBAL
	befTkType   = TKTYPE_END
	
	repeat cntToken
		gosub *LNextToken
		if ( idx >= cntToken ) {
			break
		}
	loop
	
	return mCount
	
*LProcToken
	switch ( nowTkType )
		
		//--------------------
		// ���̏I�[
		//--------------------
		case TKTYPE_END
			c = peek(nowTkStr)
			if ( IsNewLine( c ) ) {
				nowline ++
			}
			swbreak
			
		//--------------------
		// ���s���
		//--------------------
		case TKTYPE_ESC_LINEFEED
			nowline ++
			swbreak
			
		//--------------------
		// �R�����g
		//--------------------
		case TKTYPE_COMMENT
			// �����s�R�����g�̏ꍇ�A�s���𐔂���
			if ( wpeek(nowTkStr) == 0x2A2F ) {		// /*
				gosub *LCountLines
			}
			swbreak
			
		//--------------------
		// ������
		//--------------------
		case TKTYPE_STRING
			// �����s������萔�̏ꍇ�A�s���𐔂���
			if ( wpeek(nowTkStr) == 0x227B ) {		// {"
				gosub *LCountLines
			}
			swbreak
			
		//--------------------
		// ���x��
		//--------------------
		case TKTYPE_LABEL
			// �s���̏ꍇ�̂�
			if ( befTkType == TKTYPE_END ) {
				sIdent = nowTkStr
				
				gosub *LDecideModuleName
				
				// ���X�g�ɒǉ�
				deftype = DEFTYPE_LABEL
				gosub *LAddDefList
			}
			swbreak
			
		//--------------------
		// �v���v���Z�b�T����
		//--------------------
		case TKTYPE_PREPROC
			deftype  = 0
			bGlobal  = true
			bLocal   = false
			
			ppident  = CutPreprocIdent( nowTkStr )		// ���ʎq���������ɂ���
			
			switch ( ppident )
				
				// ���W���[����Ԃɓ˓�
				case "module"
					gosub *LNextToken
					
					// #module "modname" �̌`��
					if ( nowTkType == TKTYPE_STRING ) {
						nowTkStr = CutStrInner(nowTkStr)
						
					// #module modname �̌`��
					} else : if ( nowTkType == TKTYPE_NAME ) {
						
					// �������W���[��
					} else {
						// ���j�[�N�ȋ�Ԗ���^����
						nowTkStr = strf("m%02d [unique]", uniqueCount)
						uniqueCount ++
					}
					
					areaScope = nowTkStr
					swbreak
					
				// ���W���[����Ԃ���E�o
				case "global"
					areaScope = AREA_GLOBAL
					swbreak
					
				case "include"
				case "addition"
					gosub *LNextToken
					
					if ( nowTkType == TKTYPE_STRING ) {
						nowTkStr = CutStrInner( nowTkStr )
						
						mInclude(mCntInclude) = nowTkStr
						mCntInclude ++
						
;						logmes "#include "+ nowTkStr
					} else {
						logmes "[Warning] in mod_deflist line "+ nowline +"\nBad #include Syntax:\n\t#include "+ nowTkStr +"\n\tTKTYPE = "+ nowTkType
					}
					swbreak
					
				case "modfunc"  : deftype  = DEFTYPE_MODULE
				case "deffunc"  : deftype |= DEFTYPE_FUNC                    : goto *LAddDefinition
				case "modcfunc" : deftype  = DEFTYPE_MODULE
				case "defcfunc" : deftype |= DEFTYPE_FUNC   | DEFTYPE_CTYPE  : goto *LAddDefinition
				case "define"   : deftype  = DEFTYPE_MACRO : bGlobal = false : goto *LAddDefinition
				case "const"
				case "enum"     : deftype  = DEFTYPE_CONST : bGlobal = false : goto *LAddDefinition
				case "cfunc"    : deftype  = DEFTYPE_CTYPE
				case "func"     : deftype |= DEFTYPE_DLL   : bGlobal = false : goto *LAddDefinition
				case "cmd"      : deftype  = DEFTYPE_CMD   : bGlobal = true  : goto *LAddDefinition
				case "comfunc"  : deftype  = DEFTYPE_COM   : bGlobal = false : goto *LAddDefinition
				case "usecom"   : deftype  = DEFTYPE_IFACE : bGlobal = false : goto *LAddDefinition
			:*LAddDefinition
					gosub *LNextToken
					
					switch ( nowTkStr )
						case "global" : bGlobal  = true                  : goto *LAddDefinition
						case "ctype"  : deftype |= DEFTYPE_CTYPE         : goto *LAddDefinition
						case "local"  : bGlobal  = false : bLocal = true : goto *LAddDefinition
						case "double" : goto *LAddDefinition
						
						// ��`����鎯�ʎq
						default:
							sIdent = nowTkStr
							swbreak
					swend
					
					// �X�R�[�v������
					gosub *LDecideModuleName
					if ( scope != areaScope ) {		// ident@scope �̏ꍇ
						bGlobal = false
					}
					
					// �͈͂��쐬
					MakeScope scope, areaScope, deftype, bGlobal, bLocal
					
					// ���X�g�ɒǉ�
					gosub *LAddDefList
					swbreak
			swend
			swbreak
	swend
	return
	
*LAddDefList
	deflist_add thismod, sIdent, nowline, deftype, scope
	return
	
*LNextToken
	befTkType = nowTkType
	
	idx ++
	if ( idx >= cntToken ) {
		nowTkType = TKTYPE_ERROR
		nowTkStr  = ""
		
	}
	
	gosub *LProcToken
	
	return
	
;*LBackToken
;	idx --
;	if ( idx <= 0 ) {
;		idx       = 0
;		befTkType = TKTYPE_END
;	} else {
;		befTkType = tktypelist(idx - 1)
;	}
;	return
	
*LCountLines
	notesel nowTkStr
	nowline += notemax - 1		// �s��
	noteunsel
	return
	
//----------------------------
// ���W���[����Ԗ������肷��
//----------------------------
*LDecideModuleName
	if ( idx == cntToken ) {
		goto *LDecideModuleName_areaScope
	}
	
	if ( tktypelist(idx + 1) == TKTYPE_SCOPE ) {
		
		gosub *LNextToken
		
		if ( nowTkStr == "@" ) {
			scope = AREA_GLOBAL
		} else {
			scope = nowTkStr
		}
		return
		
	}
*LDecideModuleName_areaScope
	scope = areaScope
	return
	
//------------------------------------------------
// ��`�^�C�v���當����𐶐�����
// @static
//------------------------------------------------
#defcfunc MakeDefTypeString int deftype,  local stype, local bCType
	sdim stype, 320
	bCType = ( deftype & DEFTYPE_CTYPE ) != false
	
	if ( deftype & DEFTYPE_LABEL ) { stype = "���x��"   }
	if ( deftype & DEFTYPE_MACRO ) { stype = "�}�N��"   }
	if ( deftype & DEFTYPE_CONST ) { stype = "�萔"     }
	if ( deftype & DEFTYPE_CMD   ) { stype = "�R�}���h" }
	if ( deftype & DEFTYPE_COM   ) { stype = "����(COM)" }
	if ( deftype & DEFTYPE_IFACE ) { stype = "interface" }
	
	if ( deftype & DEFTYPE_DLL ) {
		if ( bCType ) { stype = "�֐�(Dll)" } else { stype = "����(Dll)" }
		
	} else : if ( deftype & DEFTYPE_FUNC  ) {
		if ( bCType ) { stype = "�֐�" } else { stype = "����" }
		
	} else {
		if ( bCType ) { stype += " �b" }
	}
	
	if ( deftype & DEFTYPE_MODULE ) { stype += " �l" }
	return stype
	
#global

#endif
