vim-findent [![Build status](https://travis-ci.org/lambdalisue/vim-findent.svg?branch=master)](https://travis-ci.org/lambdalisue/vim-findent) [![Build status](https://ci.appveyor.com/api/projects/status/p7orkdddc08v4lvk/branch/master?svg=true)](https://ci.appveyor.com/project/lambdalisue/vim-findent/branch/master)
===============================================================================

vim-findent is a plugin to guess and apply the existing indent rule of the
current buffer. This plugin guess reasonable value of `expandtab` and `shiftwidth`
from the contents of the current buffer and apply.

Install
-------------------------------------------------------------------------------

The repository (https://github.com/lambdalisue/vim-findent) follow a standard
directory structure thus you can use Vundle.vim, neobundle.vim, or other vim
plugin manager to install |vim-findent| like:

```vim
" Vundle.vim
Plugin 'lambdalisue/vim-findent'

" neobundle.vim
NeoBundle 'lambdalisue/vim-findent'

" neobundle.vim (Lazy)
NeoBundleLazy 'lambdalisue/vim-findent', {
	\ 'autoload': {
	\   'commands': ['Findent'],
	\}}
```

If you are not using any vim plugin manager, you can copy the repository to
your $VIM directory to enable the plugin.


Usage
-------------------------------------------------------------------------------

If you want to automatically activate findent in particular filetypes. Use the
following settings (let's say you want to activate it in *.js or *.css).

```vim
augroup findent
  autocmd!
  autocmd BufWinEnter *.js  Findent activate
  autocmd BufWinEnter *.css Findent activate
augroup END
```


License
--------------------------------------------------------------------------------
Copyright (c) 2014 Alisue, hashnote.net

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
