au BufRead *.dt set filetype=task
au BufRead *.dt set shiftwidth=2
au BufRead *.dt set softtabstop=2
au BufRead *.dt set tabstop=2
au BufRead *.dt set foldcolumn=0
au BufRead *.dt set nonumber
au BufRead *.dt set norelativenumber
au BufRead *.dt nmap <leader>V :call DtGetObject()<CR>
au BufRead *.dt nmap <leader>j :call DtMoveDown()<CR>
au BufRead *.dt nmap <leader>k :call DtMoveUp()<CR>

fun! DayTaskConstruct()
    sp someday.dt
    vsp tommorow.dt
    vsp today.dt
    vsp inbox.dt
    drop day.dt
    40vsp plan.dt
endfun

fun! NewDayTaskConstruct()
    sp suspended.dt
    vsp inwokr.dt
    vsp projects.dt
    drop day.dt
endfun

fun! DtMoveUp()
    echo "moveup"
endf

fun! DtMoveDown()
    echo "movedown"
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

fun! DtGetObject()
    let lnum = line('.')
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
    call cursor(lnum,0)
    normal V
    call cursor(lnum+a:n,0)
endf
