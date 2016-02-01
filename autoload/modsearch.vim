function! modsearch#Main(...)
  let last_search = histget('search', -1)
  let modified_search = last_search

  for mod in a:000
    if mod == "ignore-syntax-comment"
      let modified_search = s:IgnoreSyntax(modified_search, 'Comment')
    elseif mod == "ignore-syntax-string"
      let modified_search = s:IgnoreSyntax(modified_search, 'String')
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

function! modsearch#Complete(_a, _c, _p)
  let commands = [
        \ "ignore-syntax-comment",
        \ "ignore-syntax-string",
        \ "word",
        \ "unword",
        \ ]

  return join(sort(commands), "\n")
endfunction

function! s:IgnoreSyntax(pattern, syntax_group_fragment)
  let saved_view = winsaveview()

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

  call winrestview(saved_view)

  return ignore_pattern.a:pattern
endfunction
