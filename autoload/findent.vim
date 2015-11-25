let s:save_cpo = &cpoptions
set cpoptions&vim

function! findent#guess(...) abort " {{{
  let config = extend({
        \ 'startline': g:findent#startline,
        \ 'lastline':  g:findent#lastline,
        \}, get(a:000, 0, {})
        \)
  let startline = min([line('$'), config.startline])
  let lastline  = min([line('$'), config.lastline])
  let leadings = filter(
        \ map(
        \   getline(startline, lastline),
        \   'matchstr(v:val, "^\[ \t\]*")'
        \ ),
        \ '!empty(v:val)'
        \)
  if empty(leadings)
    " failed to guess
    return {}
  endif
  let result = {}
  " determine \t or \s
  let firstchars = join(map(deepcopy(leadings), 'v:val[0]'), '')
  let nspaces = len(substitute(firstchars, "\t", '', 'g'))
  let ntabs   = len(firstchars) - nspaces
  let result.expandtab = nspaces > ntabs
  " find minimum nspaces if noexpandtab
  if !result.expandtab
    let result.shiftwidth = &l:tabstop
  else
    let result.shiftwidth = min(filter(
          \ map(
          \   deepcopy(leadings),
          \   'len(matchstr(v:val, "^\[ \]*"))'
          \ ),
          \ 'v:val > 0'
          \))
  endif
  return result
endfunction " }}}
function! findent#toggle(...) abort " {{{
  if exists('b:_findent')
    call call('findent#deactivate', a:000)
  else
    call call('findent#activate', a:000)
  endif
endfunction " }}}
function! findent#activate(...) abort " {{{
  let config = extend({
        \ 'verbose': 1,
        \}, get(a:000, 0, {})
        \)
  if exists('b:_findent')
    if config.verbose
      echohl WarningMsg
      echo 'Findent has already activated in this buffer'
      echohl None
    endif
    return
  endif
  let meta = call('findent#guess', a:000)
  if empty(meta)
    if config.verbose
      echohl WarningMsg
      echo 'Findent has failed to guess the indent rule in this buffer'
      echohl None
    endif
    return
  endif
  let meta.previous = {}
  let meta.previous.expandtab  = &l:expandtab
  let meta.previous.shiftwidth = &l:shiftwidth
  let &l:expandtab  = meta.expandtab
  let &l:shiftwidth = meta.shiftwidth
  let b:_findent = meta
  if config.verbose
    echo printf(
          \ 'Findent is activated (%s and shiftwidth=%d)',
          \ &l:expandtab ? 'expandtab' : 'noexpandtab',
          \ &l:shiftwidth,
          \)
  endif
endfunction " }}}
function! findent#deactivate(...) abort " {{{
  let config = extend({
        \ 'verbose': 1,
        \}, get(a:000, 0, {})
        \)
  if !exists('b:_findent')
    if config.verbose
      echohl WarningMsg
      echo 'Findent has not activated in this buffer'
      echohl None
    endif
    return
  endif
  let meta = b:_findent
  let &l:shiftwidth = meta.previous.shiftwidth
  let &l:expandtab  = meta.previous.expandtab
  unlet! b:_findent
  if config.verbose
    echo printf(
          \ 'Findent is deactivated (%s and shiftwidth=%d)',
          \ &l:expandtab ? 'expandtab' : 'noexpandtab',
          \ &l:shiftwidth,
          \)
  endif
endfunction " }}}

let &cpoptions = s:save_cpo
" vim:set et ts=2 sts=2 sw=2 tw=0 fdm=marker:
