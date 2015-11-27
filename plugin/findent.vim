if exists('g:loaded_findent')
  finish
endif
let g:loaded_findent = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

command! -nargs=? -range -bang
      \ -complete=customlist,findent#FindentComplete
      \ Findent
      \ :call findent#Findent(<q-bang>, <line1>, <line2>, <q-args>)
command! -nargs=? -range -bang
      \ -complete=customlist,findent#FindentComplete
      \ FindentActivate
      \ :call findent#FindentActivate(<q-bang>, <line1>, <line2>, <q-args>)
command! -nargs=? -range -bang
      \ -complete=customlist,findent#FindentComplete
      \ FindentDeactivate
      \ :call findent#FindentDeactivate(<q-bang>, <q-args>)

let &cpoptions = s:save_cpo
" vim:set et ts=2 sts=2 sw=2 tw=0 fdm=marker:
