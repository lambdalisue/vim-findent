if exists('g:loaded_findent')
  finish
endif
let g:loaded_findent = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

command! -nargs=0 -range -bang
      \ Findent
      \ :call findent#Findent(<q-bang>, <line1>, <line2>)
command! -nargs=0 -range -bang
      \ FindentActivate
      \ :call findent#FindentActivate(<q-bang>, <line1>, <line2>)
command! -nargs=0 -range -bang
      \ FindentDeactivate
      \ :call findent#FindentDeactivate(<q-bang>)

let &cpoptions = s:save_cpo
" vim:set et ts=2 sts=2 sw=2 tw=0 fdm=marker:
