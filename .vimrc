" redoing .vimrc to be simpler

set nocompatible


"{{{ Plugin Managment
" Configure Vim-Plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" call plug#begin('~/.vim/bundle')
call plug#begin('~/.local/share/nvim/plugged')

" Base Plugins
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'rking/ag.vim'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'vim-scripts/restore_view.vim'
set viewoptions=cursor,slash,unix
let g:skipview_files = ['*\.vim']
Plug 'junegunn/vim-easy-align'
Plug 'yggdroot/indentLine'

" Tmux Tools
Plug 'tmux-plugins/vim-tmux'
Plug 'urbainvaes/vim-tmux-pilot'
Plug 'benmills/vimux'

" Syntax
Plug 'sheerun/vim-polyglot'   " Polyglot autoloads many language packs replacing:
" Plug 'pearofducks/ansible-vim'
" Plug 'fatih/vim-go'
" Plug 'glench/vim-jinja2-syntax'
" Plug 'hashivim/vim-terraform'
Plug 'isene/hyperlist.vim'
Plug 'towolf/vim-helm'
let g:polyglot_disabled = ['asciidoc'] " disabled since asciidoc is out of date

" Asciidoc
Plug 'dahu/vim-asciidoc'
Plug 'dahu/asif'
Plug 'dahu/vimple'
Plug 'vim-scripts/SyntaxRange'
Plug 'raimondi/vimregstyle'

" Code Helpers
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'majutsushi/tagbar'
Plug 'mustache/vim-mustache-handlebars'
let g:mustache_abbreviations = 1
Plug 'nvie/vim-flake8'
Plug 'w0rp/ale'
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
Plug 'sirver/ultisnips'
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
Plug 'honza/vim-snippets'
" Plug 'ivanov/vim-ipython'
Plug 'valloric/youcompleteme'
" Plug 'davidhalter/jedi-vim' "awesome Python autocompletion with VIM

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
" Plug 'benekastah/neomake', Cond(has('nvim'), { 'on': 'Neomake' })
Plug 'junegunn/vim-xmark', { 'do': 'make' } ", Cond(has('macunix'))
call plug#end()

"{{{ Plugin Settings

"let python_highlights_all=1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='solarized'
let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']
let g:ale_open_list = 0
let g:ale_set_quickfix = 1
" let b:ale_linters = ['pyflakes', 'flake8', 'pylint']
let g:ale_python_flake8_args="--ignore=E501"
let g:ansible_attribute_highlight = "ab"
let g:ansible_extra_keywords_highlight = 1
let g:ansible_name_highlight = 'd'
" let g:ansible_unindent_after_newline = 1
let g:gitgutter_enabled = 1
let g:gitgutter_hightlight_lines = 1
let g:terraform_fold_sections=1

"}}}

"}}}
" Autogroups {{{
"
" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

augroup myvimrc
    au!
    au BufWritePost .vimrc,_vimrc,vimrc,init.vim,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END

" Override for yaml hosts format instead of INI
" augroup ansible_vim_fthosts
"   autocmd!
"   autocmd BufNewFile,BufRead hosts setfiletype yaml.ansible
" augroup END

" Ale windows close automatically on buffer close
augroup CloseLoclistWindowGroup
  autocmd!
  autocmd QuitPre * if empty(&buftype) | lclose | endif
augroup END

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
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
autocmd FileType gitconfig setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype javascript setlocal ts=2 sts=2 sw=2 noexpandtab
autocmd BufRead,BufNewFile Vagrantfile setfiletype ruby
" auto-delete buffers after browing through objects
autocmd BufReadPost fugitive://* set bufhidden=delete
autocmd BufRead,BufNewFile *.ics set filetype=icalendar


autocmd FileType mail,text,html,asciidoc setlocal spell spelllang=en
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
autocmd BufRead,BufNewFile *.txt,*.asciidoc,README,TODO,CHANGELOG,NOTES,ABOUT
    \ setlocal autoindent expandtab tabstop=8 softtabstop=2 shiftwidth=2 filetype=asciidoc
    \ textwidth=70 wrap formatoptions=tcqn
    \ formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\\|^\\s*<\\d\\+>\\s\\+\\\\|^\\s*[a-zA-Z.]\\.\\s\\+\\\\|^\\s*[ivxIVX]\\+\\.\\s\\+
    \ comments=s1:/*,ex:*/,://,b:#,:%,:XCOMM,fb:-,fb:*,fb:+,fb:.,fb:>
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

" " Spaces and Tabs {{{
" set tabstop=4             " number of visual spaces per TAB
" set softtabstop=4         " number of spaces in tab when editing
" set expandtab             " tabs are spaces

" " }}}


" highlight search
set incsearch           " search as characters are typed
set hlsearch            " highlight matches
nmap <leader>hl :let @/ = ""<CR>
nnoremap <esc> :noh<return><esc> " escape turns off highlight

"}}}
" GUI Specific  Settings {{{
if (&t_Co == 256 || has('gui_running'))
  if ($TERM_PROGRAM == ('iTerm.app'||'Apple_Terminal'))
    " set termguicolors
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
" esc in insert mode
inoremap kj <esc>
let mapleader = ';'
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
nnoremap <leader>a :Ag<space>
" nnoremap <leader>b :CtrlPBuffer<CR>
nnoremap <leader>d :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>
noremap <leader>l :EasyAlign
nnoremap <leader>t :CtrlP<CR>
nnoremap <leader>T :CtrlPClearCache<CR>:CtrlP<CR>
nnoremap <leader>s% : source %<CR>
nnoremap <leader>] :TagbarToggle<CR>
nnoremap <leader><space> :call whitespace#strip_trailing()<CR>
nnoremap <leader>g :GitGutterToggle<CR>
noremap <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" fzf
" nmap <silent> <C-P> :Files<CR>
" nmap <silent> <leader>f :Files<CR>
" nmap <silent> <leader>t :Trees<CR>
nmap <silent> <leader>r :History<CR>
nmap <silent> <leader>b :Buffers<CR>
nmap <silent> <leader>m :Map<CR>
" nmap <silent> <leader>w :Windows<CR>
" nmap <silent> <leader>: :Commands<CR>
"}}}
" Searching {{{
"
" plugin settings
let g:ctrlp_match_window = 'order:ttb,max:20'
let g:NERDSpaceDelims=1

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
let g:pilot_mode='wintab'

" Uncomment to enable creation of vim splits automatically
" 'ignore' ('create', 'reflect') Boundary condition
let g:pilot_boundary='create'
"
" defaults to 'tsplit' ('vtab') Precedence between vtabs and tsplits
let g:pilot_precedence='vtab'

" }}}
" Custom Functions {{{

" function! Cond(cond, ...)
"   let opts = get(a:000, 0, {})
"   return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
" endfunction

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
" function! s:RemoveConflictingAlignMaps()
"   if exists("g:loaded_AlignMapsPlugin")
"     AlignMapsClean
"   endif
" endfunction
" command! -nargs=0 RemoveConflictingAlignMaps call s:RemoveConflictingAlignMaps()
" silent! autocmd VimEnter * RemoveConflictingAlignMaps

" }}}
" vim:foldmethod=marker:foldlevel=0
