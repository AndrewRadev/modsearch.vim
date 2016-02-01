if exists('g:loaded_modsearch') || &cp
  finish
endif

let g:loaded_modsearch = '0.0.1' " version number
let s:keepcpo = &cpo
set cpo&vim

command! -nargs=+ -complete=custom,s:ModsearchComplete Modsearch call s:Modsearch(<f-args>)
function! s:Modsearch(...)
  let last_search = histget('search', -1)
  let modified_search = last_search

  for mod in a:000
    if mod == "ignore-syntax-comment"
      let modified_search = s:ModsearchIgnoreSyntax(modified_search, 'Comment')
    elseif mod == "ignore-syntax-string"
      let modified_search = s:ModsearchIgnoreSyntax(modified_search, 'String')
    elseif mod == "word"
      let modified_search = '\<'.modified_search.'\>'
    elseif mod == "unword"
      let modified_search = substitute(modified_search, '^\\<', '', '')
      let modified_search = substitute(modified_search, '\\>$', '', '')
    else
      echomsg "Unknown modification: ".mod
      continue
    endif
  endfor

  let @/ = modified_search
endfunction

function! s:ModsearchComplete(_a, _c, _p)
  let commands = [
        \ "ignore-syntax-comment",
        \ "ignore-syntax-string",
        \ "word",
        \ "unword",
        \ ]

  return join(sort(commands), "\n")
endfunction

function! s:ModsearchIgnoreSyntax(pattern, syntax_group_fragment)
  call sj#PushCursor()

  let skip_pattern = '\%('.a:syntax_group_fragment.'\)'
  let ignore_pattern = ''

  " Iterate over all search results in file
  normal! G$
  let search_flags = "w"
  while search(a:pattern, search_flags) > 0
    let search_flags = "W"
    if synIDattr(synID(line('.'), col('.'), 1), 'name') =~ skip_pattern
      let ignore_pattern .= '\%(\%'.line('.').'l\%'.col('.').'c\)\@!'
    endif
  endwhile

  call sj#PopCursor()

  return ignore_pattern.a:pattern
endfunction

let &cpo = s:keepcpo
unlet s:keepcpo
