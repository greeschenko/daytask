setlocal foldmethod=indent
"setlocal foldmethod=expr
"setlocal foldexpr=GetPotionFold(v:lnum)

"function! GetPotionFold(lnum)
    "if getline(v:lnum)[0] == "\t"
        "return '-1'
    "endif

    "return 0
"endfunction
