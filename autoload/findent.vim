let s:save_cpo = &cpoptions
set cpoptions&vim

function! findent#guess(content, ...) abort " {{{
  let threshold = get(a:000, 0, g:findent#threshold)
  let leadings = filter(
        \ map(a:content, 'matchstr(v:val, "^\\%(\\t\\|  \\)\\+")'),
        \ '!empty(v:val)'
        \)
  if empty(leadings)
    " failed to guess
    return {}
  endif
  let spaces = filter(
        \ map(copy(leadings), 'len(matchstr(v:val, "^ \\+"))'),
        \ 'v:val'
        \)
  let tabs = filter(
        \ map(copy(leadings), 'len(matchstr(v:val, "^\\t\\+"))'),
        \ 'v:val'
        \)
  if len(spaces) <= len(tabs)
    " tab is more dominant so probably the file is tab indented
    return {
          \ 'expandtab': 0,
          \ 'shiftwidth': 0,
          \ 'softtabstop': 0,
          \}
  endif

  let score = 0
  let unit  = 0
  for x in g:findent#available_units
    let s = len(filter(copy(spaces), printf('v:val == %d', x)))
    if s > score
      let unit = x
      let score = s
      if threshold > 0 && score >= threshold
        break
      endif
    endif
  endfor
  if score == 0
    return {}
  endif
  return {
        \ 'expandtab': 1,
        \ 'shiftwidth': unit,
        \ 'softtabstop': unit,
        \}
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
        \ 'startline': g:findent#startline,
        \ 'lastline':  g:findent#lastline,
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
  let startline = min([line('$'), config.startline])
  let lastline  = min([line('$'), config.lastline])
  let content   = getline(startline, lastline)
  let meta = call('findent#guess', [content])
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
  let meta.previous.softtabstop = &l:softtabstop
  let &l:expandtab  = meta.expandtab
  let &l:shiftwidth = meta.shiftwidth
  let &l:softtabstop = meta.softtabstop
  let b:_findent = meta
  if config.verbose
    echo printf(
          \ 'Findent is activated (%s, shiftwidth=%d, and softtabstop=%d)',
          \ &l:expandtab ? 'expandtab' : 'noexpandtab',
          \ &l:shiftwidth,
          \ &l:softtabstop,
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
  let &l:expandtab  = meta.previous.expandtab
  let &l:shiftwidth = meta.previous.shiftwidth
  let &l:softtabstop = meta.previous.softtabstop
  unlet! b:_findent
  if config.verbose
    echo printf(
          \ 'Findent is deactivated (%s, shiftwidth=%d, and softtabstop=%d)',
          \ &l:expandtab ? 'expandtab' : 'noexpandtab',
          \ &l:shiftwidth,
          \ &l:softtabstop,
          \)
  endif
endfunction " }}}

function! findent#Findent(bang, line1, line2) abort " {{{
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
function! findent#FindentActivate(bang, line1, line2) abort " {{{
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
function! findent#FindentDeactivate(bang) abort " {{{
  let config = {
        \ 'verbose': a:bang !=# '!',
        \}
  call findent#deactivate(config)
endfunction " }}}

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
