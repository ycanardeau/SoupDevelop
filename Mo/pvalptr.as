// pvalptr module

#ifndef __PVALPTR_MODULE_AS__
#define __PVALPTR_MODULE_AS__

#module pvalptr_module
#define prmstack 207
#define global ctype pvalptr(%1) _pvalptr(%1, 0)//	指定した変数のPVALポインタ値を取得
#define global ctype getaptr(%1) _pvalptr(%1, 1)//	指定した( 配列 )変数のAPTR値を取得
#defcfunc _pvalptr var p1, int p2
	dim ctx
	mref ctx, 68
	dupptr vptr, ctx(prmstack), 8, 4
	return vptr(p2)
#global

#endif
