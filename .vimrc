" vim:foldmethod=marker:foldlevel=0
"
"{{{ Neovim Specific configs
if has('nvim')
  set inccommand=nosplit
endif
"}}}

if executable('tmux') && filereadable(expand('~/.bashrc')) && $TMUX !=# ''
  let g:vimIsInTmux = 1
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  " set termguicolors
else
  let g:vimIsInTmux = 0
endif
set nocompatible
" {{{ Plugin Managment
" {{{ Bootstrap Plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
"}}}
call plug#begin('~/.local/share/nvim/plugged')
" {{{ Base Plugins
Plug 'tpope/vim-sensible'   " Sensible vim defaults
Plug 'tpope/vim-unimpaired' " Pairs of handy bracket mappings
Plug 'tpope/vim-repeat'     " Add repeat support with '.' for lots of plugins
Plug 'gabesoft/vim-ags'     " A Vim plugin for the silver searcher that focuses on clear display of the search results
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'vim-scripts/restore_view.vim'
set viewoptions=cursor,slash,unix
let g:skipview_files = ['*\.vim']
Plug 'yggdroot/indentLine'  " A vim plugin to display the indention levels with thin vertical lines
Plug 'janko-m/vim-test'
Plug 'sunaku/tmux-navigate'
" }}}
" {{{ Code Completion
" source ~/.config/coc/coc.vimrc
" }}}
" {{{ Visual
Plug 'altercation/vim-colors-solarized', {'do': ':so $HOME/.local/share/nvim/plugged/vim-colors-solarized/autoload/togglebg.vim' } " Ethan's best
let g:solarized_termtrans=0          " This gives me a dark background, but breaks light/dark toggle
let g:solarized_visibility="normal"  " Special characters such as trailing whitespace, tabs, newlines, when displayed using :set list

Plug 'majutsushi/tagbar'                " Open tag navigation split with :Tagbar
Plug 'ryanoasis/vim-devicons'
" {{{ Syntax
Plug 'sheerun/vim-polyglot' " Polyglot autoloads many language packs replacing: {{{
let g:polyglot_disabled = ['asciidoc','ansible','terraform','helm','yaml'] " disabled since asciidoc is out of date
let g:ansible_attribute_highlight = "ab"
let g:ansible_extra_keywords_highlight = 1
let g:ansible_name_highlight = 'd'
" let g:ansible_unindent_after_newline = 1
let g:terraform_fold_sections=1
" plasticboy/vim-markdown{{{
autocmd FileType markdown let b:sleuth_automatic=0
autocmd FileType markdown set conceallevel=2
autocmd FileType markdown normal zR

let g:vim_markdown_frontmatter=1
let g:vim_markdown_strikethrough=1
let g:vim_markdown_autowrite = 1
let g:vim_markdown_follow_anchor = 1
let g:vim_markdown_no_extensions_in_markdown = 1
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'yaml']
"}}}


" }}}
Plug 'fatih/vim-go'
" Plug 'glench/vim-jinja2-syntax'
Plug 'habamax/vim-asciidoctor'
Plug 'hashivim/vim-terraform'
Plug 'isene/hyperlist.vim'
Plug 'pearofducks/ansible-vim'
Plug 'pedrohdz/vim-yaml-folds'
Plug 'reedes/vim-pencil'
Plug 'stephpy/vim-yaml'
Plug 'towolf/vim-helm'
" Plug 'vim-pandoc/vim-pandoc'
" Plug 'vim-pandoc/vim-pandoc-syntax'
" Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' }
"}}}
" }}}
" {{{ Statusline (lightline)
Plug 'itchyny/lightline.vim'            " New statusline tool, replaced airline
Plug 'macthecadillac/lightline-gitdiff' " show a concise summary of changes since the last commit using git diff.
Plug 'albertomontesg/lightline-asyncrun'" Async jobs indicator for the lightline vim plugin
Plug 'rmolin88/pomodoro.vim'            " im plugin for the Pomodoro time management technique
Plug 'maximbaz/lightline-ale'           " ALE indicator for the lightline vim plugin
"}}}
" {{{ Editing
Plug 'editorconfig/editorconfig-vim' "Allows project wide consistent coding styles
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

Plug 'tmux-plugins/vim-tmux'  " Provides tmux.conf syntax highlighting and some functions
Plug 'tpope/vim-surround'     " Adds the surround motion bound to s
Plug 'tpope/vim-commentary'   " Adds comment action with 'gc'
" Plug 'pelodelfuego/vim-swoop' " It allows you to find and replace occurrences in many buffers being aware of the context.
Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }      " ...helps you win at grep
Plug 'junegunn/vim-easy-align'
let g:easy_align_ignore_comment = 0 " align comments
" My attempt to create an a)rg alignment for --arguments
let g:easy_align_delimiters = {
      \ 'a': { 'pattern': "\-\-*", 'left_margin': 1, 'right_margin': 0 } }
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
vnoremap <silent> <Enter> :EasyAlign<cr>

" Maybe this will work with obsidian?
" Plug 'https://github.com/alok/notational-fzf-vim'
  " let g:nv_search_paths = ['~/Documents/Notes', './docs', './doc', 'docs.md' , './notes.md']
  " " String. Must be in the form 'ctrl-KEY' or 'alt-KEY'
  " let g:nv_create_note_key = 'alt-z'
  " nnoremap <silent> <C-p> :NV<CR> " Notational Velocity Trigger

Plug 'dense-analysis/ale' " {{{ ALE and it's Options
" nmap <silent> <C-k> <Plug>(ale_previous_wrap)
" nmap <silent> <C-j> <Plug>(ale_next_wrap)
let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_open_list = 0
" let g:ale_list_vertical = 1
let g:ale_set_quickfix = 0
let b:ale_linters = ['proselint', 'tflint', 'shellcheck', 'vint', 'prettier', 'yamllint', 'pyflakes', 'flake8', 'pylint']
let g:ale_fixers = ['prettier', 'shfmt' ]
let g:ale_python_flake8_args="--ignore=E501" " }}}
" }}}
" {{{ Git Plugins
Plug 'tpope/vim-fugitive'          " Git plugin with commands 'G<command>'
Plug 'airblade/vim-gitgutter'      " Show git diff in number column
let g:gitgutter_enabled = 1
let g:gitgutter_hightlight_lines = 0
let g:gitgutter_set_sign_backgrounds = 0

Plug 'tpope/vim-rhubarb'           " Github extension for fugitive.vim
" Plug 'jreybert/vimagit'            " Modal git editing with <leader>g
Plug 'Xuyuanp/nerdtree-git-plugin' " A plugin of NERDTree showing git status flags.

Plug 'mustache/vim-mustache-handlebars'
let g:mustache_abbreviations = 1
Plug 'nvie/vim-flake8'
" }}}
" {{{ Tmux Tools

" Plug 'edkolev/tmuxline.vim', { 'on': ['Tmuxline', 'TmuxlineSimple', 'TmuxlineSnapshot'] }
" Plug 'christoomey/vim-tmux-navigator'
" Plug 'urbainvaes/vim-tmux-pilot'
" Plug 'benmills/vimux'                   " vim plugin to interact with tmux
" }}}
" {{{ On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

if has('mac')
    Plug 'junegunn/vim-xmark'
endif
call plug#end()
" }}}
" }}} Plugin Managment
" {{{ Lightline Configuration
set laststatus=2
set noshowmode    " Do not need to show -- Insert --, as lightline handles it already
" autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

" augroup lightlineCustom
"   autocmd
"   autocmd BufWritePost * call lightline_gitdiff#query_git() | call lightline#update()
" augroup END
augroup LightlineColorscheme "{{{
  autocmd!
  autocmd ColorScheme * call s:lightline_update()
augroup END "}}}
function! s:lightline_update() "{{{
  if !exists('g:loaded_lightline')
    return
  endif
  try
    if g:colors_name =~# 'wombat\|solarized\|landscape\|jellybeans\|seoul256\|Tomorrow'
      let g:lightline.colorscheme =
            \ substitute(substitute(g:colors_name, '-', '_', 'g'), '256.*', '', '')
      call lightline#init()
      runtime autoload/lightline/colorscheme/solarized.vim
      call lightline#colorscheme()
      call lightline#update()
      command Tmuxline lightline
      command TmuxlineSnapshot! ~/.tmux/snapshot
    endif
  catch
  endtry
endfunction "}}}
function! ToggleSolarizedTheme() "{{{ change background and update lightline color scheme
  let &background = ( &background == "dark"? "light" : "dark" )
  if exists("g:lightline")
    runtime autoload/lightline/colorscheme/solarized.vim
    call lightline#colorscheme()
    " call tmuxline#apply(lightline)
  endif
endfunction
map <F5> : call ToggleSolarizedTheme()<CR> "}}}
function! TmuxBindLock() abort"{{{
  if filereadable('/tmp/.tmux-bind.lck')
    return "\uf13e"
  else
    return "\uf023"
  endif
endfunction"}}}
function! Devicons_Filetype() "{{{
  let filetype = winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' .  WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
  return filetype
endfunction "}}}
function! Devicons_Fileformat()"{{{
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction"}}}
function! LightlineReadonly()"{{{
  return &readonly ? '' : ''
endfunction"}}}
function! LightlineFugitive() abort "{{{
  if &filetype ==# 'help'
    return ''
  endif
  if has_key(b:, 'lightline_fugitive') && reltimestr(reltime(b:lightline_fugitive_)) =~# '^\s*0\.[0-5]'
    return b:lightline_fugitive
  endif
  try
    if exists('*fugitive#head')
      let head = fugitive#head()
    else
      return ''
    endif
    let b:lightline_fugitive = head
    let b:lightline_fugitive_ = reltime()
    return b:lightline_fugitive
  catch
  endtry
  return ''
endfunction "}}}
function! LightlineGitBlame() abort"{{{
  let blame = get(b:, 'coc_git_blame', '')
  " return blame
  return winwidth(0) > 120 ? blame : ''
endfunction"}}}
let g:lightline#bufferline#enable_devicons = 1
let g:lightline#ale#indicator_checking     = "\uf110"
let g:lightline#ale#indicator_warnings     = "⚠ "
let g:lightline#ale#indicator_errors       = " "
let g:lightline#ale#indicator_ok           = ""

let g:lightline_gitdiff#indicator_added    = '+'
let g:lightline_gitdiff#indicator_deleted  = '-'
let g:lightline_gitdiff#indicator_modified = '!'
let g:lightline_gitdiff#min_winwidth       = '70'
let g:lightline = { 'colorscheme': 'solarized'}
" let g:lightline.separator = { 'left': '', 'right': '' }
" let g:lightline.subseparator = { 'left': '', 'right': '' }
" let g:lightline.separator = { 'left': '⮀', 'right': '⮂' },
" let g:lightline.subseparator = { 'left': '⮁', 'right': '⮃' }
let g:lightline.active =  {
      \   'left': [ [ 'mode' , 'paste', ],
      \             [ 'fugitive', 'git', 'diagnostic', 'cocstatus',
      \             'currentfunction', 'readonly', 'filename' ] ],
      \   'right': [['lineinfo'],
      \             [ 'devicons_filetype', 'devicons_fileformat'],
      \             ['linter_checking', 'linter_warnings', 'linter_errors',
      \             'linter_ok'],
      \             ['blame'], ]
      \ }
let g:lightline.inactive = {
      \   'left': [ [ 'fugitive', 'filename', 'modified', ] ],
      \   'right': [ [ 'devicons_filetype' ] ]
      \ }
let g:lightline.component = {
      \ 'absolutepath': '%F',
      \ 'bufinfo': '%{bufname("%")}:%{bufnr("%")}',
      \ 'bufnum': '%n',
      \ 'charvalue': '%b',
      \ 'charvaluehex': '%B',
      \ 'close': '%999X X ',
      \ 'column': '%c',
      \ 'fileencoding': '%{&fenc!=#""?&fenc:&enc}',
      \ 'fileformat': '%{&fenc!=#""?&fenc:&enc}[%{&ff}]',
      \ 'filename': '%t',
      \ 'filesize': "%{HumanSize(line2byte('$') + len(getline('$')))}",
      \ 'filetype': '%{&ft!=#""?&ft:"no ft"}',
      \ 'gitstatus' : '%{lightline_gitdiff#get_status()}',
      \ 'line': '%l',
      \ 'lineinfo': '%3l:%-2v|%2p%%',
      \ 'lineinfo2': '%3l:%-2v%3p%%%<',
      \ 'mode': '%{lightline#mode()}',
      \ 'modified': '%M',
      \ 'obsession': '%{ObsessionStatusEnhance()}',
      \ 'paste': '%{&paste?"PASTE":""}',
      \ 'percent': '%2p%%',
      \ 'percentwin': '%P',
      \ 'pomodoro': '%{PomodoroStatus()}',
      \ 'readonly': '%R',
      \ 'relativepath': '%f',
      \ 'spell': '%{&spell?&spelllang:""}',
      \ 'tmuxlock': '%{TmuxBindLock()}',
      \ 'vim_logo': "\ue7c5",
      \ 'winnr': '%{winnr()}'
      \ }
let g:lightline.component_function = {
      \ 'devicons_filetype':    'Devicons_Filetype',
      \ 'devicons_fileformat':  'Devicons_Fileformat',
      \ 'cocstatus':            'coc#status',
      \ 'currentfunction':      'CocCurrentFunction',
      \ 'readonly':             'LightlineReadonly',
      \ 'fugitive':             'LightlineFugitive',
      \ 'blame':                'LightlineGitBlame'
      \ }
let g:lightline.component_expand = {
      \   'linter_checking': 'lightline#ale#checking',
      \   'linter_warnings': 'lightline#ale#warnings',
      \   'linter_errors':   'lightline#ale#errors',
      \   'linter_ok':       'lightline#ale#ok',
      \   'asyncrun_status': 'lightline#asyncrun#status'
      \ }
let g:lightline.component_type = {
      \   'readonly':        'error',
      \   'linter_checking': 'left',
      \   'linter_warnings': 'warning',
      \   'linter_errors':   'error',
      \   'linter_ok':       'left',
      \ }
let g:lightline.component_visible_condition = {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \ }
let g:lightline.component_function_visible_condition = {
      \   'coc_status': 'g:vimMode ==# "complete"',
      \   'coc_current_function': 'g:vimMode ==# "complete"'
      \ }
" }}} Lightline Config
" Autogroups {{{
" {{{ Reload VIM
if has ('autocmd') " Remain compatible with earlier versions
 augroup vimrc     " Source vim configuration upon save
    autocmd! BufWritePost $MYVIMRC nested source % | echom "Reloaded " . $MYVIMRC | redraw
    autocmd! BufWritePost $MYGVIMRC if has('gui_running') | so % | echom "Reloaded " . $MYGVIMRC | endif | redraw
    autocmd User CocGitStatusChange lightline_update()
  augroup END
endif " has autocmd
" }}}
autocmd VimResized * :wincmd =          " automatically rebalance windows on vim resize

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

" from https://github.com/settermjd/vim-for-technical-writers/blob/master/.vimrc
" vim-pencil configuration
" For further options see https://github.com/reedes/vim-pencil
" let g:pencil#wrapModeDefault = 'soft'   " default is 'hard'
augroup pencil
  autocmd!
  "
  " Apply for Markdown and reStructuredText
  autocmd FileType markdown,mkd,md,rst,asciidoc call pencil#init({'wrap': 'soft'})
  " autocmd FileType markdown,mkd,md call SetMarkdownOptions()
  " autocmd FileType rst call SetRestructuredTextOptions()
  autocmd FileType c,h call SetCOptions()
  autocmd FileType go       call SetGoOptions()
  autocmd FileType Makefile call SetMakefileOptions()
  autocmd FileType text            call pencil#init({'wrap': 'soft'})

augroup END

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
" fdoc is yaml
autocmd BufRead,BufNewFile *.fdoc set filetype=yaml
" md is markdown
" autocmd BufRead,BufNewFile *.md set filetype=markdown
" autocmd BufRead,BufNewFile *.md set spell
" " au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:MarkedPreview()

" autocmd BufWritePre *.php,*.py,*.js,*.txt,*.hs,*.java,*.md
"                 \:call <SID>StripTrailingWhitespaces()
" For all text files set 'textwidth' to 78 characters.
autocmd FileType text setlocal textwidth=78 ts=2 sw=2
autocmd FileType make set tabstop=8 noexpandtab shiftwidth=8 softtabstop=0
autocmd FileType gitconfig setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype javascript setlocal ts=2 sts=2 sw=2 noexpandtab
autocmd BufRead,BufNewFile Vagrantfile setfiletype ruby
" auto-delete buffers after browsing through objects
autocmd BufReadPost fugitive://* set bufhidden=delete
autocmd BufRead,BufNewFile *.ics set filetype=icalendar

" Set Spelling for various filetypes
autocmd FileType gitcommit,mail,text,html,asciidoc setlocal spell spelllang=en
" inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
autocmd BufRead,BufNewFile *.txt,*.asciidoc,README,TODO,CHANGELOG,NOTES,ABOUT
    \ setlocal autoindent expandtab tabstop=8 softtabstop=2 shiftwidth=2 filetype=asciidoc
    \ textwidth=70 wrap formatoptions=tcqn
    \ formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\\|^\\s*<\\d\\+>\\s\\+\\\\|^\\s*[a-zA-Z.]\\.\\s\\+\\\\|^\\s*[ivxIVX]\\+\\.\\s\\+
    \ comments=s1:/*,ex:*/,://,b:#,:%,:XCOMM,fb:-,fb:*,fb:+,fb:.,fb:>
" }}}
" UI Config {{{
syntax enable
set autoindent
set autoread                      " reload files when changed on disk, i.e. via `git checkout`
set background=dark
set backspace=2                   " Fix broken backspace in some setups
set backupcopy=yes                " see :help crontab
set breakindent                   " set indent on wrapped lines
set breakindentopt=shift:2
" set clipboard=unnamed,unnamedplus " yank and paste with the system clipboard
set clipboard=unnamed             " yank and paste with the system clipboard
set cmdheight=1                   " Better display for messages (when using COC)
set cursorline                    " don't highlight current line
set diffopt=filler,vertical,hiddenoff
set directory-=.                  " don't store swapfiles in the current directory
set encoding=utf-8
set expandtab                     " expand tabs to spaces
set gdefault                      " Global Replacement by default https://bluz71.github.io/2019/03/11/find-replace-helpers-for-vim.html
set hidden
set ignorecase                    " case-insensitive search
set incsearch                     " search as you type
set laststatus=2                  " always show statusline
set list                          " show trailing whitespace
set listchars=tab:▸\ ,trail:▫     " define the characters used for displaying invisible
set modelines=1
set relativenumber number         " show line number on current line relative number elsewhere
set ruler                         " show where you are
set scrolloff=3                   " show context above/below cursorline
set shiftwidth=2                  " normal mode indentation commands use 2 spaces
" set showbreak=↳                 " Wrapped line symbol
set showcmd
set shortmess+=c                  " Coc: Don't pass messages to |ins-completion-menu|.
if has("patch-8.1.1564")
  set signcolumn=number           " New commbined colume
else
  set signcolumn=yes              " Consistent column for Coc
endif
set smartcase                     " case-sensitive search if any caps
set smartindent
set softtabstop=2                 " insert mode tab and backspace use 2 spaces
set tabstop=8                     " actual tabs occupy 8 characters
set updatetime=250                " Update sign column
set wildignore=log/**,node_modules/**,target/**,tmp/**,*.rbc,*.pyc,__pycache__
" set wildmenu              " show a navigable menu for tab completion
set wildmode=list:longest,list:full

colorscheme solarized
" added to fix gitgutter sign column color issue
autocmd ColorScheme * highlight! link SignColumn LineNr
" Copy/Paste {{{
" Don't copy the contents of an overwritten selection.
vnoremap p "_dP
" }}}
" Folding {{{
set foldenable
set foldlevelstart=10     "open most folds by default
set foldnestmax=10        " 10 nested fold max
set foldmethod=marker     " fold based on indent unless overridden
" }}}
" Searching {{{

" highlight search
set incsearch           " search as characters are typed
set hlsearch            " highlight matches
nmap <leader>hl :let @/ = ""<CR>
nnoremap <esc> :noh<return><esc> " escape turns off highlight
" needed so that vim still understands escape sequences
nnoremap <esc>^[ <esc>^[

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor
endif

" Settings for FZF
" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" You can set up fzf window using a Vim command (Neovim or latest Vim 8
" required)

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.7 } }

" }}}
"}}}
" GUI Specific  Settings {{{
" if (&t_Co == 256 || has('gui_running'))
"   if ($TERM_PROGRAM == ('iTerm.app'||'Apple_Terminal'))
"     " set termguicolors
" "    let s:tab_settings = system("osascript -e 'tell app \"Terminal\" to get name of (current settings of selected tab of front window)'")
"     if s:tab_settings =~? "Dark"
"     " if s:mode ==? "Totally Dark"
"       set background=dark
"     else
"       set background=light
"     endif
"     colorscheme solarized
"   else
"     colorscheme desert
"   endif

" endif

"Enble basic mouse behavior such as resizing buffers.
set mouse=a

if !has('nvim')
  set ttymouse=xterm2
endif

if exists('$TMUX')  " Support resizing in tmux
  " set ttymouse=xterm2
endif

" }}}
" Generators{{{
"{{{ tmux statusline generator
" autocmd! User tmuxline.vim
"     \ let g:tmuxline_theme = 'lightline'
"     \ let g:tmuxline_preset = 'minimal'
"     \ let g:tmuxline_powerline_separators = 0
"     \ }
augroup tmuxline
  autocmd!
  autocmd VimEnter, colorscheme * silent! Tmuxline lightline gregsblend
  autocmd VimLeave * !tmux source-file ~/.tmux.conf
augroup END
if g:vimIsInTmux == 1
" let g:tmuxline_theme = {
"     \   'a'    : [ 8, 4 ],
"     \   'b'    : [ 253, 239 ],
"     \   'c'    : [ 244, 236 ],
"     \   'x'    : [ 244, 236 ],
"     \   'y'    : [ 253, 239 ],
"     \   'z'    : [ 236, 103 ],
"     \   'win'  : [ 14, 8 ],
"     \   'cwin' : [ 0, 11 ],
"     \   'bg'   : [ 244, 236 ],
"     \ }
" values represent: [ FG, BG, ATTR ]
" "   FG ang BG are color codes
" "   ATTR (optional) is a comma-delimited string of one or more of bold, dim,
" underscore, etc. For details refer to the STYLE section in the tmux man page
"
let g:tmuxline_preset = {
    \'a'       : '#S',
    \'win'     : ['#I','#W'],
    \'cwin'    : ['#I#F','#[fg=${sync_ind_colour}]#W' ],
    \'y'       : ['#{prefix_highlight}','%Y-%m-%d', '%H:%M'],
    \'z'       : '#h',
    \'options' : {'status-justify' : 'left'}}

"     let g:tmuxline_preset = {
"                 \'a'    : ["#[fg=colour8,bg=colour4]#S #[fg=colour4,bg=colour0,nobold,nounderscore,noitalics]"],
"                 \'win'  : [ "#[fg=colour14,bg=colour0]#I #[fg=colour14,bg=colour0] #W "],
"                 \'cwin' : [ "#[fg=colour0,bg=colour11,nobold,nounderscore,noitalics] #[fg=colour8,bg=colour11] #I #[fg=colour8,bg=colour11]#W #[fg=colour11,bg=colour0,nobold,nounderscore,noitalics]" ],
"                 \'x'    : [ "" ],
"                 \'y'    : [ '' ],
"                 \'z'    : "#[fg=colour11,bg=colour0,nobold,nounderscore,noitalics] #[fg=colour8,bg=colour11] %Y-%m-%d  %H:%M #[fg=colour14,bg=colour11,nobold,nounderscore,noitalics]#[fg=colour8,bg=colour14] #h ",
"                 \'options' : {'status-justify' : 'left'}
"                 \}
                " \'b'    : '%R %a',
                " \'c'    : [ '#{sysstat_mem} \ufa51#{upload_speed}' ],
                " \'x'    : [ "#{download_speed} \uf6d9#{sysstat_cpu}" ],
    " let g:tmuxline_separators = {
    "             \ 'left' : "\ue0bc",
    "             \ 'left_alt': "\ue0bd",
    "             \ 'right' : "\ue0ba",
    "             \ 'right_alt' : "\ue0bd",
    "             \ 'space' : ' '}
endif
"}}}
"}}}
" Keyboard Shortcuts {{{
" esc in insert mode
" inoremap jk <esc>         " Escape from Insert
inoremap <D-N> <esc>      " Escape from Insert using Command-. on mac
" Consistent moving between windows, dovetails tmux.
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" Use alt + hjkl to resize windows
" Only works in nvim currently
nnoremap <M-j>    :resize -2<CR>
nnoremap <M-k>    :resize +2<CR>
nnoremap <M-h>    :vertical resize -2<CR>
nnoremap <M-l>    :vertical resize +2<CR>

let mapleader = ';'
" {{{ FZF bindings
" nmap <silent> <C-P> :Files<CR>
nmap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>bc :BCommits<CR>
nnoremap <silent> <leader>c  :Commits<CR>
nmap <silent> <leader>f :GFiles<CR>
nmap <silent> <leader>F :Files<CR>
" nmap <silent> <leader>t :Trees<CR>
nmap <silent> <leader>h :History<CR>
noremap <leader>l :Lines<CR>
nmap <silent> <leader>m :Map<CR>
nmap <Leader>t :BTags<CR>
nmap <Leader>T :Tags<CR>
" nmap <silent> <leader>w :Windows<CR>
nmap <silent> <leader>; :Commands<CR>
" }}} FZF bindings

nnoremap <leader>a :Ag<space>
nnoremap <leader>d :NERDTreeToggle<CR>
nnoremap <leader>g :GitGutterToggle<CR>
" nnoremap <leader>f :NERDTreeFind<CR>
" noremap <leader>| :IndentLinesToggle
nnoremap <leader>s% : source %<CR>
nnoremap <leader>] :TagbarToggle<CR>
nnoremap <leader><space> :call whitespace#strip_trailing()<CR>
noremap <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" Substitute word under cursor and dot repeat
nnoremap <silent> \c :let @/='\<'.expand('<cword>').'\>'<CR>cgn
xnoremap <silent> \c "sy:let @/=@s<CR>cgn
" Grepper
nnoremap ! :GrepperAg --ignore tags --ignore tags.temp
nnoremap \S
  \ :let @s='\<'.expand('<cword>').'\>'<CR>
  \ :Grepper -cword -noprompt<CR>
  \ :cfdo %s/<C-r>s// \| update
  \<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
xmap \S
  \ "sy
  \ gvgr
  \ :cfdo %s/<C-r>s// \| update
  \<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

" Folding controls
" noremap <space> za        " open/close folds
"}}}
" Custom Functions {{{
" function! Cond(cond, ...)
"   let opts = get(a:000, 0, {})
"   return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
" endfunction
function! Solar_swap() "{{{ credit to https://superuser.com/users/302463/8bittree
    if &background ==? 'dark'
       set background=light
       execute "silent !tmux source-file " . shellescape(expand('~/.tmux/plugins/tmux-colors-solarized/tmuxcolors-light.conf'))
       silent !osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to False'
    else
       set background=dark
       execute "silent !tmux source-file " . shellescape(expand('~/.tmux/plugins/tmux-colors-solarized/tmuxcolors-dark.conf'))
       silent !osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to False'
    endif
endfunction "}}}
"function! SetBackgroundMode(...) "{{{
"    let s:new_bg = "light"
"    if $TERM_PROGRAM ==? "Apple_Terminal"
"        " let s:mode = systemlist("defaults read -g AppleInterfaceStyle")[0]
"        " let s:mode = system("osascript -e 'tell app \"Terminal\" to get (name of default settings)'")
"        let s:mode = system("osascript -e 'tell app \"Terminal\" to get name of (current settings of selected tab of front window)'")
"        " /usr/libexec/PlistBuddy -c "print 'Default Window Settings'" ~/Library/Preferences/com.apple.Terminal.plist
"        " echo s:mode
"        if s:mode =~? "Dark"
"        " if s:mode ==? "Totally Dark"
"            let s:new_bg = "dark"
"        else
"            let s:new_bg = "light"
"        endif
"    else
"        " This is for Linux where I use an environment variable for this:
"        if $VIM_BACKGROUND ==? "dark"
"            let s:new_bg = "dark"
"        else
"            let s:new_bg = "light"
"        endif
"    endif
"    if &background !=? s:new_bg
"        let &background = s:new_bg
"    endif
"endfunction
"call SetBackgroundMode()
"" call timer_start(3000, "SetBackgroundMode", {"repeat": -1})
""}}}
function! CocCurrentFunction()"{{{
  return get(b:, 'coc_current_function', '')
endfunction"}}}
function! MarkedPreview() " {{{ Open current file in Marked
  :w
  exec ':silent !open -a "Marked.app" ' . shellescape('%:p')
  redraw!
endfunction
nnoremap <leader>e :call MarkedPreview()<CR>
" }}}
function! Fzf_dev() "{{{
  function! s:files()
    let files = split(system($FZF_DEFAULT_COMMAND), '\n')
    return s:prepend_icon(files)
  endfunction

  function! s:prepend_icon(candidates)
    let result = []
    for candidate in a:candidates
      let filename = fnamemodify(candidate, ':p:t')
      let icon = WebDevIconsGetFileTypeSymbol(filename, isdirectory(filename))
      call add(result, printf("%s %s", icon, candidate))
    endfor

    return result
  endfunction

  function! s:edit_file(item)
    let parts = split(a:item, ' ')
    let file_path = get(parts, 1, '')
    execute 'silent e' file_path
  endfunction

  call fzf#run({
        \ 'source': <sid>files(),
        \ 'sink':   function('s:edit_file'),
        \ 'options': '-m -x +s',
        \ 'down':    '40%' })
endfunction "}}}
" Function to create buffer local mappings and add default compiler {{{
fun! AsciidoctorMappings()
    nnoremap <buffer> <leader>oo :AsciidoctorOpenRAW<CR>
    nnoremap <buffer> <leader>op :AsciidoctorOpenPDF<CR>
    nnoremap <buffer> <leader>oh :AsciidoctorOpenHTML<CR>
    nnoremap <buffer> <leader>ox :AsciidoctorOpenDOCX<CR>
    nnoremap <buffer> <leader>ch :Asciidoctor2HTML<CR>
    nnoremap <buffer> <leader>cp :Asciidoctor2PDF<CR>
    nnoremap <buffer> <leader>cx :Asciidoctor2DOCX<CR>
    nnoremap <buffer> <leader>p :AsciidoctorPasteImage<CR>
    " :make will build pdfs
    compiler asciidoctor2pdf
endfun

" Call AsciidoctorMappings for all `*.adoc` and `*.asciidoc` files
augroup asciidoctor
    au!
    au BufEnter *.adoc,*.asciidoc call AsciidoctorMappings()
augroup END "}}}
" }}}
" The End
