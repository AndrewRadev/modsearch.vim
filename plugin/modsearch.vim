if exists('g:loaded_modsearch') || &cp
  finish
endif

let g:loaded_modsearch = '0.0.1' " version number
let s:keepcpo = &cpo
set cpo&vim

command! -nargs=+ -complete=custom,modsearch#Complete Modsearch call modsearch#Main(<f-args>)

let &cpo = s:keepcpo
unlet s:keepcpo
