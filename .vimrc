" redoing .vimrc to be simpler

set nocompatible

"{{{ Neovim Specific configs
if has('nvim')
  set inccommand=nosplit
endif
"}}}
" {{{ Plugin Managment
" Configure Vim-Plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')
" call plug#begin('~/.local/share/nvim/plugged')

" Base Plugins
Plug 'tpope/vim-sensible'   " Sensible vim defaults
Plug 'tpope/vim-unimpaired' " Pairs of handy bracket mappings
Plug 'tpope/vim-repeat'     " Add repeat support with '.' for lots of plugins
Plug 'gabesoft/vim-ags'     " A Vim plugin for the silver searcher that focuses on clear display of the search results
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'vim-scripts/restore_view.vim'
set viewoptions=cursor,slash,unix
let g:skipview_files = ['*\.vim']
Plug 'yggdroot/indentLine'
Plug 'janko-m/vim-test'

" Tmux Tools
Plug 'tmux-plugins/vim-tmux'
" Plug 'christoomey/vim-tmux-navigator'
" Plug 'urbainvaes/vim-tmux-pilot'
Plug 'benmills/vimux'                   " vim plugin to interact with tmux

" Visual{{{
Plug 'altercation/vim-colors-solarized' " Ethan's best
Plug 'lifepillar/vim-solarized8'
Plug 'majutsushi/tagbar'                " Open tag navigation split with :Tagbar
Plug 'ryanoasis/vim-devicons'
Plug 'itchyny/lightline.vim'            " New statusline tool, replaced airline
" Do not need to show -- Insert --, as lightline handles it already
set noshowmode
Plug 'maximbaz/lightline-ale'

" let g:lightline.colorscheme = 'solarized'
let g:lightline = { 'colorscheme': 'solarized'}
let g:lightline.active =  {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [['lineinfo'], ['percent'],
      \             ['readonly', 'linter_checking', 'linter_warnings', 'linter_errors', 'linter_ok']]
      \ }
let g:lightline.component_function = { 'gitbranch': 'fugitive#head' }
let g:lightline.component_expand = {
      \   'linter_checking': 'lightline#ale#checking',
      \   'linter_warnings': 'lightline#ale#warnings',
      \   'linter_errors': 'lightline#ale#errors',
      \   'linter_ok': 'lightline#ale#ok',
      \ }
let g:lightline.component_type = {
      \   'readonly': 'error',
      \   'linter_checking': 'left',
      \   'linter_warnings': 'warning',
      \   'linter_errors': 'error',
      \   'linter_ok': 'left',
      \ }
let g:lightline#ale#indicator_checking = "\uf110"
let g:lightline#ale#indicator_warnings = "⚠ "
let g:lightline#ale#indicator_errors = " "
let g:lightline#ale#indicator_ok = ""
"}}}
" Syntax{{{
Plug 'sheerun/vim-polyglot' " Polyglot autoloads many language packs replacing: {{{
                            " Plug 'pearofducks/ansible-vim'
                            " Plug 'fatih/vim-go'
                            " Plug 'glench/vim-jinja2-syntax'
                            " Plug 'hashivim/vim-terraform'
let g:polyglot_disabled = ['asciidoc'] " disabled since asciidoc is out of date
let g:ansible_attribute_highlight = "ab"
let g:ansible_extra_keywords_highlight = 1
let g:ansible_name_highlight = 'd'
" let g:ansible_unindent_after_newline = 1
let g:terraform_fold_sections=1
                            " }}}
Plug 'isene/hyperlist.vim'
Plug 'towolf/vim-helm'
"}}}
" Asciidoc{{{
Plug 'dahu/vim-asciidoc'
Plug 'dahu/asif'
Plug 'dahu/vimple'
Plug 'vim-scripts/SyntaxRange'
Plug 'raimondi/vimregstyle'
"}}}
" Editing{{{
Plug 'tpope/vim-surround' " Adds the surround motion bound to s
Plug 'tpope/vim-commentary' " Adds comment action with 'gc'
Plug 'mhinz/vim-grepper'      " ...helps you win at grep

Plug 'junegunn/vim-easy-align' "
let g:easy_align_ignore_comment = 0 " align comments
vnoremap <silent> <Enter> :EasyAlign<cr>
"}}}
" Git{{{
Plug 'tpope/vim-fugitive'          " Git plugin with commands 'G<command>'
Plug 'airblade/vim-gitgutter'      " Show git diff in number column {{{
let g:gitgutter_enabled = 1
let g:gitgutter_hightlight_lines = 1 " }}}
Plug 'tpope/vim-rhubarb'           " Github extension for fugitive.vim
Plug 'jreybert/vimagit'            " Modal git editing with <leader>g
Plug 'Xuyuanp/nerdtree-git-plugin' " A plugin of NERDTree showing git status flags.}}}

Plug 'mustache/vim-mustache-handlebars'
let g:mustache_abbreviations = 1
Plug 'nvie/vim-flake8'
Plug 'w0rp/ale' " {{{
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_open_list = 0
let g:ale_set_quickfix = 1
" let b:ale_linters = ['prettier', 'yamllint', 'pyflakes', 'flake8', 'pylint']
let g:ale_fixers = ['prettier', 'shfmt' ]
let g:ale_python_flake8_args="--ignore=E501" " }}}
" Plug 'ivanov/vim-ipython'
" Plug 'valloric/youcompleteme'
" Plug 'davidhalter/jedi-vim' "awesome Python autocompletion with VIM
Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
" Plug 'benekastah/neomake', Cond(has('nvim'), { 'on': 'Neomake' })
" Load on nothing
Plug 'SirVer/ultisnips', { 'on': [] }
" Plug 'Valloric/YouCompleteMe', { 'on': [] }
Plug 'honza/vim-snippets', { 'on': [] }

" augroup load_us_ycm
"  autocmd!
"    autocmd InsertEnter * call plug#load('ultisnips', 'YouCompleteMe')
"                         \| autocmd! load_us_ycm
"     let g:UltiSnipsExpandTrigger = '<tab>'
"     let g:UltiSnipsJumpForwardTrigger = '<tab>'
"     let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
"                         augroup END
if has('mac')
    Plug 'junegunn/vim-xmark'
endif
call plug#end()
" }}}
" Autogroups {{{
autocmd VimResized * :wincmd =          " automatically rebalance windows on vim resize

" augroup myvimrc
"     au!
"     au BufWritePost .vimrc,_vimrc,vimrc,init.vim,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
" augroup END

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
" au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:MarkedPreview()

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
" inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
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
set autoread              " reload files when changed on disk, i.e. via `git checkout`
set backspace=2           " Fix broken backspace in some setups
set backupcopy=yes        " see :help crontab
set clipboard=unnamed     " yank and paste with the system clipboard
set cmdheight=2           " Better display for messages
set directory-=.          " don't store swapfiles in the current directory
set diffopt=filler,vertical,hiddenoff
set encoding=utf-8
set expandtab             " expand tabs to spaces
set gdefault              " Global Repalcement by default https://bluz71.github.io/2019/03/11/find-replace-helpers-for-vim.html
set hidden
set ignorecase            " case-insensitive search
set incsearch             " search as you type
set laststatus=2          " always show statusline
set list                  " show trailing whitespace
set listchars=tab:▸\ ,trail:▫
set modelines=1
set relativenumber number " show line number on current line relative number elsewhere
set cursorline            " don't highlight current line
set ruler                 " show where you are
set scrolloff=3           " show context above/below cursorline
set shiftwidth=2          " normal mode indentation commands use 2 spaces
set showcmd
set smartcase             " case-sensitive search if any caps
set softtabstop=2         " insert mode tab and backspace use 2 spaces
set tabstop=8             " actual tabs occupy 8 characters
set updatetime=250        " Update sign column
set wildignore=log/**,node_modules/**,target/**,tmp/**,*.rbc
set wildmenu              " show a navigable menu for tab completion
set wildmode=longest,list,full

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

if !has('nvim')
  set ttymouse=xterm2
endif

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
nnoremap <leader>d :NERDTreeToggle<CR>
nnoremap <leader>g :GitGutterToggle<CR>
" nnoremap <leader>f :NERDTreeFind<CR>
noremap <leader>l :EasyAlign
nnoremap <leader>s% : source %<CR>
nnoremap <leader>] :TagbarToggle<CR>
nmap <Leader>t :BTags<CR>
nmap <Leader>T :Tags<CR>
nmap <leader>= <Plug>(ale_fix)
nnoremap <leader><space> :call whitespace#strip_trailing()<CR>
noremap <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>
nnoremap  <silent>   <tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bnext<CR>
nnoremap  <silent> <s-tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bprevious<CR>

"" Find and Replace {{{
"nnoremap <silent> \c :let @/='\<'.expand('<cword>').'\>'<CR>cgn
"xnoremap <silent> \c "sy:let @/=@s<CR>cgn
"nnoremap <Enter> gnzz
"xmap <Enter> .<Esc>gnzz
"xnoremap ! <Esc>ngnzz
"autocmd! BufReadPost quickfix nnoremap <buffer> <CR> <CR>
"autocmd! CmdwinEnter *        nnoremap <buffer> <CR> <CR>
nnoremap \s :let @s='\<'.expand('<cword>').'\>'<CR>:%s/<C-r>s//<Left>
xnoremap \s "sy:%s/<C-r>s//<Left>
nnoremap \S
  \ :let @s='\<'.expand('<cword>').'\>'<CR>
  \ :Ag -cword -noprompt<CR>
  \ :cfdo %s/<C-r>s// \| update
  \<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
xmap \S
  \ "sy
  \ gvgr
  \ :cfdo %s/<C-r>s// \| update
  \<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
""}}}
" fzf {{{
" nmap <silent> <C-P> :Files<CR>
nmap <silent> <leader>f :GFiles<CR>
nmap <silent> <leader>F :Files<CR>
" nmap <silent> <leader>t :Trees<CR>
nmap <silent> <leader>h :History<CR>
nmap <silent> <leader>b :Buffers<CR>
nmap <silent> <leader>m :Map<CR>
" nmap <silent> <leader>w :Windows<CR>
" nmap <silent> <leader>: :Commands<CR>
" }}}
" COC Mappings{{{
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
"}}}
"}}}
" Searching {{{

" highlight search
set incsearch           " search as characters are typed
set hlsearch            " highlight matches
nmap <leader>hl :let @/ = ""<CR>
nnoremap <esc> :noh<return><esc> " escape turns off highlight
" needed so that vim still understands escape sequences
nnoremap <esc>^[ <esc>^[

" plugin settings
let g:NERDSpaceDelims=1

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor
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
" Intelligently navigate tmux panes and Vim splits using the same keys.
" See https://sunaku.github.io/tmux-select-pane.html for documentation.
let progname = substitute($VIM, '.*[/\\]', '', '')
set title titlestring=%{progname}\ %f\ +%l\ #%{tabpagenr()}.%{winnr()}
if &term =~ '^screen' && !has('nvim') | exe "set t_ts=\e]2; t_fs=\7" | endif

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
let g:pilot_boundary='reflect'
"
" defaults to 'tsplit' ('vtab') Precedence between vtabs and tsplits
" let g:pilot_precedence='vtab'

" }}}
" Custom Functions {{{

" function! Cond(cond, ...)
"   let opts = get(a:000, 0, {})
"   return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
" endfunction

" Open current file in Marked {{{
function! MarkedPreview()
  :w
  exec ':silent !open -a "Marked.app" ' . shellescape('%:p')
  redraw!
endfunction
nnoremap <leader>e :call MarkedPreview()<CR>
" }}}

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
"
" source ~/.vimrc-coc
" vim:foldmethod=marker:foldlevel=0
