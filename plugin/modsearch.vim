if exists('g:loaded_modsearch') || &cp
  finish
endif

let g:loaded_modsearch = '0.0.1' " version number
let s:keepcpo = &cpo
set cpo&vim

let g:modsearch_mods = {
      \ 'word':                  ['function', 'modsearch#mods#WrapWord'],
      \ 'unword':                ['function', 'modsearch#mods#UnwrapWord'],
      \ 'ignore-syntax-comment': ['function', 'modsearch#mods#IgnoreSyntax', 'Comment'],
      \ 'ignore-syntax-string':  ['function', 'modsearch#mods#IgnoreSyntax', 'String'],
      \
      \ 'w':   ['alias', 'word'],
      \ 'uw':  ['alias', 'unword'],
      \ 'isc': ['alias', 'ignore-syntax-comment'],
      \ 'iss': ['alias', 'ignore-syntax-string'],
      \ }

" TODO Camelcase, underscore? +Camelcase, +underscore?

command! -nargs=+ -complete=custom,modsearch#Complete Modsearch call modsearch#Main(<f-args>)

let &cpo = s:keepcpo
unlet s:keepcpo
