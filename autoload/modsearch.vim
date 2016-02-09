function! modsearch#Main(...)
  let last_search = @/
  let modified_search = last_search

  for mod in a:000
    let modified_search = s:ApplyMod(modified_search, mod)
  endfor

  let @/ = modified_search
endfunction

function! modsearch#Complete(_a, _c, _p)
  return join(sort(keys(g:modsearch_mods)), "\n")
endfunction

function! s:ApplyMod(pattern, mod)
  let pattern = a:pattern
  let mod     = a:mod

  if !has_key(g:modsearch_mods, mod)
    echomsg "Unknown modification: ".mod
    return pattern
  endif

  let [type; mod_definition] = g:modsearch_mods[mod]
  if type == 'alias'
    let real_mod = mod_definition[0]
    return s:ApplyMod(pattern, real_mod)
  endif

  if type == 'function'
    let name = mod_definition[0]
    let args = extend([pattern], mod_definition[1:])
    return call(name, args)
  else
    echomsg "Unknown modification type (".type.") for mod: ".mod
    return pattern
  endif
endfunction
