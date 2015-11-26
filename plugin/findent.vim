if exists('g:loaded_findent')
  finish
endif
let g:loaded_findent = 1

let s:save_cpo = &cpoptions
set cpoptions&vim


let s:V = vital#of('vim_findent')
let s:A = s:V.import('ArgumentParser')
let s:parser = s:A.new({
      \ 'name': 'Findent[!]',
      \ 'description': [
      \   'Guess and apply the existing indent rule in the current buffer',
      \ ]
      \})
call s:parser.add_argument(
      \ 'action', [
      \   'An action of the Findent. The following values are available (Default: toggle)',
      \   '- toggle     Toggle activate and deactivate',
      \   '- activate   Activate Findent, follow the guessed indent rule in the buffer',
      \   '- deactivate Deactivate Fident, restore the previous indent rule.',
      \ ], {
      \   'default': 'toggle',
      \   'choices': ['toggle', 'activate', 'deactivate'],
      \ })
call s:parser.add_argument(
      \ '--startline', '-s', 'Start guessing from this line',
      \)
call s:parser.add_argument(
      \ '--lastline', '-l', 'End guessing at this line',
      \)

function! Findent(...) abort " {{{
  let config = call(s:parser.parse, a:000, s:parser)
  if !empty(config)
    let config.verbose = !config.__bang__
    if config.action ==# 'activate'
      call findent#activate(config)
    elseif config.action ==# 'deactivate'
      call findent#deactivate(config)
    else
      call findent#toggle(config)
    endif
  endif
endfunction " }}}
function! FindentComplete(...) abort " {{{
  return call(s:parser.complete, a:000, s:parser)
endfunction " }}}

command! -nargs=? -range -bang
      \ -complete=customlist,FindentComplete
      \ Findent
      \ :call Findent(<q-bang>, [<line1>, <line2>], <f-args>)

let s:default = {
      \ 'startline': 0,
      \ 'lastline': 100,
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
