
;============================================================
;                                                 2007/xx/xx
;	S.Programs HHX
;	hs database module
;                               http://sprocket.babyblue.jp/
;============================================================
; hs �t�@�C���d�l 2.0 �Ή� hs �f�[�^�x�[�X���W���[�� (HSP3)


;============================================================
; �t�B�[���h��` (global)
;		Symbol		FID	FieldTag
;------------------------------------------------------------
#define global	C_NAME		0	; %index  line 1
#define global	C_SUMMARY	1	; %index  line 2-
#define global	C_INST		2	; %inst
#define global	C_PRM		3	; %prm    line 1
#define global	C_PRM2		4	; %prm    line 2-
#define global	C_SAMPLE	5	; %sample
#define global	C_HREF		6	; %href
#define global	C_PORTINF	7	; %portinfo
#define global	C_PORT		8	; %port
#define global	C_GROUP		9	; %group
#define global	C_TYPE		10	; %type
#define global	C_NOTE		11	; %note
#define global	C_URL		12	; %url
#define global	C_VER		13	; %ver
#define global	C_DATE		14	; %date
#define global	C_DLL		15	; %dll
#define global	C_HSFILE	16	; hs �t�@�C����
#define global	C_AUTHOR	17	; %author
#define global	C_MAX		18	; �z��̍ő�l
#define global	C_VOID		999	; (�����ȃ����o)
; (�Ⴂ�����قǃL�[���[�h�K���x�ւ̏d�݂��傫��)


;------------------------------------------------------------
; notnull(string_var)
#define global ctype notnull(%1) peek(%1)



;============================================================
; note_merge ���W���[��

#module

;--------------------------------------------------
; ������}�[�W (�d���s�J�b�g) (���s��؂�)
; prm : note
#defcfunc note_merge str st1_

	; �\�[�X = �A������������
	st1 = st1_
	oup = ""

	astr = "" ;sdim astr, 64, 64
	c = 0

	; �A������������̊e�s��z��ɕ���
	p = 0
	repeat
		getstr astr.c, st1, p  ,,99999
		if strsize = 0 : break
		c++
		p += strsize
	loop

	; �d���s�������悤�ɕ�������č\��
	repeat c
		c = cnt
		repeat c + 1
			if cnt = c {
				if notnull(oup) : oup += "\n"
				oup += astr.c
				break
			}
			if astr.cnt = astr.c { ; �d������s�͏��O
				break
			}
		loop
	loop

	return oup

;--------------------------------------------------
; ������A���}�[�W (���s��؂�)
; prm : note_default, note_sub
#defcfunc note_unmerge str st1_, str st2_

	st1 = st1_
	st2 = st2_
	oup = ""

	astr = "" ;sdim astr, 64, 64
	c = 0

	; ���O���镶�����z��ɕ���
	p = 0
	repeat ; sub
		getstr astr.c, st2, p  ,,99999
		if strsize = 0 : break
		c++
		p += strsize
	loop

	; ���O��������������Ȃ���\�[�X��������č\��
	p = 0
	sdim bstr
	repeat ; src2
		getstr bstr, st1, p  ,,99999
		if strsize = 0 : break
		p += strsize

		repeat c
			if bstr = astr.cnt { ; sub ������Ɋ܂܂��s�͏��O
				break
			}
			if cnt+1 = c {
				if notnull(oup) : oup += "\n"
				oup += bstr
			}
		loop
	loop

	return oup

#global



;============================================================
;============================================================
; HHX �f�[�^�x�[�X���W���[�� ���C��

#module mHsDatabase

; config
#define	global DBFILE	"hhx.db"
#define	global DBVER	0x210c00
#define	CMP_MAX	255	; ���k �ő�X���C�h�� (0 - 255)
#define	CMP_MN	31	; �g�����k�R�[�h

; global var
#define global hhxdata hhxdatax@

; const
#define	C_SEP	0x7f
#define	S_SEP	""	; 0x7f
#define	CRLF	0x0A0D
#define global DBR_WRITEDB	444	; HHX_init_rebuild_db �p�����[�^ : DB �ۑ����[�h
#define global DBR_READONLY	555	; DB �ۑ����Ȃ����[�h

; winapi
#uselib "user32"
#func	CharLower	"CharLowerA" sptr
#uselib "kernel32"
#cfunc	FindFirstFileA	"FindFirstFileA" str, sptr
#cfunc	FindNextFileA	"FindNextFileA" int, sptr
#cfunc	FindClose	"FindClose" int
#func	LCMapString	"LCMapStringA" int, int, sptr, int, sptr, int
#define	LCMAP_LOWERCASE	$00000100
#define	LCMAP_HALFWIDTH	$00400000
#define	LCMAP_KATAKANA	$00200000
;#const	LCMFlag		LCMAP_LOWERCASE | LCMAP_HALFWIDTH
#const	LCMFlag		LCMAP_LOWERCASE
#define	NormalStr(%1, %2) LCMapString 0x0411, LCMFlag, varptr(%2), -1, varptr(%1), 65000

; UTF BOM ����
#define ctype IS_UTF8(%1)	((lpeek(%1) & 0x00ffffff) = 0xBFBBEF)
#define ctype IS_UTF16(%1)	(wpeek(%1) = 0xFEFF)
#define ctype IS_UTF16BE(%1)	(wpeek(%1) = 0xFFFE)
#define ctype IS_UTF32(%1)	(lpeek(%1) = 0x0000FEFF)
#define ctype IS_UTF32BE(%1)	(lpeek(%1) = 0xFFFE0000)

;============================================================ finder

;--------------------------------------------------
#deffunc local Initialize
	sdim hhxnormv
	sdim hhxdata
	dim hhxmax
	dim currentset_sum
	dim diffmode
	
	return

;--------------------------------------------------
; hhxdata ��W�������� (org ���������ɕϊ���������) �ŕԂ�
#defcfunc hhxnorm int pr1, int pr2
	NormalStr hhxnormv, hhxdata.pr1.pr2 ; �팟�������� �W����
	return hhxnormv

;--------------------------------------------------
; (results) HHX_select_all()
; ���R�[�h�Z�b�g�Ƃ��Ă��ׂẴ��R�[�h���
#defcfunc HHX_select_all

	; �������� ����쐬 (= �S��)
	find_cur = -1		; HHX_get_next �p
	finds = hhxmax		; �S��
	repeat hhxmax
		find_list(cnt) = cnt
	loop

	return finds

;--------------------------------------------------
; (results) HHX_select_where("����������", ���S��v�t�B�[���h, ���O ID)
; ���R�[�h�Z�b�g�Ƃ��Č��������Ƀ}�b�`���郌�R�[�h��� �o�͏��͌����L�[���[�h�Ƃ̓K���x��
#defcfunc HHX_select_where  str q, int c_equal, int ngid

	;--------------------------------------------------
	; init

	find_cur = -1		; HHX_get_next �p
	query = q
	CharLower varptr(query)		; ���������� �W����
	dim evals, hhxmax	; �]���l�e�[�u��������


	;--------------------------------------------------
	; ���S��v�t�B�[���h��v�����ꂽ�ꍇ

	if c_equal >= 0 {
		finds = 0	; ������������
		repeat hhxmax
			if hhxnorm(cnt, c_equal) = query {
				find_list(finds) = cnt
				finds++
			}
		loop
		return finds
	}


	;--------------------------------------------------
	; ���� (�i����)

	; �����L�[���[�h��z��ɗ�
	sdim cmpstr, 64, 64
	kwds = 0
	p = 0
	repeat
		; query �X�y�[�X��؂�o��
		getstr cmpstr.kwds, query, p, ' '
		if strsize = 0 : break
		p += strsize
		if notnull(cmpstr.kwds) : kwds++
	loop

	; �N�G���ɃL�[���[�h���܂܂�Ă��Ȃ������� : �������� 0 ��
	if kwds = 0 : return 0

	; �����p�W�������� �쐬
	dim sindex_cached
	if sindex_cached = 0 {
		sindex_cached = 1
		sdim sindex, 2048, hhxmax

		repeat hhxmax
			id = cnt
			repeat C_MAX
				sindex.id += hhxdata(id, cnt) + " "
			loop
			CharLower sindex.id
		loop
	}

	; AND ����
	repeat hhxmax
		id = cnt
		if id = ngid : continue ; NG ID ���O
		sxlen = strlen(sindex.id)

		repeat kwds
			astr = cmpstr.cnt

			; NOT ����
			if peek(astr) = '-' : if astr ! "-" {
				astr = strmid(astr, 1, 999)
				if instr(sindex.id, 0, astr) = -1 {
					if evals(id) = 0 : evals(id) = 1
					continue
				} else {
					evals(id) = 0
					break
				}
			}

			; AND ����
			a = 0 ; eval
			p = 0
			repeat 3 ; (�擪���� i ��܂ŒT��)
				i = instr(sindex.id, p, astr)
				if i >= 0 {
					p += i

					; �P��P�ʂł̃}�b�`��D�悷��悤 n ��ݒ�
					n = 1000
					c = peek(sindex.id, p + strlen(astr))
					if (c >= '_' & c <= 'z') {
						n = 400
					} else:if i {
						c = peek(sindex.id, p - 1)
						if (c >= '_' & c <= 'z') : n = 400
					}

					; �]���� A
					b = int( (cos(limitf(4.0 * p / sxlen + 0.2, 0, 3)) + 1) * n / 2 )
					if b > a : a = b ; eval �ő�l���̗p

					p++
					if p >= sxlen : break
				} else {
					break
				}
			loop

			if a {
				evals(id) += a
			} else {
				evals(id) = 0
				break
			}
		loop

		; test �]���l�\��
	;	hhxdata.id.0 += "~"
	;	poke hhxdata.id.0, instr(hhxdata.id.0, 0, "~")
	;	hhxdata.id.0 += "~"+evals(id)
	loop


	;--------------------------------------------------
	; evals �\�[�g�ς� ID ���� find_list �쐬

	max = 0 ; �]���̍ő�l

	; �\�[�g�O find_list �쐬
	finds = 0		; ������������
	repeat hhxmax
		if evals(cnt) {
			find_list(finds) = cnt
			finds++

			if evals(cnt) > max : max = evals(cnt)
		}
	loop

	; ��i��\�[�g (�~��) (max : 31bit)
	; (�������̂��߁A�K�v�Œ���̉� (1+logf(max)/logf(2)) ���s)

	repeat (1 + logf(max) / logf(2))
		; bit pos
		bit = cnt

		a = 0
		b = 0

		repeat finds
			c = find_list(cnt)
			if (evals(c) >> bit & 1) {
				find_list(a) = c
				a++
			} else {
				blst(b) = c
				b++
			}
		loop

		; �A��
		memcpy find_list, blst, b * 4, a * 4
	loop


	return finds

;--------------------------------------------------
; HHX_order_by (�Ώۃt�B�[���h)
; ���݂̃��R�[�h�Z�b�g�̏o�͏��Ԃ�ύX (�����\�[�g)
#deffunc HHX_order_by int prm_fld

	#define ar find_list	; �\�[�g�Ώ�
	len = finds		; �\�[�g����
	dim tr, len ; temp arry


	;--------------------------------------------------
	; �\�[�g�p�W��������z�� �쐬

	sdim tmpnorm, 64, hhxmax
	repeat len
		tmpnorm(ar(cnt)) = hhxdata(ar(cnt), prm_fld)
		CharLower tmpnorm(ar(cnt))
	loop


	;--------------------------------------------------
	; �}�[�W�\�[�g (�{�g���A�b�v�^)
	
	repeat
		; �Z�O�����g�T�C�Y��`
		n = 1 << cnt	; �}�[�W�T�C�Y
		m = n * 2	; �Z�O�����g �T�C�Y

		; �S�Z�O�����g�ɑ΂���
		repeat
			; �Z�O�����g �̈��`
			p  = m * cnt			; �Z�O�����g�J�n�_
			p1 = p				; �p�[�g 1 �J�n�_
			e1 = p1 + n			; �p�[�g 1 �I���_
			p2 = e1				; �p�[�g 2 �J�n�_
			e2 = limit(p2 + n, 0, len)	; �p�[�g 2 �I���_ (clipping)
			s  = e2 - p1			; �Z�O�����g �T�C�Y

			if s <= n : break		; �Z�O�����g �T�C�Y��臒l�ȉ��Ȃ� �}�[�W���Ȃ�

			; �Z�O�����g�� �}�[�W
			repeat s
				if p2 >= e2 { ; p2 �̈�O
					tr(cnt) = ar(p1) : p1++
				} else:if p1 >= e1 { ; p1 �̈�O
					tr(cnt) = ar(p2) : p2++

				; ��r & �}�[�W (Core)
				} else:if (tmpnorm(ar(p1)) ! tmpnorm(ar(p2))) <= 0 {
					tr(cnt) = ar(p1) : p1++
				} else {
					tr(cnt) = ar(p2) : p2++
				}
			loop

			; �}�[�W���ꂽ�Z�O�����g�����̔z��ɓ\��t��
			memcpy ar(p), tr, s * 4
		loop

		; �\�[�g ����
		if n >= len : break
	loop

	find_cur = -1

	return

;--------------------------------------------------
; (id) HHX_get_next()
; ���R�[�h�Z�b�g�̎��̃��R�[�h�� ID �����߂�
#defcfunc HHX_get_next
	find_cur++
	return find_list(find_cur)

;--------------------------------------------------
; (id) HHX_exist( "�����V���{��" )
; �V���{���������Ɍ��� (�񕪒T��)
#defcfunc HHX_exist  str q

	r = -1 ; return value
	if hhxmax = 0 : return r
	query = q
	CharLower query ; ���������� �W����

	;--------------------------------------------------
	; �񕪒T�� (�t�B�[���h C_NAME �Ń\�[�g����Ă��邱�Ƃ��O��)

	a = 0		; alpha
	b = hhxmax	; beta
	repeat
		c = (a + b) / 2			; c = a-b center
		f = hhxnorm(c, C_NAME) ! query	; strcmp (-1, 0, 1)
		if f = 0 : r = c : break	; hit
		if (a+1)=b : break		; null window (fault)
		if f < 0 : a = c : else : b = c	; close a-b window
	loop

	return r

;============================================================ loader

;--------------------------------------------------
; (int) HHX_currentset_sum()
; ���݃I���������� hs �Z�b�g�̃`�F�b�N�T����Ԃ�
#defcfunc HHX_currentset_sum
	return currentset_sum

;--------------------------------------------------
; (int) HHX_diskset_sum()
; �f�B�X�N��� hs �t�@�C�� �Z�b�g�̃`�F�b�N�T�������߂�
#defcfunc HHX_diskset_sum

	; hs �t�@�C��
	; ���t / �T�C�Y / DBVER �`�F�b�N�T��

	dim win32_find_data, 80 ; (struct WIN32_FIND_DATA)
	sum = DBVER
	h = FindFirstFileA("*.hs", varptr(win32_find_data))

	if h {
		repeat
			; sum �Z�o (���͏���ˑ�)
			; 5:dwLowDateTime, 6:dwHighDateTime // (ftLastWriteTime) 100ns �P��, 64bit
			; 7:nFileSizeHigh, 8:nFileSizeLow
			sum += win32_find_data.5 * win32_find_data.8

			; ���̃t�@�C��
			if FindNextFileA(h, varptr(win32_find_data)) = 0 {
				break ; �t�@�C�������I��
			}
		loop

		a = FindClose(h)
	}

	return sum & 0x00ffffff ; 24bit �ɐ���

;--------------------------------------------------
; HHX_init_load_db
; �f�B�X�N����f�[�^�x�[�X �L���b�V�������[�h
#deffunc HHX_init_load_db

	; �ǂ����p�̏�����
	sdim hhxnormv, 65536

	currentset_sum = 0

	//exist DBFILE
	if /*strsize*/exist(DBFILE) >= 8 {
		len = stat
		sdim hhxraw, len
		bload DBFILE, hhxraw

		currentset_sum	= lpeek(hhxraw, len - 4) ; hs �Z�b�g�̃`�F�b�N�T��
		hhxmax		= lpeek(hhxraw, len - 8) ; hs �Z�b�g�̃��R�[�h��
	}

	return

;--------------------------------------------------
; HHX_init_extract_db
; ��������̐��f�[�^�x�[�X��z��ɓW�J (hhxraw, hhxmax ���� hhxdata �쐬)
#deffunc HHX_init_extract_db

	sdim hhxdata, 64, hhxmax, C_MAX ; �f�[�^�x�[�X�{�� (global)

	p = 0
	repeat hhxmax
		rec = cnt
		repeat C_MAX
			c = peek(hhxraw, p)
			if (c <= 31) & (c ! 9) { ; 56% (Lv 80)

				; c ���g�����k�R�[�h�̏ꍇ : ���̃o�C�g�̒l���̗p 1.5%
				if c = CMP_MN {
					p++
					c = peek(hhxraw, p)
				} ; else 55%

				; c �����g�p�R���g���[���R�[�h�̈�̏ꍇ :
				; (�f�[�^��) c �O�̃��R�[�h�̒l���R�s�[
				hhxdata.rec.cnt = hhxdata(rec-c, cnt)

			} else:if c ! C_SEP { ; 26%

				; c ! C_SEP : (�l����) ���������Ċm�ۂ��l���R�s�[
				a = instr(hhxraw, p, S_SEP)
				memexpand hhxdata.rec.cnt, a + 1
				memcpy hhxdata.rec.cnt, hhxraw, a, , p
				poke hhxdata.rec.cnt, a
				p += a
			}
				; c = C_SEP : (�l�Ȃ�) �������Ȃ� ; 17%
			p++
		loop
	loop

	; cleanup
	sindex_cached = 0 ; �����C���f�b�N�X�L���b�V�� ������
	hhxraw = 0

	return

;--------------------------------------------------
; HHX_init_rebuild_db
; hs �t�@�C������f�[�^���o
; ���[�h
;  DBR_READONLY	hs ����f�[�^���o�E�\�[�g (���Ԃ�����)
;  DBR_WRITEDB	hs ����f�[�^���o�E�\�[�g���ADB �����k���ĕۑ� (����Ɏ��Ԃ����� �o�b�N�O���E���h��������)
#deffunc HHX_init_rebuild_db int f_dbs

	; DB �ۑ����[�h?
	if (f_dbs ! DBR_WRITEDB) & (f_dbs ! DBR_READONLY) {
		dialog "�G���[ : DBR_ �p�����[�^���Ȃ�"
		return
	}


	;--------------------------------------------------
	; procedure memo

;	(DBR_WRITEDB)
;	1. hs �t�@�C������f�[�^�𒊏o���A1 �����f�[�^�x�[�X���쐬
;	2. 1 �����f�[�^�x�[�X�� UI �p�z��ɓW�J
;	3. UI �p�̒��o�V�X�e�����g�p���ăV���{�����\�[�g
;	4. �f�[�^���k�������� 2 �����f�[�^�x�[�X�쐬
;	5. 2 �����f�[�^�x�[�X��ۑ�
;	6. 2 �����f�[�^�x�[�X�� UI �p�z��ɓW�J

	; ������
	hhxmax = 0	; ���R�[�h��
	hhxraw = ""	; ���f�[�^�x�[�X �{��
	hhlen = 0	; ���f�[�^�x�[�X �T�C�Y
	memlen = 0	; hhxraw �̊m�ۃT�C�Y
	currentset_sum = HHX_diskset_sum() ; ���ꂩ�琶������� hs �Z�b�g�̃T���́A���݃f�B�X�N��̂��̂ƒu��


	;--------------------------------------------------
	; 1 �����f�[�^�x�[�X�쐬 (hs �t�@�C�� �Z�b�g����f�[�^���o)

	sdim fnlist
	dirlist fnlist, "*.hs", 3
	notesel fnlist

	sdim fn
	repeat stat
		noteget fn, cnt
		//exist fn : len = strsize
		len = exist(fn)
		if len <= 0 : continue


		; hs �t�@�C�����[�h
		sdim buf, len + 10
		bload fn, buf
		buf += "\n%index"


		; �G���R�[�h �`�F�b�N
		if IS_UTF8(buf) {
			dialog fn + " �� Unicode �ŏ�����Ă��邽�ߓǂݍ��߂܂���B", 1, "hs compiler"
			continue
		}


		; SEP �R�[�h���� (SEP -> '#')
		p = 0
		repeat
			i = instr(buf, p, S_SEP)
			if i < 0 : break
			p += i
			poke buf, p, '#'
		loop


		; �e�L�X�g�v���Z�b�T ���Z�b�g
		sdim record_default,	64, C_MAX
		sdim record,		64, C_MAX
		record.C_HSFILE = fn
		p = 0
		c_curr = C_VOID
		accum = ""


		;--------------------------------------------------
		; �e�L�X�g�v���Z�b�T

		repeat
			; �������C���擾
			getstr astr, buf, p  ,,99999
			if strsize = 0 : break
			p += strsize
			a = peek(astr)


			; '%' �G�X�P�[�v (%%hgoehgoe..)
			if wpeek(astr) = 0x2525 {
				memcpy astr, astr, strsize + 1, , 1
				a = '*'
			}


			; �t�B�[���h�^�O����
			if a = '%' {
				; �R�����g����, ��������
				getstr astr, astr, , ' '
				getstr astr, astr, , ';'
				getstr astr, astr, , 9
				CharLower astr


				; �t�B�[���h �X�g�A
				if c_curr ! C_VOID {
					; ������ CRLF ���J�b�g
					a = strlen(accum)
					if a >= 3 {
						repeat , 1
							if peek(accum, a-cnt-cnt) / 5 ! 2 {
								poke accum, a-cnt-cnt+2
								break
							}
						loop
					}

					; �������[�h
					if diffmode {
						if diffmode > 0{
							; �������[�h
							record.c_curr = note_merge(record.c_curr + "\n" + accum)
						} else {
							; ���O���[�h
							record.c_curr = note_unmerge(record.c_curr, accum)
						}
					} else {
						; ��΃��[�h (�ʏ�) - �t�B�[���h�ɒl�����̂܂ܓ����
						record.c_curr = accum
					}
				}


				; �f�t�H���g�l
				c_curr = C_VOID	; �t�B�[���h�Z���N�g
				r = 1		; ���s�t���O ���Z�b�g (= enabled)
				diffmode = 0	; �����L�q���[�h ���Z�b�g (= off)


				; ���R�[�h�J�n
				if astr = "%index" {

					; �V���{��������ꍇ
					if notnull(record.C_NAME) {
						; hhxraw �o�b�t�@�m�� (1 ���R�[�h�̐݌v���e�e�� 144kB)
						a = hhlen + 144000
						if a > memlen {
							memlen = a / 5 + a ; (�o�b�t�@�g���X�e�b�v 20%)
							memexpand hhxraw, memlen
						}
						; ���R�[�h �X�g�A
						repeat C_MAX
							a = strlen(record.cnt)
							memcpy hhxraw, record.cnt, a, hhlen
							hhlen += a
							poke hhxraw, hhlen, C_SEP
							hhlen++
						loop
						hhxmax++

					; �V���{�����Ȃ��ꍇ
					} else {
						; ���݂̃t�B�[���h�l���f�t�H���g�l�Ɛݒ�
						repeat C_MAX
							record_default.cnt = record.cnt
						loop
					}

					; �S�t�B�[���h�l���f�t�H���g�ɐݒ�
					repeat C_MAX
						record.cnt = record_default.cnt
					loop

					; �Ώۃt�B�[���h�ݒ�
					c_curr = C_NAME


				; �t�B�[���h�I��
				} else:if astr = "%prm"		{ c_curr = C_PRM	}
				else:if astr = "%inst"		{ c_curr = C_INST	}
				else:if astr = "%sample"	{ c_curr = C_SAMPLE	}
				else:if astr = "%href"		{ c_curr = C_HREF	}
				else:if astr = "%dll"		{ c_curr = C_DLL	: r = 0 }
				else:if astr = "%ver"		{ c_curr = C_VER	: r = 0 }
				else:if astr = "%date"		{ c_curr = C_DATE	}
				else:if astr = "%author"	{ c_curr = C_AUTHOR	}
				else:if astr = "%url"		{ c_curr = C_URL	}
				else:if astr = "%note"		{ c_curr = C_NOTE	}
				else:if astr = "%type"		{ c_curr = C_TYPE	: r = 0 }
				else:if astr = "%group"		{ c_curr = C_GROUP	: r = 0 }
				else:if astr = "%port"		{ c_curr = C_PORT	}
				else:if astr = "%portinfo"	{ c_curr = C_PORTINF	}
				else:if astr = "%port+"		{ c_curr = C_PORT	: diffmode =  1 }
				else:if astr = "%port-"		{ c_curr = C_PORT	: diffmode = -1 }
				else:if astr = "%href+"		{ c_curr = C_HREF	: diffmode =  1 }
				else:if astr = "%href-"		{ c_curr = C_HREF	: diffmode = -1 }
				else:if astr = "%author+"	{ c_curr = C_AUTHOR	: diffmode =  1 }
				else:if astr = "%author-"	{ c_curr = C_AUTHOR	: diffmode = -1 }
				else:if astr = "%url+"		{ c_curr = C_URL	: diffmode =  1 }
				else:if astr = "%url-"		{ c_curr = C_URL	: diffmode = -1 }


				; ���ꂩ��擾����l���󃊃Z�b�g
				poke accum ;= ""

				continue
			}


			; ���������o�ƃR�����g
			if (c_curr = C_VOID) | (a = ';') {
				continue
			}


			; �^�O�s����s�ɕϊ�
			if (a = '^') : if (astr="^") | (astr="^p") | (astr="^P") {
				poke astr ;= ""
			}


			; �s �ǉ�
			if notnull(accum) * r {
				accum += "\n" + astr
			} else {
				accum += astr
			}


			; �����o�ŗL�̏���
			if notnull(accum) {
				; %index  2 �s�ڈȍ~�� summary �Ɉڍs
				if c_curr = C_NAME {
					record.c_curr = accum	; �X�g�A
					poke accum ;= ""	; accum ���Z�b�g

					c_curr = C_SUMMARY
					r = 0
				}

				; %prm  2 �s�ڈȍ~�� prm2 �Ɉڍs
				if c_curr = C_PRM {
					record.c_curr = accum	; �X�g�A
					poke accum ;= ""	; accum ���Z�b�g

					c_curr = C_PRM2
					r = 1
				}
			}
		loop
	loop


	;--------------------------------------------------
	; 1 �����f�[�^�x�[�X��z��W�J (1 �����f�[�^�x�[�X ����)
	; �z���� DB ���\�[�g

	HHX_init_extract_db		; �f�[�^�x�[�X �z��ɓW�J
	results = HHX_select_all()	; ���ׂẴ��R�[�h�𒊏o
	HHX_order_by C_NAME		; ���R�[�h�Z�b�g �V���{�����Ń\�[�g


	;--------------------------------------------------
	; DB �ۑ����Ȃ����[�h�̏ꍇ : �\�[�g�ςݔz�����������ɍ쐬���Ċ���

	if f_dbs = DBR_READONLY {
		; �W�J�ς݃f�[�^���������בւ�
		sdim tmpdata, 64, results
		repeat C_MAX
			fld = cnt
			repeat results
				tmpdata.cnt = hhxdata(find_list(cnt), fld)
			loop
			repeat results
				hhxdata(cnt, fld) = tmpdata.cnt
			loop
		loop
		sdim tmpdata
		return
		;--------------------------------------------------> return
	}


	;--------------------------------------------------
	; 2 �����f�[�^�x�[�X�̍쐬 (�\�[�g�E���k���ꂽ�f�[�^�x�[�X���쐬)

	sdim hhxraw, hhlen + 8		; 2 �����f�[�^�x�[�X�p �o�b�t�@�m��

	; [�t�B�[���h���̈��k���x���ݒ�]
	dim enc_level, CMP_MAX

	p = 0
	repeat results
		c = cnt
		id = find_list(c)
		repeat C_MAX
			fld = cnt
			tmp = hhxdata(id, fld) + S_SEP

			; === ���k ===

			; [�������̂��߁A�T����󂭂��Ă���]
			enc_level.fld = limit(enc_level.fld - 5, 15, CMP_MAX)

			if notnull( hhxdata(id, fld) ) {
				; �T��
				repeat limit(c, 0, enc_level.fld), 1
					; ���g�p�̃R���g���[���R�[�h�̈�𗘗p���āA�����O�̃��R�[�h�œ����l�������������L�^
					;  (�g�p�R���g���[���R�[�h 9 (TAB) �����O) (���Ȃ݂� CR, LF �͓��ɂ͏o�����Ȃ����ߎg�p�\)
					if cnt ! 9 {
						if hhxdata(id, fld) = hhxdata( find_list(c - cnt), fld) {
							; 31 �ȏ�O�̃��R�[�h�́A�g�����k�R�[�h���g���Ďw��
							if cnt < CMP_MN {
								wpoke tmp, , cnt	; ����ɂ��A1�`CMP_MN-1 �̈��k�R�[�h�� 1 �o�C�g�A
							} else {
								wpoke tmp, 0, CMP_MN	;  CMP_MN�`CMP_MAX �̈��k�R�[�h�� 2 �o�C�g�ƂȂ�
								wpoke tmp, 1, cnt
							}
							; �܂��A�g���R�[�h�ł̈��k�ʂȂ񂼋͂��Ȃ���ł���

							enc_level.fld += 20 ; [���k�\�ȃt�B�[���h�͒T�����x�����グ��]
							break
						}
					}
				loop
			}

			; 2 �����f�[�^�x�[�X�ɒǉ� (���������񌋍�)
			a = strlen(tmp)
			memcpy hhxraw, tmp, a, p
			p += a
		loop
	loop

	len = strlen(hhxraw)


	;--------------------------------------------------
	; �ۑ�

	; 2 �����f�[�^�x�[�X�Ƀ^�O�l (hhxmax, checksum) �ǉ�
	lpoke hhxraw, len,	results
	lpoke hhxraw, len+4,	currentset_sum

	; �f�B�X�N�ɕۑ�
	if len : bsave DBFILE, hhxraw, len + 8


	HHX_init_extract_db	; �\�[�g�ς� DB ��z��ɓW�J

	return


#global
	
	Initialize@mHsDatabase



;============================================================
; �e�X�g�}�l�[�W��

#if 0
	#include "hhx_lib.hsp"

	;>> chdir
	astr = "hsphelp"
	dirlist buf, astr, 5
	if stat : chdir astr

	;--------------------------------------------------
	; HHX �f�[�^�x�[�X ���[�h�V�[�P���X

	mes "loading..."
	HHX_init_load_db
	if HHX_currentset_sum() ! HHX_diskset_sum() {
		mes "rebuilding db..."
B_ST
		HHX_init_rebuild_db DBR_READONLY ;DBR_WRITEDB
B_EN
	} else {
		HHX_init_extract_db
	}

	;--------------------------------------------------
	; GUI �I�u�W�F�N�g�쐬

	lst = 0  : lstbk = -1
	inp = "" : inpbk = "/"
	astr = ""
	cls
	objsize 200, 20  : input inp
	objsize 200, 460 : listbox lst, 0, astr
	pos 200, 0       : mesbox astr, 440, 480, 0

	;--------------------------------------------------
	; ���C�����[�v

	repeat
		if inp ! inpbk {
			inpbk = inp
			lst = 0 : lstbk = -1
			astr = ""
			if inp = "" : a = HHX_select_all() : else : a = HHX_select_where(inp, -1, -1)
			repeat a
				c = HHX_get_next()
				list.cnt = c
				astr += hhxdata(c, C_NAME) + " - " + hhxdata(c, C_SUMMARY) + "\n"
			loop
			objprm 1, astr
			objprm 1, lst
		}
		if lst ! lstbk {
			lstbk = lst
			astr = hhxdata(list.lst, C_NAME) + " " + hhxdata(list.lst, C_PRM)
			title astr + " - HHX TEST"
			astr += "\n\n" + hhxdata(list.lst, C_PRM2)
			astr += "\n\n<����>\n\n" + hhxdata(list.lst, C_INST)
			objprm 2, astr
		}
		wait 1
	loop
#endif


