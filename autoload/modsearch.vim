function! modsearch#Main(...)
  let last_search = @/
  let modified_search = last_search

  let mod_index = {}
  call extend(mod_index, g:modsearch_mods)
  call extend(mod_index, g:modsearch_custom_mods)

  for mod in a:000
    let modified_search = s:ApplyMod(modified_search, mod, mod_index)
  endfor

  let @/ = modified_search
endfunction

function! modsearch#Complete(_a, _c, _p)
  let mod_index = {}
  call extend(mod_index, g:modsearch_mods)
  call extend(mod_index, g:modsearch_custom_mods)

  return join(sort(keys(mod_index)), "\n")
endfunction

function! s:ApplyMod(pattern, mod, mod_index)
  let pattern   = a:pattern
  let mod       = a:mod
  let mod_index = a:mod_index

  if !has_key(mod_index, mod)
    echomsg "Unknown modification: ".mod
    return pattern
  endif

  let [type; mod_definition] = mod_index[mod]
  if type == 'alias'
    let real_mod = mod_definition[0]
    return s:ApplyMod(pattern, real_mod, mod_index)
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
