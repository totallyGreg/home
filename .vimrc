" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Jul 02
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

execute pathogen#infect()

call togglebg#map("<F5>")

" yank to clipboard
if has("clipboard")
  set clipboard=unnamed " copy to the system clipboard

  if has("unnamedplus") " X11 support
    set clipboard+=unnamedplus
  endif
endif

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  "set mouse=v   " This doesn't allow selecting split windows with mouse
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set background=dark
  let g:solarized_termcolors=256
  let g:solarized_termtrans=1
  silent! colo desert
  silent! colorscheme solarized
  set hlsearch
  :nmap \q :nohlsearch<CR>
endif

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup		" do not keep a backup file
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set ignorecase
set smartcase
set encoding=utf8

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Okay trying out some new keybindings, lets start defininig them all here:
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" open edit buffer
:nmap <C-e> :e#<CR>
:nmap <C-n> :bnext<CR>
:nmap <C-p> :bprev<CR>

nnoremap <silent> + :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> - :exe "resize " . (winheight(0) * 2/3)<CR>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" For local replace
nnoremap gr gd[{V%::s/<C-R>///gc<left><left><left>

" " For global replace
nnoremap gR gD:%s/<C-R>///gc<left><left><left>

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>


" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78 ts=2 sw=2 
  autocmd FileType make set tabstop=8 noexpandtab shiftwidth=8 softtabstop=0
  "autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType gitconfig setlocal ts=2 sts=2 sw=2 expandtab
  autocmd Filetype javascript setlocal ts=2 sts=2 sw=2 noexpandtab
  " auto-delete buffers after browing through objects
  autocmd BufReadPost fugitive://* set bufhidden=delete 

  let g:ansible_unindent_after_newline = 0
  let g:ansible_attribute_highlight = "ab"
  let g:ansible_name_highlight = 'b'
  let g:ansible_extra_keywords_highlight = 1

  autocmd FileType mail,text,asciidoc,html setlocal spell spelllang=en
  autocmd FileType asciidoc
          \ setlocal autoindent expandtab softtabstop=2 shiftwidth=2 
	  \ textwidth=70 wrap formatoptions=tcqn
          \ formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\\|^\\s*<\\d\\+>\\s\\+\\\\|^\\s*[a-zA-Z.]\\.\\s\\+\\\\|^\\s*[ivxIVX]\\+\\.\\s\\+
          \ comments=s1:/*,ex:*/,://,b:#,:%,:XCOMM,fb:-,fb:*,fb:+,fb:.,fb:>

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on
  " For everything else, use a tab width of 4 space chars.
  set tabstop=4		" The width of a TAB is set to 4.
			" Still it is a \t. It is just that
			" Vim will interpret it to be having
			" a width of 4.
  set shiftwidth=4	" Indents will have a width of 4.
  set softtabstop=4	" Sets the number of columns for a TAB.
  set expandtab		" Expand TABs to spaces.

endif " has("autocmd")

"Airline Status Options
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

let g:voom_tree_width = 40
let g:voom_default_mode = 'asciidoc'

" Terraform Options
" Allow vim-terraform to override your .vimrc indentation syntax for matching
" files. Defaults to 0 which is off.
let g:terraform_align=1

" Allow vim-terraform to re-map the spacebar to fold / unfold. Defaults to 0 which is off.
let g:terraform_remap_spacebar=1

" Fugitive Git status
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

map <F4> :retab <CR> :w <CR>
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif
