// HSP parse module - GetToken

#ifndef __HSP_PARSE_MODULE_GET_TOKEN_AS__
#define __HSP_PARSE_MODULE_GET_TOKEN_AS__

#include "HPM_cutToken.as"	// ���ʎq���o��
#include "HPM_sub.as"		// ���W���[��

// ��v���W���[��
#module hpm_getToken

#include "HPM_header.as"

#uselib "user32.dll"
#func   CharLower@hpm_getToken "CharLowerA" int

//------------------------------------------------
// �}�N��
//------------------------------------------------
#define ctype IsWOp(%1) ((%1) == '<' || (%1) == '=' || (%1) == '>' || (%1) == '&' || (%1) == '|' || (%1) == '+' || (%1) == '-')

#define NULL 0

//------------------------------------------------
// ���̃g�[�N�����擾����
//------------------------------------------------
#deffunc hpm_getNextToken var result, var sSrc, int index, int p_befTT, int bPreLine
	c = peek(sSrc, index)
	
	// �� (Blank)
	if ( IsSpace(c) ) {
		result = CutSpace(sSrc, index)
		return TKTYPE_BLANK
	}
	
	// ���ʎq (Identifier)
	if ( IsIdentTop(c) || c == '`' || IsSJIS1st(c) ) {
		result = CutName(sSrc, index)
		return TKTYPE_NAME
	}
	
	// �v���v���Z�b�T���� (Preprocessor)
	if ( c == '#' ) {
		iFound = 1 + CntSpaces(sSrc, index + 1)		// ��
		result = strmid(sSrc, index, iFound) + CutName(sSrc, index + iFound)
		return TKTYPE_PREPROC
	}
	
	// ������萔 (Single-line String Literal)
	if ( c == '"' ) {
		result = CutStr(sSrc, index)			// ����������o�� (""���܂�)
		return TKTYPE_STRING
	}
	
	// �����s������萔 (Multi-line String Literal)
	if ( wpeek(sSrc, index) == 0x227B ) {		// {"
		result = CutStrMulti(sSrc, index)		// �����s����������o�� ({" "} �܂�)
		return TKTYPE_STRING
	}
	
	// �I���L��
	if ( c == ':' || c == '{' || c == '}' || IsNewLine(c) || c == 0 ) {
		result = strf("%c", c)
		if ( c == 0x0D ) {		// CRLF
			if ( peek(sSrc, index + 1) == 0x0A ) {
				result = "\n"
			}
		} else : if ( c == 0x0A ) {
			result = "\r"
		}
		return TKTYPE_END
	}
	
	// �L�� (Sign)
	if ( c == ',' ) { result = "," : return TKTYPE_COMMA    }
	if ( c == '(' ) { result = "(" : return TKTYPE_CIRCLE_L }
	if ( c == ')' ) { result = ")" : return TKTYPE_CIRCLE_R }
	if ( c == '.' ) { result = "." : return TKTYPE_PERIOD   }
	
	// ���x�� (Label) := * ����n�܂�A�����u���̏I�[�A�J���}�A')'�v�̂ǂꂩ
	if ( c == '*' ) {
		if ( IsLabel(sSrc, index, p_befTT, bPreline) ) {
			c2 = peek(sSrc, index + 1)
			if ( c2 == '@' ) {
				result = "*@"+ CutName(sSrc, index + 2)		// *@ �̌�͍D���Ȃ������o��
			} else : if ( c2 == '%' ) {						// *%
				result = "*%"+ CutName(sSrc, index + 2)
			} else {
				result = "*"+ CutName(sSrc, index + 1)		// �؂�o��
			}
			return TKTYPE_LABEL
		}
	}
	
	// �s���R�����g (Single-line Comment)
	if ( c == ';' || wpeek(sSrc, index) == 0x2F2F ) {
		getstr result, sSrc, index			// ���s�܂Ŏ��o��
		return TKTYPE_COMMENT
	}
	
	// �����s�R�����g (Multi-line Comment)
	if ( wpeek(sSrc, index) == 0x2A2F ) {
		iFound = instr(sSrc, index + 2, "*/")
		if ( iFound < 0 ) {
			result = strmid(sSrc, index, strlen(sSrc) - index)	// �ȍ~���ׂăR�����g
		} else {
			result = strmid(sSrc, index, iFound + 4)			// �J�n�E�I�����܂�
		}
		return TKTYPE_COMMENT
	}
	
	// ���Z�q (Operator)
	if ( IsOperator(c) ) {
		
		// 2 �o�C�g�̉��Z�q�̎������� ( ?= ���A&& || �Ȃǂ̓�d )
		c2 = peek(sSrc, index + 1)
		if ( c2 == '=' || ( IsWOp(c) && c == c2 ) ) {
			result = strmid(sSrc, index, 2)	// 2 byte
		} else {
			wpoke result, , c			// 1 byte
		}
		if ( c == '\\' && bPreLine ) {	// ���s����̉\��
			if ( IsNewLine(c2) ) {
				if ( c2 == 0x0D && peek(sSrc, index + 2) == 0x0A ) {
					lpoke result,, MAKELONG2('\\', 0x0D, 0x0A, 0)	// "\\\n"
				} else {
					lpoke result,, MAKEWORD('\\', c2)
				}
				return TKTYPE_ESC_LINEFEED
			}
		}
		return TKTYPE_OPERATOR
	}
	
	// �����萔 (Charactor Literal)
	if ( c == '\'' ) {
		result = CutCharactor(sSrc, index)
		return TKTYPE_CHAR
	}
	
	// �����l�萔( 2 or 16 �i�� ) (Binary or Hexadigimal Number)
	if ( c == '$' ) {
		result = "$"+ CutNum_Hex(sSrc, index + 1)
		return TKTYPE_NUMBER
	}
	if ( c == '%' ) {
		c2 = peek(sSrc, index + 1)
		
		if ( bPreLine ) {
			// ��i���\�L ( %%010101 ... etc )
			if ( c2 == '%' && IsBin(peek(sSrc, index + 2)) ) {
				result = "%"+ CutNum_Bin(sSrc, index + 1)
				return TKTYPE_NUMBER
				
			// �}�N������ ( %1, %2, %3 ... etc )
			} else : if ( IsDigit(c2) && c2 != '0' ) {
				result = "%"+ CutNum_Dgt(sSrc, index + 1)
				return TKTYPE_MACRO_PRM
				
			// ����W�J�}�N�� ( %i, %s1 ... etc )
			} else : if ( IsAlpha(c2) ) {
				result = "%"+ CutName(sSrc, index + 1)
				return TKTYPE_MACRO_SP
			}
		}
		
		// ��i���\�L
		result = "%"+ CutNum_Bin(sSrc, index + 1)
		return TKTYPE_NUMBER
	}
	
	if ( c == '0' ) {
		c2 = peek(sSrc, index + 1)
		if ( c2 == 'x' || c2 == 'X' ) {
			result = strmid(sSrc, index, 2) + CutNum_Hex(sSrc, index + 2)
			
		} else : if ( c2 == 'b' || c2 == 'B' ) {
			result = strmid(sSrc, index, 2) + CutNum_Bin(sSrc, index + 2)
			
		} else {
			gosub *LGetToken_Digit
			return stat
		}
		return TKTYPE_NUMBER
	}
	
	// �����l�萔(10�i��) (Digimal Number)
	if ( IsDigit(c) || c == '.' ) {
		gosub *LGetToken_Digit
		return stat
	}
	
	// �X�R�[�v���� (scope solver)
	if ( c == '@' ) {
		result = "@"+ CutName(sSrc, index + 1)
		return TKTYPE_SCOPE
	}
	
	// ��ȏꍇ
*LUnknownToken
	if ( IsSJIS1st(c) ) {
		logmes "ERROR! SJIS code!"
		wpoke result, 0, wpeek(sSrc, index)	// ��������
		poke  result, 3, NULL
		return TKTYPE_ERROR
	}
	
	// �H�H�H
	result = strf("%c", c)
	logmes "ERROR !! Can't Pop a Token! [ "+ index + strf(" : %c : ", c) + c +" ]"
	return TKTYPE_ERROR
	
// 10�i����؂�o��
*LGetToken_Digit
	result = CutNum_Dgt(sSrc, index)
	len    = strlen(result)
	c      = peek( sSrc, index + len )		// ���̎��̕���
	switch ( c )
		case 'f'
		case 'd'
			result += strf("%c", c)
			swbreak
			
		case 'e'
			result += "e"
			
			c2 = peek( sSrc, index + len + 1 )
			if ( c2 == '-' ) {
				result += "-"
				len ++
			}
			
			// �w���𑫂��Ă���
			result += CutNum_Dgt( sSrc, index + len + 1 )
			swbreak
	swend
	
	return TKTYPE_NUMBER
	
#global

#endif
