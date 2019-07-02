" redoing .vimrc to be simpler

set nocompatible

"{{{ Plugin Managment
"
" Configure Vim-Plug
" call plug#begin('~/.vim/plugged')
call plug#begin('~/.local/share/nvim/plugged')

" Base Plugins
Plug 'tpope/vim-sensible'
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'w0rp/ale'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'rking/ag.vim'
Plug '/usr/local/opt/fzf'
Plug 'vim-scripts/restore_view.vim'

" Tmux Tools
Plug 'tmux-plugins/vim-tmux'
Plug 'urbainvaes/vim-tmux-pilot'
Plug 'benmills/vimux'

" Code Helpers
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'pearofducks/ansible-vim'
Plug 'hashivim/vim-terraform'
Plug 'nvie/vim-flake8'
" Plug 'ivanov/vim-ipython'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

call plug#end()

"{{{ Plugin Settings
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline_theme='solarized'
let g:ale_python_flake8_args="--ignore=E501"
let g:ansible_unindent_after_newline = 0
let g:ansible_attribute_highlight = "ab"
let g:ansible_name_highlight = 'b'
let g:ansible_extra_keywords_highlight = 1
let g:gitgutter_enabled = 1
let g:gitgutter_hightlight_lines = 1
let g:terraform_fold_sections=1

"}}}

"}}}

" let b:ale_linters = ['pyflakes', 'flake8', 'pylint']
" let g:ale_open_list = 1

"let python_highlights_all=1

" Autogroups {{{
"
" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" autocmd! bufwritepost .vimrc source ~/.vimrc
" autocmd! bufwritepost .init.vim source ~/.config/nvim/init.vim
augroup myvimrc
    au!
    au BufWritePost .vimrc,_vimrc,vimrc,init.vim,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END

" fdoc is yaml
autocmd BufRead,BufNewFile *.fdoc set filetype=yaml
" md is markdown
autocmd BufRead,BufNewFile *.md set filetype=markdown
autocmd BufRead,BufNewFile *.md set spell

" autocmd BufWritePre *.php,*.py,*.js,*.txt,*.hs,*.java,*.md
"                 \:call <SID>StripTrailingWhitespaces()
" For all text files set 'textwidth' to 78 characters.
autocmd FileType text setlocal textwidth=78 ts=2 sw=2
autocmd FileType make set tabstop=8 noexpandtab shiftwidth=8 softtabstop=0
"autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType gitconfig setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype javascript setlocal ts=2 sts=2 sw=2 noexpandtab
autocmd BufRead,BufNewFile Vagrantfile setfiletype ruby
" auto-delete buffers after browing through objects
autocmd BufReadPost fugitive://* set bufhidden=delete


autocmd FileType mail,text,html setlocal spell spelllang=en
autocmd BufRead,BufNewFile *.txt,*.asciidoc,README,TODO,CHANGELOG,NOTES,ABOUT
    \ setlocal autoindent expandtab tabstop=8 softtabstop=2 shiftwidth=2 filetype=asciidoc
    \ textwidth=70 wrap formatoptions=tcqn
    \ formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\\|^\\s*<\\d\\+>\\s\\+\\\\|^\\s*[a-zA-Z.]\\.\\s\\+\\\\|^\\s*[ivxIVX]\\+\\.\\s\\+
    \ comments=s1:/*,ex:*/,://,b:#,:%,:XCOMM,fb:-,fb:*,fb:+,fb:.,fb:>
" }}}
"
" Spaces and Tabs {{{
set tabstop=4             " number of visual spaces per TAB
set softtabstop=4         " number of spaces in tab when editing
set expandtab             " tabs are spaces

" }}}

" Copy/Paste {{{
" Don't copy the contents of an overwritten selection.
vnoremap p "_dP

" }}}

" UI Config {{{
" syntax enable
set autoindent
set autoread                                                 " reload files when changed on disk, i.e. via `git checkout`
set backspace=2                                              " Fix broken backspace in some setups
set backupcopy=yes                                           " see :help crontab
set clipboard=unnamed                                        " yank and paste with the system clipboard
set directory-=.                                             " don't store swapfiles in the current directory
set encoding=utf-8
set expandtab                                                " expand tabs to spaces
set ignorecase                                               " case-insensitive search
set incsearch                                                " search as you type
set laststatus=2                                             " always show statusline
set list                                                     " show trailing whitespace
set listchars=tab:▸\ ,trail:▫
set modelines=1
set number                                                   " show line numbers
set cursorline " don't highlight current line
set ruler                                                    " show where you are
set scrolloff=3                                              " show context above/below cursorline
set shiftwidth=2                                             " normal mode indentation commands use 2 spaces
set showcmd
set smartcase                                                " case-sensitive search if any caps
set softtabstop=2                                            " insert mode tab and backspace use 2 spaces
set tabstop=8                                                " actual tabs occupy 8 characters
set wildignore=log/**,node_modules/**,target/**,tmp/**,*.rbc
set wildmenu                                                 " show a navigable menu for tab completion
set wildmode=longest,list,full


" highlight search
set incsearch           " search as characters are typed
set hlsearch            " highlight matches
nmap <leader>hl :let @/ = ""<CR>
nnoremap <esc> :noh<return><esc> " escape turns off highlight

"}}}

" GUI Specific  Settings {{{
if (&t_Co == 256 || has('gui_running'))
  if ($TERM_PROGRAM == ('iTerm.app'||'Apple_Terminal'))
    set background=dark
    colorscheme solarized
  else
    colorscheme desert
  endif
endif

"Enble basic mouse behavior such as resizing buffers.
set mouse=a
if exists('$TMUX')  " Support resizing in tmux
  " set ttymouse=xterm2
endif

" }}}

" Keyboard Shortcuts {{{
let mapleader = ','
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <leader>l :Align
nnoremap <leader>a :Ag<space>
nnoremap <leader>b :CtrlPBuffer<CR>
nnoremap <leader>d :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>
nnoremap <leader>t :CtrlP<CR>
nnoremap <leader>T :CtrlPClearCache<CR>:CtrlP<CR>
nnoremap <leader>] :TagbarToggle<CR>
nnoremap <leader><space> :call whitespace#strip_trailing()<CR>
nnoremap <leader>g :GitGutterToggle<CR>
noremap <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>
"}}}
"
" Searching {{{
"
" plugin settings
let g:ctrlp_match_window = 'order:ttb,max:20'
let g:NERDSpaceDelims=1
let g:gitgutter_enabled = 0

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" }}}

" Folding {{{
set foldenable
set foldlevelstart=10     "open most folds by default
set foldnestmax=10        " 10 nested fold max
set foldmethod=indent     " fold based on indent unless overridden
" Folding controls
noremap <space> za        " open/close folds
" }}}

" Movement {{{
nnoremap gV `[v`]         " highlight last inserted text
" Remap return and backspace to go to next Hunk
nnoremap <silent> <cr> :GitGutterNextHunk<cr>
nnoremap <silent> <backspace> :GitGutterPrevHunk<cr>
" }}}

" Tmux {{{

" allows cursor change in tmux mode
" if exists('$TMUX')
"     let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
"     let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
" else
"     let &t_SI = "\<Esc>]50;CursorShape=1\x7"
"     let &t_EI = "\<Esc>]50;CursorShape=0\x7"
" endif

" vim-tmux-pilot settings
" Uncomment to enable navigation of vim tabs
" let g:pilot_mode='wintab'

" Uncomment to enable creation of vim splits automatically
" 'ignore' ('create', 'reflect') Boundary condition
" let g:pilot_boundary='create'
"
" defaults to 'tsplit' ('vtab') Precedence between vtabs and tsplits
" let g:pilot_precedence='vtab'

" }}}

" Custom Functions {{{
function! s:ShowMaps()
  let old_reg = getreg("a")          " save the current content of register a
  let old_reg_type = getregtype("a") " save the type of the register as well
try
  redir @a                           " redirect output to register a
  " Get the list of all key mappings silently, satisfy "Press ENTER to continue"
  silent map | call feedkeys("\<CR>")
  redir END                          " end output redirection
  vnew                               " new buffer in vertical window
  put a                              " put content of register
  " Sort on 4th character column which is the key(s)
  %!sort -k1.4,1.4
finally                              " Execute even if exception is raised
  call setreg("a", old_reg, old_reg_type) " restore register a
endtry
endfunction
com! ShowMaps call s:ShowMaps()      " Enable :ShowMaps to call the function

nnoremap \m :ShowMaps<CR>            " Map keys to call the function

" Disambiguate ,a & ,t from the Align plugin, making them fast again.
"
" This section is here to prevent AlignMaps from adding a bunch of mappings
" that interfere with the very-common ,a and ,t mappings. This will get run
" at every startup to remove the AlignMaps for the *next* vim startup.
"
" If you do want the AlignMaps mappings, remove this section, remove
" ~/.vim/bundle/Align, and re-run rake in maximum-awesome.
function! s:RemoveConflictingAlignMaps()
  if exists("g:loaded_AlignMapsPlugin")
    AlignMapsClean
  endif
endfunction
command! -nargs=0 RemoveConflictingAlignMaps call s:RemoveConflictingAlignMaps()
silent! autocmd VimEnter * RemoveConflictingAlignMaps

" }}}

" vim:foldmethod=marker:foldlevel=0
