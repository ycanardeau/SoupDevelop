// HSP parse module - Sub

#ifndef __HSP_PARSE_MODULE_SUB_AS__
#define __HSP_PARSE_MODULE_SUB_AS__

#include "strutil.as"

//##############################################################################
//                �T�u�E���W���[��
//##############################################################################
#module hpm_sub

#include "HPM_header.as"		// �w�b�_�t�@�C����ǂݍ���

//------------------------------------------------
// �������֐�
//------------------------------------------------
#deffunc hpm_sub_initialize@hpm_sub
	keylist_all       = ","+ KEYWORDS_ALL
	keylist_statement = ","+ KEYWORDS_STATEMENT
	keylist_function  = ","+ KEYWORDS_FUNCTION
	keylist_sysvar    = ","+ KEYWORDS_SYSVAR
	keylist_preproc   = ","+ KEYWORDS_PREPROC
	keylist_macro     = ","+ KEYWORDS_MACRO
	keylist_modname   = ","+ KEYWORDS_MODNAME
	keylist_ppword    = ","+ KEYWORDS_PPWORD
	return
	
//------------------------------------------------
// ���̓��x�����H
// 
// @ ���� :=
//   �@ * ����n�܂�A
//   �@���̎����u���̏I�[ or ',' or ')'�v�̂ǂꂩ
//------------------------------------------------
#defcfunc IsLabel var p1, int p2, int p_befTT, int bPreLine,  local c, local c2, local stmp, local i
	
	// �Œ���̃`�F�b�N
	if ( peek(p1, p2    ) != '*' ) { return false }		// ���͂⃉�x���ł͂Ȃ�
	if ( peek(p1, p2 + 1) == '@' ) { return true  }		// ���[�J�����x��
	if ( peek(p1, p2 + 1) == '%' && bPreLine ) {
		c2 = peek(p1, p2 + 2)
		switch ( c2 )
			// ����W�J�}�N��
			case 'n' : case 'i' : case 'p' : case 'o'
				swbreak
			default
				// �܂��� �}�N������
				if ( IsDigit(c2) && c2 != '0' ) {
					swbreak
				}
				return false
		swend
		return true
	}
	
	// ���x���̑O�𒲂ׂ�
	switch p_befTT
		case TKTYPE_END
		case TKTYPE_OPERATOR
		case TKTYPE_CIRCLE_L
		case TKTYPE_KEYWORD
		case TKTYPE_COMMA
		case TKTYPE_MACRO_PRM
		case TKTYPE_MACRO_SP
			// �������� OK
			swbreak
			
		case TKTYPE_VARIABLE
		case TKTYPE_NAME
			// ���x���̑O�̎��ʎq���A�����ɂ��� or goto / gosub �Ȃ�n�j
			i  = p2
			i -= CntSpacesBack( p1, i )
			m  = BackToIdentTop(p1, p2)
			if ( m < 0 ) { return false }	// �O�����ʎq�ł͂Ȃ� (�ُ�H)
			i -= m
			
;			// �����ŁAgoto gosub �Ȃ� OK
;			stmp = getpath( CutName(p1, i + 1), 16 )
;			if ( stmp == "gosub" || stmp == "goto" ) {
;				swbreak
;			}
			
			i -= CntSpacesBack( p1, i )		// �� ignore
			i --							// ���x���̑O�̑O
			if ( i < 0 ) { swbreak }
			c  = peek(p1, i)
			if ( IsNewLine(c) || c == ':' || c == '{' || c == '}' ) {
				swbreak
			}
			return false
			
		default
			// �\���� OK
			if ( IsTkTypeReserved(p_befTT) ) {
				swbreak
			}
			
			// ���̑��Ȃ�_��
			return false
	swend
	
	// ���x�������΂�
	c = peek(p1, p2 + 1)
	if ( IsIdentTop(c) == false ) { return false }	// �������ʎq�̐擪�łȂ���΁~
	i = p2 + 2
	repeat
		c = peek(p1, i)
		if ( IsIdent(c) == false ) {
			break
		}
		i ++
	loop
	
	// ���x���̌�𒲂ׂ�
	while
		i += CntSpaces(p1, i)	// �󔒂��X�L�b�v
		c  = peek(p1, i)		// ���x���̎�
		
		if ( c == '/' ) {
			c2 = peek(p1, i + 1)
			if ( c2 == '/' ) { return true }		// �_�u���E�X���b�V���̃R�����g
			if ( c2 == '*' ) {						// �����s�R�����g�J�n
				iFound = instr(p1, i + 2, "*/")		// �I���n�_��T��
				if ( iFound >= 0 ) {
					i += 4 + iFound					// /**/ + ����
					_continue						// ������x�u���x���̎��v���`�F�b�N����
				}
			}
		} else : if ( c == '@' ) {
			// �X�R�[�v�����X�L�b�v
			do
				i ++
				c = peek(p1, i)
			until ( IsIdent(c) == false )
			_continue
		}
		_break
	wend
	
	// ;:{}), ���s���� NULL �łȂ���΁~
	if ( c != NULL && (c == ';' || c == ':' || c == '{' || c == '}' || c == ')' || c == ',' || c == 0x0D || c == 0x0A) == false ) {
		return false
	}
	return true
	
//------------------------------------------------
// ���߂��H ( p1 �ɖ��ʂȋL����󔒂�����ƁA�U )
//------------------------------------------------
#defcfunc IsStatement str p1
	return ( instr( keylist_statement, 0, ","+ getpath(p1, 16) +"," ) >= 0 )
	
//------------------------------------------------
// �֐����H ( p1 �ɖ��ʂȕ���������ƁA�U )
//------------------------------------------------
#defcfunc IsFunction str p1
	return ( instr( keylist_function, 0, ","+ getpath(p1, 16) +"," ) >= 0 )
	
//------------------------------------------------
// �V�X�e���ϐ����H
//------------------------------------------------
#defcfunc IsSysvar str p1
	return ( instr( keylist_sysvar, 0, ","+ getpath(p1, 16) +"," ) >= 0 )
	
//------------------------------------------------
// �}�N�����H
//------------------------------------------------
#defcfunc IsMacro str p1
	return ( instr( keylist_macro, 0, ","+ getpath(p1, 16) +"," ) >= 0 )
	
//------------------------------------------------
// �v���v���Z�b�T���߂��H
//------------------------------------------------
#defcfunc IsPreproc str p1
	return ( instr( keylist_preproc, 0, ","+ CutPreprocIdent(p1) +"," ) >= 0 )
	
//------------------------------------------------
// �v���v���Z�b�T�s�L�[���[�h���H
//------------------------------------------------
#defcfunc IsPreprocWord str p1
	return ( instr( keylist_ppword, 0, ","+ getpath(p1, 16) +"," ) >= 0 )
	
//------------------------------------------------
// �v���v���Z�b�T���߂̎��ʎq�̕��������o��
//------------------------------------------------
#defcfunc CutPreprocIdent str p1,  local stmp
	stmp = getpath(p1, 16)
	stmp = strmid( stmp, 1 + CntSpaces( stmp, 1 ), strlen(stmp) )
	return stmp
	
#global
hpm_sub_initialize@hpm_sub

#endif

//##################################################################################################
#if 0
/*
#deffunc _init
	sSings = SIGN
	return
	
//------------------------------------------------
// ��؂蕶�����H
//------------------------------------------------
#defcfunc IsSign int p1
	return ( instr(sSigns, 0, strf("%c", p1)) >= 0 )
	
//------------------------------------------------
// �P��P�ʂŕ������Ă��邩�H
//------------------------------------------------
#defcfunc IsIndependentWord var p1, int p2, int wordlen
	// �O�͂n�j���H
	if ( p2 ) {
		if ( IsSign( peek(p1, p2 - 1) ) == false ) { return false }
	}
	// ���͂n�j���H
	if ( IsSign(peek(p1, p2 + wordlen)) == false ) { return false }
	return true
	
//------------------------------------------------
// ���S��v���H
//------------------------------------------------
#defcfunc IsCompleteLength var p1, int p2
	if (         p2 !=        0 ) { return false }
	if ( strlen(p1) != MatchLen ) { return false }
	return true
	
//------------------------------------------------
// ���߂��H ( p1 �ɖ��ʂȋL����󔒂�����Ǝ��s )
//------------------------------------------------
#defcfunc IsStatement var p1, local stmp
	n = instrCom( p1, 0, STATE1, 1 ) : if ( IsCompleteLength(p1, n) ) { return true }
	n = instrCom( p1, 0, STATE2, 1 ) : if ( IsCompleteLength(p1, n) ) { return true }
	n = instrCom( p1, 0, STATE3, 1 ) : if ( IsCompleteLength(p1, n) ) { return true }
	n = instrCom( p1, 0, STATE4, 1 ) : if ( IsCompleteLength(p1, n) ) { return true }
	return false
	
//------------------------------------------------
// �֐����H ( p1 �ɖ��ʂȕ���������Ǝ��s )
//------------------------------------------------
#defcfunc IsFunction var p1
	n = instrCom( p1, 0, FUNC, 1 )		// �啶���E���������}(����)��Ȃ�
	return IsCompleteLength(p1, n)
	
//------------------------------------------------
// �V�X�e���ϐ����H
//------------------------------------------------
#defcfunc IsSysvar var p1
	n = instrCom( p1, 0, SYSVAR, 1 )
	return IsCompleteLength(p1, n)
	
//------------------------------------------------
// �}�N�����H
//------------------------------------------------
#defcfunc IsMacro var p1
	n = instrCom( p1, 0, MACRO1, 1 ) : if ( IsCompleteLength(p1, n) ) { return true }
	n = instrCom( p1, 0, MACRO2, 1 ) : if ( IsCompleteLength(p1, n) ) { return true }
	return false
	
//------------------------------------------------
// �v���v���Z�b�T���߂��H
//------------------------------------------------
#defcfunc IsPreproc var p1
	n = instrCom( p1, 0, PRE )
	return IsCompleteLength(p1, n)
	
//------------------------------------------------
// �v���v���Z�b�T�s�L�[���[�h���H
//------------------------------------------------
#defcfunc IsPreprocWord var p1
	n = instrCom( p1, 0, FUNCWORD, 1 )
	return IsCompleteLength(p1, n)
	
*/
#endif
