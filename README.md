vim-findent [![Build status](https://travis-ci.org/lambdalisue/vim-findent.svg?branch=master)](https://travis-ci.org/lambdalisue/vim-findent) [![Build status](https://ci.appveyor.com/api/projects/status/p7orkdddc08v4lvk/branch/master?svg=true)](https://ci.appveyor.com/project/lambdalisue/vim-findent/branch/master)
===============================================================================


*vim-findent* is a plugin to find and apply reasonable values of `expandtab`, `shiftwidth`, `tabstop`, and `softtabstop` (an indent rule) from the content of the current buffer.

vim-findent is a small and simple Vim plugin, compares to existing similar plugins such as [vim-sleuth](https://github.com/tpope/vim-sleuth) or [detectindent](https://github.com/ciaranm/detectindent).
This plugin only provides two commands and no default `FileType` `autocmd` is provided, mean that users can control the behavior of automatic detection by defining `autocmd` by themselves.
The detection algorithm is much simpler as well compared to vim-sleuth or detectindent.
While we are living in a real world and we are editing pre-formatted codes, I don't really think we need a super perfect but complex algorithm.
A faster and simpler algorithm would be better.

See [Test cases](./test/dat) to figure out what kind of indent rules can be detected via this plugin.

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
	\     'FindentRestore',
	\   ],
	\}}

" neobundle.vim (Lazy: with completion)
NeoBundleLazy 'lambdalisue/vim-findent', {
	\ 'autoload': {
	\   'commands': [
	\     {
	\       'name': 'Findent',
	\       'complete': 'customlist,findent#FindentComplete',
	\     },
	\     {
	\       'name': 'FindentRestore',
	\       'complete': 'customlist,findent#FindentRestoreComplete',
	\     },
	\  ],
	\}}
```

If you are not using any vim plugin manager, you can copy the repository to
your `$VIM` directory to enable the plugin.


Usage
-------------------------------------------------------------------------------

Call `:Findent` to find and apply reasonable `expandtab`, `shiftwidth`, `tabstop`, and `softtabstop` (an indent rule) of
the current buffer.
It automatically use a middle part of the content to detect the reasonable indent rule and apply to the local setting (`setlocal`).
If you want to control the region of content used for detection, use visual selection to select the region prior to the command.

Call `:FindentRestore` to restore a previous indent rule of the current buffer or call `:Findent!` to re-apply forcedly.

If you want to make this detection automatic, use `autocmd` like:

```vim
augroup findent
  autocmd!
  autocmd FileType javascript Findent
  autocmd FileType css        Findent
augroup END
```

If you feel annoying for the detection message, use '--no-messages':

```vim
augroup findent
  autocmd!
  autocmd FileType javascript Findent --no-messages
  autocmd FileType css        Findent --no-messages
augroup END
```

Or if you want to completely suppress messages, use '--no-warnings' as well:

```vim
augroup findent
  autocmd!
  autocmd FileType javascript Findent --no-messages --no-warnings
  autocmd FileType css        Findent --no-messages --no-warnings
augroup END
```

In this case, `Findent` reserve the specified options into a buffer variable and
actual `Findent` call will be performed on `BufWinEnter` autocmd.
This is required to make sure that the `Findent` command is called only after `FileType` autocmd or `ftplugin`.
See `:help Findent-autocmd` for more detail about this behavior.

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
