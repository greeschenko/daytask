
if exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'task'
endif

"au BufRead *.task set filetype=task
"au BufRead *.task nmap <leader>d $^i+<esc>

syn clear
syn region pythonFunction start=/[^\s]/ end=/$/
syn region String start=/\s\{4}/ end=/$/
syn region Normal start=/ \{8\}/ end=/$/
syn region Comment start=/\s*+/ end=/$/
syn region Error start=/\s*!/ end=/$/
syn region Constant start=/\s*0/ end=/$/
hi Comment cterm=italic gui=italic
