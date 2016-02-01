if exists('g:loaded_modsearch') || &cp
  finish
endif

let g:loaded_modsearch = '0.0.1' " version number
let s:keepcpo = &cpo
set cpo&vim

" TODO Shortcuts to the commands
" TODO Custom commands -> point to functions, combinations of functions/other mods?
" TODO Camelcase, underscore? +Camelcase, +underscore?

command! -nargs=+ -complete=custom,modsearch#Complete Modsearch call modsearch#Main(<f-args>)

let &cpo = s:keepcpo
unlet s:keepcpo
