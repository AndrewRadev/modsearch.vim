function! modsearch#mods#IgnoreSyntax(pattern, syntax_group_fragment)
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

function! modsearch#mods#WrapWord(pattern)
  return '\<'.a:pattern.'\>'
endfunction

function! modsearch#mods#UnwrapWord(pattern)
  let pattern = a:pattern
  let pattern = substitute(pattern, '^\\<', '', '')
  let pattern = substitute(pattern, '\\>$', '', '')
  return pattern
endfunction
