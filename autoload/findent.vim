let s:save_cpo = &cpoptions
set cpoptions&vim

function! s:parse_args(args, ...) abort " {{{
  let options = get(a:000, 0, {})
  for arg in a:args
    if arg ==# '-h' || arg ==# '--help'
      let options.help = 1
    elseif arg ==# '--messages'
      let options.messages = 1
    elseif arg ==# '--no-messages'
      let options.messages = 0
    elseif arg ==# '--warnings'
      let options.warnings = 1
    elseif arg ==# '--no-warnings'
      let options.warnings = 0
    elseif arg =~# '^--threshold=\d\+'
      let options.threshold = str2nr(matchstr(arg, '^--threshold=\zs\d\+'))
    elseif arg =~# '^--chunksize=\d\+'
      let options.chunksize = str2nr(matchstr(arg, '^--chunksize=\zs\d\+'))
    else
      echohl ErrorMsg
      echo printf('Unknown option "%s" is specified', arg)
      echohl None
      return {}
    endif
  endfor
  return options
endfunction " }}}
function! s:filter_minority(candidates, ...) abort " {{{
  let alpha     = get(a:000, 0, 0.05)
  let threshold = len(a:candidates) * alpha
  let frequency = {}
  for candidate in a:candidates
    let frequency[candidate] = get(frequency, candidate, 0) + 1
  endfor
  return filter(copy(a:candidates), 'frequency[v:val] > threshold')
endfunction " }}}
function! s:guess_tab_style(spaces, tabs, leadings, threshold) abort " {{{
  let tab_spaces = s:filter_minority(filter(
        \ map(copy(a:leadings), 'len(matchstr(v:val, "^\\t\\+\\zs \\+"))'),
        \ 'index(g:findent#samples, v:val) >= 0'
        \))
  if !empty(tab_spaces)
    " Vim(C)/Ruby(C) or BSD/KNF style variant (shiftwidth=4, tabstop=8)
    " Use 'spaces' instead of 'tab_spaces' for determine the maximum number
    " of spaces to improve detection accuracy
    return {
          \ 'expandtab': 0,
          \ 'shiftwidth': min(a:spaces),
          \ 'tabstop': min(a:spaces) + max(a:spaces),
          \ 'softtabstop': 0,
          \}
  else
    " Tab indent style
    return {
          \ 'expandtab': 0,
          \ 'shiftwidth': 0,
          \ 'softtabstop': 0,
          \}
  endif
endfunction " }}}
function! s:guess_space_style(spaces, tabs, leadings, threshold) abort " {{{
  let topscore = 0
  let unit  = 0
  for sample in g:findent#samples
    let score = len(filter(copy(a:spaces), 'v:val == sample'))
    if score > topscore
      let unit = sample
      let topscore = score
      if a:threshold > 0 && score >= a:threshold
        break
      endif
    endif
  endfor
  if topscore == 0
    return {}
  endif
  return {
        \ 'expandtab': 1,
        \ 'shiftwidth': unit,
        \ 'softtabstop': unit,
        \}
endfunction " }}}

function! findent#guess(content, ...) abort " {{{
  let threshold = get(a:000, 0, g:findent#threshold)
  let leadings = filter(
        \ map(a:content, 'matchstr(v:val, "^\\%(\\t\\| \\)\\+")'),
        \ '!empty(v:val)'
        \)
  if empty(leadings)
    " failed to guess
    return {}
  endif
  let spaces = s:filter_minority(filter(
        \ map(copy(leadings), 'len(matchstr(v:val, "^ \\+"))'),
        \ 'index(g:findent#samples, v:val) >= 0'
        \))
  let tabs = s:filter_minority(filter(
        \ map(copy(leadings), 'len(matchstr(v:val, "^\\t\\+"))'),
        \ 'v:val'
        \))
  if len(spaces) <= len(tabs)
    return s:guess_tab_style(spaces, tabs, leadings, threshold)
  else
    return s:guess_space_style(spaces, tabs, leadings, threshold)
  endif
endfunction " }}}
function! findent#apply(...) abort " {{{
  let options = extend({
        \ 'force': 0,
        \ 'messages': g:findent#enable_messages,
        \ 'warnings': g:findent#enable_warnings,
        \ 'threshold': g:findent#threshold,
        \ 'chunksize': g:findent#chunksize,
        \ 'startline': 0,
        \ 'lastline':  0,
        \}, get(a:000, 0, {})
        \)
  if exists('b:_findent')
    if options.force
      call findent#restore({'messages': 0, 'warnings': 0})
    else
      if options.warnings
        echohl WarningMsg
        echo printf(
              \ 'findent has already applied (%s, shiftwidth=%d, tabstop=%d, and softtabstop=%d)',
              \ &l:expandtab ? 'expandtab' : 'noexpandtab',
              \ &l:shiftwidth,
              \ &l:tabstop,
              \ &l:softtabstop,
              \)
        echohl None
      endif
      return
    endif
  endif
  let N = line('$')
  if options.startline == options.lastline
    " calculate reasonable startline and lastline
    let startline = N - float2nr(round(options.chunksize / 2))
    let lastline  = startline + options.chunksize
  else
    " use specified startline and lastline
    let startline = options.startline
    let lastline  = options.lastline
  endif
  let startline = max([0, startline])
  let lastline  = min([N, lastline])
  let content = getline(startline, lastline)
  let meta = call('findent#guess', [content, options.threshold])
  if empty(meta)
    if options.warnings
      echohl WarningMsg
      echo 'findent has failed to guess the indent rule of the current buffer'
      echohl None
    endif
    return
  endif
  let meta.previous = {}
  let meta.previous.expandtab   = &l:expandtab
  let meta.previous.shiftwidth  = &l:shiftwidth
  let meta.previous.tabstop     = &l:tabstop
  let meta.previous.softtabstop = &l:softtabstop
  let &l:expandtab   = meta.expandtab
  let &l:shiftwidth  = meta.shiftwidth
  let &l:tabstop     = get(meta, 'tabstop', &l:tabstop)
  let &l:softtabstop = get(meta, 'softtabstop', &l:softtabstop)
  let b:_findent = meta
  if options.messages
    echo printf(
          \ 'findent is applied (%s, shiftwidth=%d, tabstop=%d, and softtabstop=%d)',
          \ &l:expandtab ? 'expandtab' : 'noexpandtab',
          \ &l:shiftwidth,
          \ &l:tabstop,
          \ &l:softtabstop,
          \)
  endif
endfunction " }}}
function! findent#restore(...) abort " {{{
  let options = extend({
        \ 'messages': g:findent#enable_messages,
        \ 'warnings': g:findent#enable_warnings,
        \}, get(a:000, 0, {})
        \)
  if !exists('b:_findent')
    if options.warnings
      echohl WarningMsg
      echo printf(
            \ 'findent has not applied yet (%s, shiftwidth=%d, tabstop=%d, and softtabstop=%d)',
            \ &l:expandtab ? 'expandtab' : 'noexpandtab',
            \ &l:shiftwidth,
            \ &l:tabstop,
            \ &l:softtabstop,
            \)
      echohl None
    endif
    return
  endif
  let meta = b:_findent
  let &l:expandtab   = meta.previous.expandtab
  let &l:shiftwidth  = meta.previous.shiftwidth
  let &l:tabstop     = meta.previous.tabstop
  let &l:softtabstop = meta.previous.softtabstop
  unlet! b:_findent
  if options.messages
    echo printf(
          \ 'Findent is restored (%s, shiftwidth=%d, tabstop=%d, and softtabstop=%d)',
          \ &l:expandtab ? 'expandtab' : 'noexpandtab',
          \ &l:shiftwidth,
          \ &l:tabstop,
          \ &l:softtabstop,
          \)
  endif
endfunction " }}}

function! findent#Findent(bang, line1, line2, args) abort " {{{
  let options = s:parse_args(a:args, {
        \ 'force': a:bang ==# '!',
        \ 'startline': a:line1,
        \ 'lastline': a:line2,
        \})
  if empty(options)
    " failed to parse
    return
  endif

  redraw
  if get(options, 'help')
    echo ':Findent[!] [-h|--help] [--[no-]messages] [--[no-]warnings] [--chunksize={CHUNKSIZE}] [--threshold={THRESHOLD}]'
    echo ' '
    echo 'Find and apply a reasonable indent rule of the current buffer'
    echo ' '
    echo 'Optional arguments:'
    echo ' -h, --help                 Show this help'
    echo ' --[no-]messages            Show detection messages'
    echo ' --[no-]warnings            Show warning messages'
    echo ' --chunksize={CHUNKSIZE}    Specify chunksize (the number of lines) of the content'
    echo ' --threshold={THRESHOLD}    Specify detection threshold of a space indent'
  else
    call findent#apply(options)
  endif
endfunction " }}}
function! findent#FindentRestore(args) abort " {{{
  let options = s:parse_args(a:args)
  if empty(options)
    " failed to parse
    return
  endif

  redraw
  if get(options, 'help')
    echo ':FindentRestore [-h|--help] [--[no-]messages] [--[no-]warnings]'
    echo ' '
    echo 'Restore a previous indent rule of the current buffer'
    echo ' '
    echo 'Optional arguments:'
    echo ' -h, --help                 Show this help'
    echo ' --[no-]messages            Show detection messages'
    echo ' --[no-]warnings            Show warning messages'
  else
    call findent#restore(options)
  endif
endfunction " }}}
function! findent#FindentComplete(arglead, cmdline, cursorpos) abort " {{{
  let candidates = [
        \ '-h', '--help',
        \ '--messages', '--no-messages',
        \ '--warnings', '--no-warnings',
        \ '--threshold=',
        \ '--chunksize=',
        \]
  return filter(candidates, printf('v:val =~# "^%s"', a:arglead))
endfunction " }}}
function! findent#FindentRestoreComplete(arglead, cmdline, cursorpos) abort " {{{
  let candidates = [
        \ '-h', '--help',
        \ '--messages', '--no-messages',
        \ '--warnings', '--no-warnings',
        \]
  return filter(candidates, printf('v:val =~# "^%s"', a:arglead))
endfunction " }}}

let s:default = {
      \ 'enable_messages': 1,
      \ 'enable_warnings': 1,
      \ 'chunksize': 1000,
      \ 'threshold': 1,
      \ 'samples': [2, 4, 8],
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
