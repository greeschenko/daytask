au BufRead *.dt set filetype=task
au BufRead *.dt set shiftwidth=2
au BufRead *.dt set softtabstop=2
au BufRead *.dt set tabstop=2
au BufRead *.dt set foldcolumn=0
au BufRead *.dt set nonumber
au BufRead *.dt set norelativenumber
"au BufRead *.dt nmap <leader>V :call DtGetObject()<CR>
au BufRead *.dt nmap <leader>j :call DtMoveDown()<CR>
au BufRead *.dt nmap <leader>k :call DtMoveUp()<CR>
au BufRead *.dt nmap <leader>i :call DtInWork()<CR>
"nmap <leader>d $^i+<esc>
au BufRead *.dt nmap <leader>d :call DtDone()<esc>
au BufRead *.dt imap [ []<LEFT>

fun! DayTaskConstruct()
    sp someday.dt
    vsp tommorow.dt
    vsp today.dt
    vsp inbox.dt
    drop day.dt
    40vsp plan.dt
endfun

fun! NewDayTaskConstruct()
    sp done.dt
    vsp inwork.dt
    vsp projects.dt
    drop day.dt
endfun

fun! DtDone()
    let lnum = line('.')
    normal $^i+
    let str = getline(lnum)
    if expand('%:t') == 'inwork.dt'
        drop done.dt
        call append(1, str)
        drop inwork.dt
        normal dd
        normal dd
    else
        echo 'is not inwork'
    endif
endf

fun! DtMoveUp()
    let lnum = line('.')
    let prevl = DtPrev(lnum)
    if prevl > 0
        let list = DtGetObject(lnum)
        let prevl = prevl - 1
        execute list[0].",".list[1]."m ".prevl
        normal zO
        for i in range(list[1]-list[0])
            normal k
        endfor
        normal 0
    else
        echo "imposible not found prev obj"
    endif
endf

fun! DtMoveDown()
    let lnum = line('.')
    let nextl = DtNext(lnum)
    if nextl > 0
        let list = DtGetObject(lnum)
        let nextlist = DtGetObject(nextl)
        execute list[0].",".list[1]."m ".nextlist[1]
        normal zO
        for i in range(list[1]-list[0])
            normal k
        endfor
        normal 0
    else
        echo "imposible not found next obj"
    endif
endf

fun! DtNext(lnum)
    let lnum = a:lnum
    let list = DtGetObject(lnum)
    let lvl = DtSelfFoldLvl(list[0])
    let nlvl = DtSelfFoldLvl(list[1]+1)
    if lvl != 0
        if lvl == nlvl
            return list[1]+1
        endif
    endif

    return 0
endf

fun! DtPrev(lnum)
    let lnum = a:lnum
    let lvl = DtSelfFoldLvl(lnum)
    let plvl = DtSelfFoldLvl(lnum-1)
    if lvl != 0 && plvl != 0
        if plvl == lvl
            return lnum-1
        else
            for i in range(1,500)
                if DtSelfFoldLvl(lnum-i) == lvl
                    return lnum-i
                endif
            endfor
        endif
    endif

    return 0
endf

fun! DtParent(lnum)
    let lnum = a:lnum
    let lvl = DtSelfFoldLvl(lnum)
    let plvl = DtSelfFoldLvl(lnum-1)
    if lvl != 0
        if plvl == 0
            return lnum-1
        endif
        if plvl < lvl
            return lnum-1
        else
            for i in range(1,500)
                if DtSelfFoldLvl(lnum-i) < lvl
                    return lnum-i
                endif
            endfor
        endif
    endif

    return 0
endf

fun! DtSelfFoldLvl(lnum)
    let a:c = 0
    let a:oldi = 0
    for i in range(1,30,2)
        if getline(a:lnum)[a:oldi:i] == "  "
            let a:c += 1
            let a:oldi = i + 1
        else
            break
        endif
    endfor
    return a:c
endf

fun! DtGetObject(lnum)
    let lnum = a:lnum
    let a:n = 0
    let a:mainlvl = DtSelfFoldLvl(lnum)
    for i in range(1,100)
        let a:curlvl = DtSelfFoldLvl(lnum+i)
        if a:curlvl > a:mainlvl
            let a:n += 1
        else
            break
        endif
    endfor

    return [lnum,lnum+a:n]
endf

fun! DtInWork()
    let lnum = line('.')
    let str = DtGenLink(lnum)
    let slvl = DtSelfFoldLvl(lnum)
    let list = DtGetObject(lnum)
    if slvl != 0
        if list[1] - list[0] == 0
            if getline(lnum)[(slvl*2):(slvl*2)] != '+'
                if getline(lnum)[(slvl*2):(slvl*2+2)] != '[w]'
                    drop inwork.dt
                    call append(0, ' ')
                    call append(0, str)
                    drop projects.dt
                    normal ^i[w
                    normal ^
                else
                    echo "imposible obj allredy inwork"
                endif
            else
                echo "imposible obj is done"
            endif
        else
            echo "imposible obj have childrens"
        endif
    else
        echo "imposible move to inwork root obj"
    endif
endf

fun! DtGenLink(lnum)
    let lnum = a:lnum
    let list = []
    call add(list,getline(lnum))
    for i in range(1,500)
        let lnum = DtParent(lnum)
        call add(list,getline(lnum))
        if DtSelfFoldLvl(lnum) == 0
            break
        endif
    endfor
    return join(reverse(list), '>>')
endf
