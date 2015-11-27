if exists('g:loaded_findent')
  finish
endif
let g:loaded_findent = 1

let s:save_cpo = &cpoptions
set cpoptions&vim


function! Findent(bang, line1, line2) abort " {{{
  let config = {
        \ 'verbose': a:bang !=# '!',
        \ 'startline': a:line1,
        \ 'lastline': a:line2,
        \}
  if a:line1 == a:line2
    let config.startline = g:findent#startline
    let config.lastline  = g:findent#lastline
  endif
  call findent#toggle(config)
endfunction " }}}
function! FindentActivate(bang, line1, line2) abort " {{{
  let config = {
        \ 'verbose': a:bang !=# '!',
        \ 'startline': a:line1,
        \ 'lastline': a:line2,
        \}
  if a:line1 == a:line2
    let config.startline = g:findent#startline
    let config.lastline  = g:findent#lastline
  endif
  call findent#activate(config)
endfunction " }}}
function! FindentDeactivate(bang) abort " {{{
  let config = {
        \ 'verbose': a:bang !=# '!',
        \}
  call findent#deactivate(config)
endfunction " }}}

command! -nargs=0 -range -bang
      \ Findent
      \ :call Findent(<q-bang>, <line1>, <line2>)
command! -nargs=0 -range -bang
      \ FindentActivate
      \ :call FindentActivate(<q-bang>, <line1>, <line2>)
command! -nargs=0 -range -bang
      \ FindentDeactivate
      \ :call FindentDeactivate(<q-bang>)

let s:default = {
      \ 'startline': 0,
      \ 'lastline': 100,
      \ 'threshold': 1,
      \ 'available_units': [2, 4, 8],
      \}
function! s:init() abort " {{{
  for [key, value] in items(s:default)
    let key = 'g:findent#' . key
    if !exists(key)
      silent execute printf('let %s = %s', key, string(value))
    endif
    unlet value
  endfor
endfunction " }}}
call s:init()

let &cpoptions = s:save_cpo
" vim:set et ts=2 sts=2 sw=2 tw=0 fdm=marker:
