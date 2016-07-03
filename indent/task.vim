setlocal indentexpr=TaskIndentGet(v:lnum)
setlocal indentkeys=o,O,*<Return>,<>>,{,},!^F

fun! TaskIndentGet(lnum)
    " Find a non-empty line above the current line.
    let lnum = prevnonblank(a:lnum - 1)

    " Hit the start of the file, use zero indent.
    if lnum == 0
        return 0
    endif

    let lind = indent(lnum)

    "return lind + (&sw * ind)
    return lind
endfun
