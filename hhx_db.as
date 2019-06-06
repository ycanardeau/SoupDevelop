
;============================================================
;                                                 2007/xx/xx
;	S.Programs HHX
;	hs database module
;                               http://sprocket.babyblue.jp/
;============================================================
; hs ファイル仕様 2.0 対応 hs データベースモジュール (HSP3)


;============================================================
; フィールド定義 (global)
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
#define global	C_HSFILE	16	; hs ファイル名
#define global	C_AUTHOR	17	; %author
#define global	C_MAX		18	; 配列の最大値
#define global	C_VOID		999	; (無効なメンバ)
; (若い数字ほどキーワード適合度への重みが大きい)


;------------------------------------------------------------
; notnull(string_var)
#define global ctype notnull(%1) peek(%1)



;============================================================
; note_merge モジュール

#module

;--------------------------------------------------
; 文字列マージ (重複行カット) (改行区切り)
; prm : note
#defcfunc note_merge str st1_

	; ソース = 連結した文字列
	st1 = st1_
	oup = ""

	astr = "" ;sdim astr, 64, 64
	c = 0

	; 連結した文字列の各行を配列に分解
	p = 0
	repeat
		getstr astr.c, st1, p  ,,99999
		if strsize = 0 : break
		c++
		p += strsize
	loop

	; 重複行が無いように文字列を再構成
	repeat c
		c = cnt
		repeat c + 1
			if cnt = c {
				if notnull(oup) : oup += "\n"
				oup += astr.c
				break
			}
			if astr.cnt = astr.c { ; 重複する行は除外
				break
			}
		loop
	loop

	return oup

;--------------------------------------------------
; 文字列アンマージ (改行区切り)
; prm : note_default, note_sub
#defcfunc note_unmerge str st1_, str st2_

	st1 = st1_
	st2 = st2_
	oup = ""

	astr = "" ;sdim astr, 64, 64
	c = 0

	; 除外する文字列を配列に分解
	p = 0
	repeat ; sub
		getstr astr.c, st2, p  ,,99999
		if strsize = 0 : break
		c++
		p += strsize
	loop

	; 除外文字列を除去しながらソース文字列を再構成
	p = 0
	sdim bstr
	repeat ; src2
		getstr bstr, st1, p  ,,99999
		if strsize = 0 : break
		p += strsize

		repeat c
			if bstr = astr.cnt { ; sub 文字列に含まれる行は除外
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
; HHX データベースモジュール メイン

#module mHsDatabase

; config
#define	global DBFILE	"hhx.db"
#define	global DBVER	0x210c00
#define	CMP_MAX	255	; 圧縮 最大スライド数 (0 - 255)
#define	CMP_MN	31	; 拡張圧縮コード

; global var
#define global hhxdata hhxdatax@

; const
#define	C_SEP	0x7f
#define	S_SEP	""	; 0x7f
#define	CRLF	0x0A0D
#define global DBR_WRITEDB	444	; HHX_init_rebuild_db パラメータ : DB 保存モード
#define global DBR_READONLY	555	; DB 保存しないモード

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

; UTF BOM 判別
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
; hhxdata を標準文字列 (org を小文字に変換したもの) で返す
#defcfunc hhxnorm int pr1, int pr2
	NormalStr hhxnormv, hhxdata.pr1.pr2 ; 被検索文字列 標準化
	return hhxnormv

;--------------------------------------------------
; (results) HHX_select_all()
; レコードセットとしてすべてのレコードを列挙
#defcfunc HHX_select_all

	; 検索結果 数列作成 (= 全て)
	find_cur = -1		; HHX_get_next 用
	finds = hhxmax		; 全て
	repeat hhxmax
		find_list(cnt) = cnt
	loop

	return finds

;--------------------------------------------------
; (results) HHX_select_where("検索文字列", 完全一致フィールド, 除外 ID)
; レコードセットとして検索条件にマッチするレコードを列挙 出力順は検索キーワードとの適合度順
#defcfunc HHX_select_where  str q, int c_equal, int ngid

	;--------------------------------------------------
	; init

	find_cur = -1		; HHX_get_next 用
	query = q
	CharLower varptr(query)		; 検索文字列 標準化
	dim evals, hhxmax	; 評価値テーブル初期化


	;--------------------------------------------------
	; 完全一致フィールドを要求された場合

	if c_equal >= 0 {
		finds = 0	; 見つかった総数
		repeat hhxmax
			if hhxnorm(cnt, c_equal) = query {
				find_list(finds) = cnt
				finds++
			}
		loop
		return finds
	}


	;--------------------------------------------------
	; 検索 (絞込み)

	; 検索キーワードを配列に列挙
	sdim cmpstr, 64, 64
	kwds = 0
	p = 0
	repeat
		; query スペース区切り出し
		getstr cmpstr.kwds, query, p, ' '
		if strsize = 0 : break
		p += strsize
		if notnull(cmpstr.kwds) : kwds++
	loop

	; クエリにキーワードが含まれていなかったら : 検索結果 0 件
	if kwds = 0 : return 0

	; 検索用標準文字列 作成
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

	; AND 検索
	repeat hhxmax
		id = cnt
		if id = ngid : continue ; NG ID 除外
		sxlen = strlen(sindex.id)

		repeat kwds
			astr = cmpstr.cnt

			; NOT 検索
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

			; AND 検索
			a = 0 ; eval
			p = 0
			repeat 3 ; (先頭から i 回まで探索)
				i = instr(sindex.id, p, astr)
				if i >= 0 {
					p += i

					; 単語単位でのマッチを優先するよう n を設定
					n = 1000
					c = peek(sindex.id, p + strlen(astr))
					if (c >= '_' & c <= 'z') {
						n = 400
					} else:if i {
						c = peek(sindex.id, p - 1)
						if (c >= '_' & c <= 'z') : n = 400
					}

					; 評価員 A
					b = int( (cos(limitf(4.0 * p / sxlen + 0.2, 0, 3)) + 1) * n / 2 )
					if b > a : a = b ; eval 最大値を採用

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

		; test 評価値表示
	;	hhxdata.id.0 += "~"
	;	poke hhxdata.id.0, instr(hhxdata.id.0, 0, "~")
	;	hhxdata.id.0 += "~"+evals(id)
	loop


	;--------------------------------------------------
	; evals ソート済み ID 数列 find_list 作成

	max = 0 ; 評価の最大値

	; ソート前 find_list 作成
	finds = 0		; 見つかった総数
	repeat hhxmax
		if evals(cnt) {
			find_list(finds) = cnt
			finds++

			if evals(cnt) > max : max = evals(cnt)
		}
	loop

	; 二進基数ソート (降順) (max : 31bit)
	; (高速化のため、必要最低限の回数 (1+logf(max)/logf(2)) 実行)

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

		; 連結
		memcpy find_list, blst, b * 4, a * 4
	loop


	return finds

;--------------------------------------------------
; HHX_order_by (対象フィールド)
; 現在のレコードセットの出力順番を変更 (昇順ソート)
#deffunc HHX_order_by int prm_fld

	#define ar find_list	; ソート対象
	len = finds		; ソート長さ
	dim tr, len ; temp arry


	;--------------------------------------------------
	; ソート用標準文字列配列 作成

	sdim tmpnorm, 64, hhxmax
	repeat len
		tmpnorm(ar(cnt)) = hhxdata(ar(cnt), prm_fld)
		CharLower tmpnorm(ar(cnt))
	loop


	;--------------------------------------------------
	; マージソート (ボトムアップ型)
	
	repeat
		; セグメントサイズ定義
		n = 1 << cnt	; マージサイズ
		m = n * 2	; セグメント サイズ

		; 全セグメントに対して
		repeat
			; セグメント 領域定義
			p  = m * cnt			; セグメント開始点
			p1 = p				; パート 1 開始点
			e1 = p1 + n			; パート 1 終了点
			p2 = e1				; パート 2 開始点
			e2 = limit(p2 + n, 0, len)	; パート 2 終了点 (clipping)
			s  = e2 - p1			; セグメント サイズ

			if s <= n : break		; セグメント サイズが閾値以下なら マージしない

			; セグメント内 マージ
			repeat s
				if p2 >= e2 { ; p2 領域外
					tr(cnt) = ar(p1) : p1++
				} else:if p1 >= e1 { ; p1 領域外
					tr(cnt) = ar(p2) : p2++

				; 比較 & マージ (Core)
				} else:if (tmpnorm(ar(p1)) ! tmpnorm(ar(p2))) <= 0 {
					tr(cnt) = ar(p1) : p1++
				} else {
					tr(cnt) = ar(p2) : p2++
				}
			loop

			; マージされたセグメントを元の配列に貼り付け
			memcpy ar(p), tr, s * 4
		loop

		; ソート 完了
		if n >= len : break
	loop

	find_cur = -1

	return

;--------------------------------------------------
; (id) HHX_get_next()
; レコードセットの次のレコードの ID を求める
#defcfunc HHX_get_next
	find_cur++
	return find_list(find_cur)

;--------------------------------------------------
; (id) HHX_exist( "検索シンボル" )
; シンボルを高速に検索 (二分探索)
#defcfunc HHX_exist  str q

	r = -1 ; return value
	if hhxmax = 0 : return r
	query = q
	CharLower query ; 検索文字列 標準化

	;--------------------------------------------------
	; 二分探索 (フィールド C_NAME でソートされていることが前提)

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
; 現在オンメモリの hs セットのチェックサムを返す
#defcfunc HHX_currentset_sum
	return currentset_sum

;--------------------------------------------------
; (int) HHX_diskset_sum()
; ディスク上の hs ファイル セットのチェックサムを求める
#defcfunc HHX_diskset_sum

	; hs ファイル
	; 日付 / サイズ / DBVER チェックサム

	dim win32_find_data, 80 ; (struct WIN32_FIND_DATA)
	sum = DBVER
	h = FindFirstFileA("*.hs", varptr(win32_find_data))

	if h {
		repeat
			; sum 算出 (入力順非依存)
			; 5:dwLowDateTime, 6:dwHighDateTime // (ftLastWriteTime) 100ns 単位, 64bit
			; 7:nFileSizeHigh, 8:nFileSizeLow
			sum += win32_find_data.5 * win32_find_data.8

			; 次のファイル
			if FindNextFileA(h, varptr(win32_find_data)) = 0 {
				break ; ファイル検索終了
			}
		loop

		a = FindClose(h)
	}

	return sum & 0x00ffffff ; 24bit に制限

;--------------------------------------------------
; HHX_init_load_db
; ディスクからデータベース キャッシュをロード
#deffunc HHX_init_load_db

	; どっか用の初期化
	sdim hhxnormv, 65536

	currentset_sum = 0

	//exist DBFILE
	if /*strsize*/exist(DBFILE) >= 8 {
		len = stat
		sdim hhxraw, len
		bload DBFILE, hhxraw

		currentset_sum	= lpeek(hhxraw, len - 4) ; hs セットのチェックサム
		hhxmax		= lpeek(hhxraw, len - 8) ; hs セットのレコード数
	}

	return

;--------------------------------------------------
; HHX_init_extract_db
; メモリ上の生データベースを配列に展開 (hhxraw, hhxmax から hhxdata 作成)
#deffunc HHX_init_extract_db

	sdim hhxdata, 64, hhxmax, C_MAX ; データベース本体 (global)

	p = 0
	repeat hhxmax
		rec = cnt
		repeat C_MAX
			c = peek(hhxraw, p)
			if (c <= 31) & (c ! 9) { ; 56% (Lv 80)

				; c が拡張圧縮コードの場合 : 次のバイトの値を採用 1.5%
				if c = CMP_MN {
					p++
					c = peek(hhxraw, p)
				} ; else 55%

				; c が未使用コントロールコード領域の場合 :
				; (データ解凍) c 個前のレコードの値をコピー
				hhxdata.rec.cnt = hhxdata(rec-c, cnt)

			} else:if c ! C_SEP { ; 26%

				; c ! C_SEP : (値あり) メモリを再確保し値をコピー
				a = instr(hhxraw, p, S_SEP)
				memexpand hhxdata.rec.cnt, a + 1
				memcpy hhxdata.rec.cnt, hhxraw, a, , p
				poke hhxdata.rec.cnt, a
				p += a
			}
				; c = C_SEP : (値なし) 何もしない ; 17%
			p++
		loop
	loop

	; cleanup
	sindex_cached = 0 ; 検索インデックスキャッシュ 無効化
	hhxraw = 0

	return

;--------------------------------------------------
; HHX_init_rebuild_db
; hs ファイルからデータ抽出
; モード
;  DBR_READONLY	hs からデータ抽出・ソート (時間かかる)
;  DBR_WRITEDB	hs からデータ抽出・ソートし、DB を圧縮して保存 (さらに時間かかる バックグラウンド処理向き)
#deffunc HHX_init_rebuild_db int f_dbs

	; DB 保存モード?
	if (f_dbs ! DBR_WRITEDB) & (f_dbs ! DBR_READONLY) {
		dialog "エラー : DBR_ パラメータがない"
		return
	}


	;--------------------------------------------------
	; procedure memo

;	(DBR_WRITEDB)
;	1. hs ファイルからデータを抽出し、1 次生データベースを作成
;	2. 1 次生データベースを UI 用配列に展開
;	3. UI 用の抽出システムを使用してシンボル名ソート
;	4. データ圧縮をかけて 2 次生データベース作成
;	5. 2 次生データベースを保存
;	6. 2 次生データベースを UI 用配列に展開

	; 初期化
	hhxmax = 0	; レコード数
	hhxraw = ""	; 生データベース 本体
	hhlen = 0	; 生データベース サイズ
	memlen = 0	; hhxraw の確保サイズ
	currentset_sum = HHX_diskset_sum() ; これから生成される hs セットのサムは、現在ディスク上のものと置く


	;--------------------------------------------------
	; 1 次生データベース作成 (hs ファイル セットからデータ抽出)

	sdim fnlist
	dirlist fnlist, "*.hs", 3
	notesel fnlist

	sdim fn
	repeat stat
		noteget fn, cnt
		//exist fn : len = strsize
		len = exist(fn)
		if len <= 0 : continue


		; hs ファイルロード
		sdim buf, len + 10
		bload fn, buf
		buf += "\n%index"


		; エンコード チェック
		if IS_UTF8(buf) {
			dialog fn + " は Unicode で書かれているため読み込めません。", 1, "hs compiler"
			continue
		}


		; SEP コード除け (SEP -> '#')
		p = 0
		repeat
			i = instr(buf, p, S_SEP)
			if i < 0 : break
			p += i
			poke buf, p, '#'
		loop


		; テキストプロセッサ リセット
		sdim record_default,	64, C_MAX
		sdim record,		64, C_MAX
		record.C_HSFILE = fn
		p = 0
		c_curr = C_VOID
		accum = ""


		;--------------------------------------------------
		; テキストプロセッサ

		repeat
			; 処理ライン取得
			getstr astr, buf, p  ,,99999
			if strsize = 0 : break
			p += strsize
			a = peek(astr)


			; '%' エスケープ (%%hgoehgoe..)
			if wpeek(astr) = 0x2525 {
				memcpy astr, astr, strsize + 1, , 1
				a = '*'
			}


			; フィールドタグ処理
			if a = '%' {
				; コメント除去, 小文字化
				getstr astr, astr, , ' '
				getstr astr, astr, , ';'
				getstr astr, astr, , 9
				CharLower astr


				; フィールド ストア
				if c_curr ! C_VOID {
					; 末尾の CRLF をカット
					a = strlen(accum)
					if a >= 3 {
						repeat , 1
							if peek(accum, a-cnt-cnt) / 5 ! 2 {
								poke accum, a-cnt-cnt+2
								break
							}
						loop
					}

					; 結合モード
					if diffmode {
						if diffmode > 0{
							; 統合モード
							record.c_curr = note_merge(record.c_curr + "\n" + accum)
						} else {
							; 除外モード
							record.c_curr = note_unmerge(record.c_curr, accum)
						}
					} else {
						; 絶対モード (通常) - フィールドに値をそのまま入れる
						record.c_curr = accum
					}
				}


				; デフォルト値
				c_curr = C_VOID	; フィールドセレクト
				r = 1		; 改行可フラグ リセット (= enabled)
				diffmode = 0	; 差分記述モード リセット (= off)


				; レコード開始
				if astr = "%index" {

					; シンボルがある場合
					if notnull(record.C_NAME) {
						; hhxraw バッファ確保 (1 レコードの設計許容容量 144kB)
						a = hhlen + 144000
						if a > memlen {
							memlen = a / 5 + a ; (バッファ拡張ステップ 20%)
							memexpand hhxraw, memlen
						}
						; レコード ストア
						repeat C_MAX
							a = strlen(record.cnt)
							memcpy hhxraw, record.cnt, a, hhlen
							hhlen += a
							poke hhxraw, hhlen, C_SEP
							hhlen++
						loop
						hhxmax++

					; シンボルがない場合
					} else {
						; 現在のフィールド値をデフォルト値と設定
						repeat C_MAX
							record_default.cnt = record.cnt
						loop
					}

					; 全フィールド値をデフォルトに設定
					repeat C_MAX
						record.cnt = record_default.cnt
					loop

					; 対象フィールド設定
					c_curr = C_NAME


				; フィールド選択
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


				; これから取得する値を空リセット
				poke accum ;= ""

				continue
			}


			; 無効メンバとコメント
			if (c_curr = C_VOID) | (a = ';') {
				continue
			}


			; タグ行を空行に変換
			if (a = '^') : if (astr="^") | (astr="^p") | (astr="^P") {
				poke astr ;= ""
			}


			; 行 追加
			if notnull(accum) * r {
				accum += "\n" + astr
			} else {
				accum += astr
			}


			; メンバ固有の処理
			if notnull(accum) {
				; %index  2 行目以降は summary に移行
				if c_curr = C_NAME {
					record.c_curr = accum	; ストア
					poke accum ;= ""	; accum リセット

					c_curr = C_SUMMARY
					r = 0
				}

				; %prm  2 行目以降は prm2 に移行
				if c_curr = C_PRM {
					record.c_curr = accum	; ストア
					poke accum ;= ""	; accum リセット

					c_curr = C_PRM2
					r = 1
				}
			}
		loop
	loop


	;--------------------------------------------------
	; 1 次生データベースを配列展開 (1 次生データベース 消滅)
	; 配列上の DB をソート

	HHX_init_extract_db		; データベース 配列に展開
	results = HHX_select_all()	; すべてのレコードを抽出
	HHX_order_by C_NAME		; レコードセット シンボル名でソート


	;--------------------------------------------------
	; DB 保存しないモードの場合 : ソート済み配列をメモリ上に作成して完了

	if f_dbs = DBR_READONLY {
		; 展開済みデータを強制並べ替え
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
	; 2 次生データベースの作成 (ソート・圧縮されたデータベースを作成)

	sdim hhxraw, hhlen + 8		; 2 次生データベース用 バッファ確保

	; [フィールド毎の圧縮レベル設定]
	dim enc_level, CMP_MAX

	p = 0
	repeat results
		c = cnt
		id = find_list(c)
		repeat C_MAX
			fld = cnt
			tmp = hhxdata(id, fld) + S_SEP

			; === 圧縮 ===

			; [効率化のため、探索を浅くしていく]
			enc_level.fld = limit(enc_level.fld - 5, 15, CMP_MAX)

			if notnull( hhxdata(id, fld) ) {
				; 探索
				repeat limit(c, 0, enc_level.fld), 1
					; 未使用のコントロールコード領域を利用して、いくつ前のレコードで同じ値があったかを記録
					;  (使用コントロールコード 9 (TAB) を除外) (ちなみに CR, LF は頭には出現しないため使用可能)
					if cnt ! 9 {
						if hhxdata(id, fld) = hhxdata( find_list(c - cnt), fld) {
							; 31 以上前のレコードは、拡張圧縮コードを使って指定
							if cnt < CMP_MN {
								wpoke tmp, , cnt	; これにより、1～CMP_MN-1 の圧縮コードは 1 バイト、
							} else {
								wpoke tmp, 0, CMP_MN	;  CMP_MN～CMP_MAX の圧縮コードは 2 バイトとなる
								wpoke tmp, 1, cnt
							}
							; まあ、拡張コードでの圧縮量なんぞ僅かなもんですが

							enc_level.fld += 20 ; [圧縮可能なフィールドは探索レベルを上げる]
							break
						}
					}
				loop
			}

			; 2 次生データベースに追加 (高速文字列結合)
			a = strlen(tmp)
			memcpy hhxraw, tmp, a, p
			p += a
		loop
	loop

	len = strlen(hhxraw)


	;--------------------------------------------------
	; 保存

	; 2 次生データベースにタグ値 (hhxmax, checksum) 追加
	lpoke hhxraw, len,	results
	lpoke hhxraw, len+4,	currentset_sum

	; ディスクに保存
	if len : bsave DBFILE, hhxraw, len + 8


	HHX_init_extract_db	; ソート済み DB を配列に展開

	return


#global
	
	Initialize@mHsDatabase



;============================================================
; テストマネージャ

#if 0
	#include "hhx_lib.hsp"

	;>> chdir
	astr = "hsphelp"
	dirlist buf, astr, 5
	if stat : chdir astr

	;--------------------------------------------------
	; HHX データベース ロードシーケンス

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
	; GUI オブジェクト作成

	lst = 0  : lstbk = -1
	inp = "" : inpbk = "/"
	astr = ""
	cls
	objsize 200, 20  : input inp
	objsize 200, 460 : listbox lst, 0, astr
	pos 200, 0       : mesbox astr, 440, 480, 0

	;--------------------------------------------------
	; メインループ

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
			astr += "\n\n<説明>\n\n" + hhxdata(list.lst, C_INST)
			objprm 2, astr
		}
		wait 1
	loop
#endif


