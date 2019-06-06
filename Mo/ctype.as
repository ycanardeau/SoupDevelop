// ctype

#ifndef __CHARCTOR_TYPE_AS__
#define __CHARCTOR_TYPE_AS__

#ifndef __UserDefHeader__
#define ctype numrg(%1,%2=0,%3=MAX_INT) (((%2) <= (%1)) && ((%1) <= (%3)))
#endif

#define ctype IsSJIS1st(%1) (numrg(%1, 0x81, 0x9F) || numrg(%1, 0xE0, 0xFC))// 全角第一バイトを判定
;#define ctype IsSJIS1st(%1) ( (((%1) ^ 0x20) - 0xA1) < 0x3C)// 巧妙バージョン ( ttp://www.st.rim.or.jp/~phinloda/cqa/cqa15.html#Q4 )
#define ctype IsSJIS2nd(%1) (numrg(%1, 0x40, 0x7E) || numrg(%1, 0x80, 0xFC))// 全角第二バイトを判定

#define ctype IsAlpha(%1)   ( IsAlphaLw(%1) || IsAlphaUp(%1) )
#define ctype IsAlphaLw(%1) ( numrg(%1, 'a', 'z'))
#define ctype IsAlphaUp(%1) ( numrg(%1, 'A', 'Z'))
#define ctype IsDigit(%1)   ( numrg(%1, '0', '9'))
#define ctype IsHex(%1)     ( IsDigit(%1) || numrg(%1, 'a', 'f') || numrg(%1, 'A', 'F') )
#define ctype IsIdentTop(%1)( IsAlpha(%1) || (%1) == '_' )
#define ctype IsIdent(%1)   ( IsDigit(%1) || IsIdentTop(%1) )
#define ctype IsBin(%1)     ( (%1) == '0' || (%1) == '1' )
#define ctype IsOperator(%1)( (%1) == '+' || (%1) == '-' || (%1) == '*' || (%1) == '/' || (%1) == '\\' || (%1) == '&' || (%1) == '|' || (%1) == '^' || (%1) == '!' || (%1)== '=' || (%1) == '<' || (%1) == '>' )
#define ctype IsNewLine(%1) ( (%1) == 0xD || (%1) == 0xA )
#define ctype IsQuote(%1)   ( (%1) == '\''|| (%1) == '"' )
#define ctype IsSpace(%1)   ( (%1) == ' ' || (%1) == '\t')
#define ctype IsBlank(%1)   ( IsSpace(%1) || IsNewLine(%1) )
#define ctype IsSpace2(%1,%2=0) ( IsSpace(%1) || ((%2) != 0) * IsNewLine(%1) )
#define ctype IsNull(%1)    ( (%1) == 0 )

#endif
