au BufRead *.dt set filetype=task

fun! DayTaskConstruct()
    sp someday.dt
    vsp tommorow.dt
    vsp today.dt
    vsp inbox.dt
    drop day.dt
    40vsp plan.dt
endfun


