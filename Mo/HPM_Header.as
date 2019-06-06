// HSP parse module - Header

#ifndef __HSP_PARSE_MODULE_HEADER_AS__
#define __HSP_PARSE_MODULE_HEADER_AS__

#include "ctype.as"

#define MAX_TEXTLEN 0x2FFFF

#define ctype IsTkTypeIdent(%1) ( (%1) == TKTYPE_NAME || (%1) == TKTYPE_VARIABLE || IsTkTypeReserved(%1) )
#define ctype IsTkTypeReserved(%1) ( (%1) == TKTYPE_KEYWORD || (%1) == TKTYPE_EX_STATEMENT || (%1) == TKTYPE_EX_FUNCTION || (%1) == TKTYPE_EX_SYSVAR || (%1) == TKTYPE_EX_MACRO || (%1) == TKTYPE_EX_PREPROC_KEYWORD )

//------------------------------------------------
// �g�[�N���̎��
//------------------------------------------------
#enum TKTYPE_ERROR = (-1)
#enum TKTYPE_END   = 0			// : ���s { } �I�[ �ȂǁA���̏I�[�ƂȂ����
#enum TKTYPE_BLANK				// ��
#enum TKTYPE_OPERATOR			// + - * / \ & | ^ = < >
#enum TKTYPE_CIRCLE_L			// (
#enum TKTYPE_CIRCLE_R			// )
#enum TKTYPE_MACRO_PRM			// �}�N���p�����[�^( %1 %2 %3 etc... )
#enum TKTYPE_MACRO_SP			// ����W�J�}�N�� ( %t, %i etc... )
#enum TKTYPE_NUMBER				// 0123456789. $E0F %0 0xFF 0b11
#enum TKTYPE_STRING				// "string\n\t\\"
#enum TKTYPE_CHAR				// 'x'
#enum TKTYPE_LABEL				// *main
#enum TKTYPE_PREPROC			// #enum ...etc
#enum TKTYPE_PREPROC_DISABLE	// # ����n�܂邪�v���v���Z�b�T���߂ł͂Ȃ�
#enum TKTYPE_KEYWORD			// ���ʎq (�L�[���[�h) (���߁A�֐��A�c)
#enum TKTYPE_VARIABLE			// ���ʎq (�ϐ�)
#enum TKTYPE_NAME				// ���ʎq (��̓I�ɂ͕s��)
#enum TKTYPE_COMMENT			// �R�����g
#enum TKTYPE_COMMA				// ,
#enum TKTYPE_PERIOD				// .
#enum TKTYPE_SCOPE				// @�X�R�[�v
#enum TKTYPE_ESC_LINEFEED		// ���s��� (�s����\)
#enum TKTYPE_ANY				// �Ȃɂ�
#enum TKTYPE_EX_STATEMENT		// �W������
#enum TKTYPE_EX_FUNCTION		// �W���֐�
#enum TKTYPE_EX_SYSVAR			// �W���V�X�e���ϐ�
#enum TKTYPE_EX_MACRO			// �W���}�N��
#enum TKTYPE_EX_PREPROC_KEYWORD	// �v���v���Z�b�T�s�L�[���[�h
#enum TKTYPE_MAX

//------------------------------------------------
// ���ʎq�̎��
//------------------------------------------------
#enum IDENTTYPE_ERROR     = (-1)
#enum IDENTTYPE_OTHER     = 0	// �ȉ��Ɋ܂܂Ȃ�
#enum IDENTTYPE_STATEMENT		// ����
#enum IDENTTYPE_FUNCTION		// �֐�
#enum IDENTTYPE_MACRO			// �}�N��
#enum IDENTTYPE_PREPROC			// �v���v���Z�b�T����
#enum IDENTTYPE_VARIABLE		// �ϐ�
#enum IDENTTYPE_LABEL			// ���x����
#enum IDENTTYPE_MODNAME			// ���W���[����
#enum IDENTTYPE_IFACE			// �C���^�[�t�F�[�X
#enum IDENTTYPE_MAX

//------------------------------------------------
// �L�[���[�h���X�g
//------------------------------------------------
#define KEYWORDS_ALL ( KEYWORDS_STATEMENT + KEYWORDS_FUNCTION + KEYWORDS_SYSVAR + KEYWORDS_PREPROC + KEYWORDS_MACRO + KEYWORDS_MODNAME + KEYWORDS_PPWORD )
#define KEYWORDS_STATEMENT "await,assert,break,continue,end,exec,exgoto,foreach,gosub,goto,if,else,loop,on,onclick,oncmd,onerror,onexit,onkey,repeat,return,run,stop,wait,logmes,axobj,bgscr,bmpsave,boxf,buffer,chgdisp,circle,cls,color,dialog,font,gcopy,gmode,grect,groll,grotate,gsel,gsquare,gzoom,gradf,hsvcolor,line,mes,palcolor,palette,pget,picload,pos,print,pset,redraw,screen,sendmsg,syscolor,sysfont,title,width,winobj,cnvstow,getstr,split,noteadd,notedel,noteget,noteload,notesave,notesel,noteunsel,button,chkbox,clrobj,combox,input,listbox,mesbox,objmode,objprm,objsel,objsize,objenable,objskip,objimage,comres,delmod,dimtype,dim,lpoke,memcpy,memexpand,memset,newmod,poke,sdim,setmod,wpoke,bcopy,bload,bsave,chdir,chdpm,delete,dirlist,exist,memfile,mkdir,getkey,mcall,mouse,randomize,stick,dup,dupptr,mref,mci,mmload,mmplay,mmstop,comevarg,comevent,delcom,newcom,querycom,sarrayconv,"
#define KEYWORDS_FUNCTION  "cnvwtos,getpath,instr,noteinfo,strf,strmid,strtrim,lpeek,peek,wpeek,abs,absf,atan,callfunc,cos,dirinfo,double,expf,gettime,ginfo,int,length,length2,length3,length4,libptr,limit,limitf,logf,objinfo,rnd,sin,sqrt,str,strlen,sysinfo,tan,varptr,vartype,varuse,comevdisp,"
#define KEYWORDS_SYSVAR    "cnt,err,hdc,hinstance,hspstat,hspver,hwnd,iparam,looplev,lparam,mousew,mousex,mousey,refdval,refstr,stat,strsize,sublev,thismod,wparam,"
#define KEYWORDS_PREPROC   "addition,aht,ahtmes,cfunc,cmd,cmpopt,comfunc,const,defcfunc,deffunc,define,else,endif,enum,epack,func,global,if,ifdef,ifndef,include,modfunc,modcfunc,modinit,modterm,module,pack,packopt,regcmd,runtime,undef,usecom,uselib,"
#define KEYWORDS_MACRO     "__hspver__,__hsp30__,__date__,__time__,__file__,_debug,alloc,ddim,_break,_continue,case,default,do,for,next,swbreak,swend,switch,until,wend,while,and,not,or,xor,ginfo_act,ginfo_b,ginfo_cx,ginfo_cy,ginfo_dispx,ginfo_dispy,ginfo_g,ginfo_intid,ginfo_mesx,ginfo_mesy,ginfo_mx,ginfo_my,ginfo_paluse,ginfo_r,ginfo_sel,ginfo_sizex,ginfo_sizey,ginfo_sx,ginfo_sy,ginfo_vx,ginfo_vy,ginfo_winx,ginfo_winy,ginfo_wx1,ginfo_wx2,ginfo_wy1,ginfo_wy2,ginfo_newid,dir_cmdline,dir_cur,dir_desktop,dir_exe,dir_mydoc,dir_sys,dir_win,font_normal,font_bold,font_italic,font_underline,font_strikeout,font_antialias,gmode_add,gmode_alpha,gmode_gdi,gmode_mem,gmode_pixela,gmode_rgb0,gmode_rgb0alpha,gmode_sub,objmode_normal,objmode_bmscr,objmode_hwnd,objmode_mode,objmode_guifont,objmode_usefont,msgothic,msmincho,notemax,notesize,"
#define KEYWORDS_MODNAME   "hsp,"
#define KEYWORDS_PPWORD    "global,ctype,int,str,sptr,wstr,double,float,label,comobj,var,array,modvar,nullptr,wptr,pval,bmscr,prefstr,pexinfo,local,onexit,"

//------------------------------------------------
// �p�^�[���̃}�N��
//------------------------------------------------

// �P��̐؂�ڂ�\���L��
#define SIGN "[ \t!\"&'()<>=|-^\\@{};+:*,./\n\r'\\\\`]"

#define STATE1 "(screen|buffer|bgscr|dialog|g(sel|copy|zoom|mode|roll|rect|rotate|square)|width|picload|bmpsave|(sys|hsv|pal)?color|p[sg]et|palette|(log)?mes|print|title|(po|cl)s|(sys)?font|redraw|boxf|line|circle)"
#define STATE2 "((clr|ax|win)obj|obj(size|sel|prm|mode)|button|(list|chk|mes)box|input|if|else|go(to|sub)|exgoto|return|on(exit|error|key|click|cmd)?|repeat|foreach|loop|break|continue|a?wait|end|stop)"
#define STATE3 "(s?dim|dimtype|dup(ptr)?|mref|(new|del|set)mod|(new|del|query)com|mcall|com(res|event|evarg|evdisp)|sarrayconv|cnv(stow|wtos)|[wl]?poke|getstr|mem(cpy|set|expand|file)|note((un)?sel|add|del|load|save|get))"
#define STATE4 "(exist|dirlist|(ch|mk)dir|delete|b(save|load|copy)|mouse|getkey|stick|mm(load|play|stop)|sendmsg|exec|randomize|run|ch(gdisp|dpm)|mci|assert)"
#define FUNC   "(var(ptr|type|use)|libptr|callfunc|(g|obj|dir|sys|note)info|get(time|path)|in(t|str)|double|str(mid|len|f)?|[wl]?peek|length[234]?|rnd|limitf?|sin|cos|a?tan|absf?|sqrt|(exp|log)f)"

#define SYSVAR "(err|h(instance|dc|wnd)|(sub|loop)lev|system|hsp(stat|ver)|st(at|rsize)|ref(str|dval)|cnt|thismod|[iwl]param|mouse[wxy])"

#define PRE "#[ \t]*(use(lib|com)|(com)?c?func|def(ine|c?func)|const|enum|(reg)?cmd|undef|mod(ule|init|c?func|term)|global|include|addition|(pack|cmp)opt|e?pack|if(n?def)?|else|endif|runtime|aht(mes)?)"
#define MACRO1 "and|x?or|not|alloc|ddim|for|next|w(hile|end)|do|until|_(break|continue|debug)|sw(itch|end|break)|case|default|__(hsp(ver|30)|date|time|file)__"
#define MACRO2 "(ginfo_(act|[rgb]|([cmsv]|disp|mes|size|win)[xy]|w[xy][12]|paluse|intid)|dir_(cur|desktop|exe|mydoc|sys|win|cmdline)|ms(gothic|mincho))"
#define FUNCWORD "((mod)?var|array|int|([sw]|null)ptr|(pref|w)?str|double|float|l(abe|oca)l|pval|comobj|bmscr|pexinfo|global|ctype|onexit)"

#define STRING "\".*?(\\\\\\\\)*[^\\\\]?\""
#define LABEL  "\\*([^ �@*\t\r\n\"#$&'(){}<>\\[\\]+-/=\\\\;:.,?@]+|@([a-zA-Z]?)([a-zA-Z0-9]*)?)"
#define COMMENT1 "((;|//)[^\n\r]*)"//				��s�R�����g�̂�
#define COMMENT2 "(/\\*.*?\\*/)"//					�����s�R�����g�̂�
#define COMMENT3 "((;|//)[^\n\r]*|(/\\*.*?\\*/))"//	�R�����g�Ɋ��S�Ή�
#define COMMENT4 "/\\*[^\n\r]+?\\*/"//				��s���� /* */
#define MULTICOM "/\\*(.*[\n\r].*)+"
#define MULTISTR "{\""

#define BLANK "[ \t]+"// ��

#define ctype MAX(%1=0,%2=0) ((%1)*((%1)>=(%2)) | (%2) *((%1)<(%2)) )
#define ctype MIN(%1=0,%2=0) ((%1)*((%1)<=(%2)) | (%2) *((%1)>(%2)) )

#endif
