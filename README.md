vim-findent [![Build status](https://travis-ci.org/lambdalisue/vim-findent.svg?branch=master)](https://travis-ci.org/lambdalisue/vim-findent) [![Build status](https://ci.appveyor.com/api/projects/status/p7orkdddc08v4lvk/branch/master?svg=true)](https://ci.appveyor.com/project/lambdalisue/vim-findent/branch/master)
===============================================================================


*vim-findent* is a plugin to find and apply reasonable values of `expandtab`,
`shiftwidth`, and `softtabstop` from the content of the current buffer.

vim-findent is small and simple plugin, compares to existing similar plugins such as [vim-sleuth](https://github.com/tpope/vim-sleuth) or [detectindent](https://github.com/ciaranm/detectindent).
This plugin only provide three commands and no default `autocmd` is provided, mean that user can control the behavior of automatic detection by defining `autocmd` by them self.
The detection algorithm is much simpler as well compared to vim-sleuth or detectindent.
While we are living a real world and we are editing pre-formatted codes, I don't really think we need a super perfect but complex algorithm.
A faster and simpler algorithm would be better.


Install
-------------------------------------------------------------------------------

Use Vundle.vim, neobundle.vim, or other vim plugin manager to install it like:

```vim
" Vundle.vim
Plugin 'lambdalisue/vim-findent'

" neobundle.vim
NeoBundle 'lambdalisue/vim-findent'

" neobundle.vim (Lazy)
NeoBundleLazy 'lambdalisue/vim-findent', {
	\ 'autoload': {
	\   'commands': [
	\     'Findent',
	\     'FindentActivate',
	\     'FindentDeactivate',
	\   ],
	\}}

" neobundle.vim (Lazy: with completion)
NeoBundleLazy 'lambdalisue/vim-findent', {
	\ 'autoload': {
	\   'commands': [{
	\     'name': [
	\       'Findent', 
	\       'FindentActivate'
	\       'FindentDeactivate'
	\     ],
	\     'complete': 'customlist,findent#FindentComplete',
	\   }],
	\}}
```

If you are not using any vim plugin manager, you can copy the repository to
your $VIM directory to enable the plugin.


Usage
-------------------------------------------------------------------------------

To find and apply reasonable `expandtab`, `shiftwidth`, and `softtabstop` of
the current buffer, call `:Findent` or `:FindentActivate`.
If you want to control the region of content used for detection, select the
region via visual selection (V) and call the command above.

If you want to make this detection automatic, use `autocmd` like:

```vim
augroup findent
  autocmd!
  autocmd BufRead *.js  FindentActivate
  autocmd BufRead *.css FindentActivate
augroup END
```

If you feel annoying for the detection fail message, use a bang (!) to suppress:

```vim
augroup findent
  autocmd!
  autocmd BufRead *.js  FindentActivate!
  autocmd BufRead *.css FindentActivate!
augroup END
```

Or if you want to completely suppress the messages, specify 'quiet':

```vim
augroup findent
  autocmd!
  autocmd BufRead *.js  FindentActivate! quiet
  autocmd BufRead *.css FindentActivate! quiet
augroup END
```

Note: Use `BufRead` instead of `FileType` to prevent overwriting by ftplugin.

Command and Variable
-------------------------------------------------------------------------------

See `:help vim-findent-command` or `:help vim-findent-variable`.


License
--------------------------------------------------------------------------------
Copyright (c) 2015 Alisue, hashnote.net

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files
(the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of the Software,
and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
