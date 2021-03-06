
; @author eller
; @url http://rpen.blogspot.jp/2007/12/blog-post_16.html

#module mod_String
#const EXPAND_SIZE 1024
// 文字列の初期値を設定する
#deffunc StringSet str str_to_set
    string_length = strlen(str_to_set)
;   string_size = EXPAND_SIZE * (1 + string_length / EXPAND_SIZE)
    string_size = 64            // 測定のために公平化
    sdim string, string_size
    poke string, 0, str_to_set
    return

// 文字列を返す
#deffunc StringGet var target
    target = string
    return

// 文字列の長さを返す
#defcfunc StringGetLength
    return string_length

// 文字列を連結する
#deffunc StringAdd str str_to_add
    len = strlen(str_to_add)
    if string_size <= string_length + len {
        string_size += EXPAND_SIZE
        memexpand string, string_size
    }
    poke string, string_length, str_to_add
    string_length += len
    return
#global