" vim - plug
call plug#begin('~/.vim/plugged')

Plug 'github/copilot.vim'
" Plug 'Golox/vim-misc'
" Plug 'xolox/vim-session' ", { 'on':  'SaveSession' }
Plug 'itchyny/vim-cursorword'
Plug 'godlygeek/tabular', { 'on':  'Tab' }
Plug 'tpope/vim-commentary'
Plug 'Raimondi/delimitMate'
Plug 'machakann/vim-sandwich'
Plug 'machakann/vim-highlightedyank'
Plug 'tpope/vim-unimpaired'
Plug 'simnalamburt/vim-mundo', { 'on':  'MundoShow'}
Plug 'tmhedberg/SimpylFold'
" Plug 'noscript/vim-wipeout', { 'on':  'Wipeout' }
Plug 'vim-airline/vim-airline'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'ivalkeen/vim-ctrlp-tjump'
Plug 'unblevable/quick-scope'
Plug 'kdheepak/JuliaFormatter.vim'
Plug 'AndrewRadev/linediff.vim', { 'on':  'Linediff' }
Plug 'rhysd/vim-clang-format'
Plug 'github/copilot.vim'
" Plug 'junegunn/goyo.vim', { 'on':  'Goyo' }
" Plug 'junegunn/limelight.vim', { 'on':  'Limelight' }

" Plug 'szymonmaszke/vimpyter'

" For ssh editing
" Plug 'justinmk/vim-dirvish'
" Plug 'bounceme/remote-viewer'
" Plug 'tommcdo/vim-lion'
" Plug 'Chiel92/vim-autoformat'
" Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" Plug 'mhinz/vim-startify'
" Plug 'jistr/vim-nerdtree-tabs'

" Completion etc
" Plug 'ajh17/VimCompletesMe'
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'deoplete-plugins/deoplete-jedi'
" Plug 'zxqfl/tabnine-vim'
" Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }
"Plug 'sheerun/vim-polyglot'

" External tool support plugins
Plug 'christoomey/vim-tmux-navigator'
Plug 'christoomey/vim-tmux-runner', { 'on':  'VtrAttachToPane' }
" Plug 'urbainvaes/vim-tmux-pilot'
Plug 'mileszs/ack.vim', { 'on':  ['Ack', 'Ack!'] }
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Git support
Plug 'tpope/vim-fugitive'
" Plug 'junegunn/gv.vim'
Plug 'airblade/vim-gitgutter'
" Plug 'mhinz/vim-signify'

" Language support plugins
" Plug 'jalvesaq/Nvim-R'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'chrisbra/csv.vim'
Plug 'editorconfig/editorconfig-vim'
" Plug 'bfredl/nvim-ipy'
" Plug 'JuliaEditorSupport/deoplete-julia' Deprecated for 0.6

" Tags
" Plug 'ludovicchabant/vim-gutentags' # warn- auto runs ctags
" Plug 'majutsushi/tagbar'
" Plug 'vim-scripts/taglist.vim'
Plug 'romainl/vim-cool'

Plug 'sbdchd/neoformat'

" Snippets
" Plug 'honza/vim-snippets'
" Plug 'andreyorst/SimpleSnippets.vim'
" Plug 'Shougo/neosnippet-snippets'
" Plug 'Shougo/neosnippet.vim'
" Plug 'ervandew/supertab'

" Plug 'Shougo/denite.nvim'
" Plug 'jayvn/vim-endwise'
" Plug 'godlygeek/csapprox'
" Plug 'critiqjo/lldb.nvim'
" Plug 'nathanaelkane/vim-indent-guides'
" Plug 'scrooloose/nerdcommenter'
" Plug 'plasticboy/vim-markdown'
" Plug 'jalvesaq/vimcmdline'
" Plug 'chrisbra/NrrwRgn'

" Colorschemes and stuff
" Plug 'vim-airline/vim-airline-themes' " Airline themes
" Plug 'vim-scripts/peaksea'
" Plug 'KabbAmine/yowish.vim'
" Plug 'altercation/vim-colors-solarized'

" Plug 'ajh17/Spacegray.vim'
" Plug 'chriskempson/vim-tomorrow-theme'
Plug 'jnurmine/Zenburn'
" Plug 'jonathanfilip/vim-lucius'
" Plug 'jpo/vim-railscasts-theme'
" Plug 'mhinz/vim-janah'
" Plug 'morhetz/gruvbox'
Plug 'nanotech/jellybeans.vim'
" Plug 'noscript/codeblocks-dark.vim'
" Plug 'romainl/flattened'
Plug 'sjl/badwolf'
Plug 'tomasr/molokai'
" Plug 'tpope/vim-vividchalk'
" Plug 'w0ng/vim-hybrid'
Plug 'whatyouhide/vim-gotham'
" Plug 'junegunn/seoul256.vim'
Plug 'romainl/Apprentice'
" Plug 'chriskempson/base16-vim'
Plug 'joshdick/onedark.vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'dracula/vim'

" seoul256 (dark):
"   Range:   233 (darkest) ~ 239 (lightest)
"let g:seoul256_background = 236

"colo seoul256
call plug#end()

"solarized gruvbox badwolf molokai zenburn peaksea seoul256
"":highlight Normal ctermfg=grey ctermbg=black
if has('gui_running')
    set bg=dark
    colorscheme solarized
    let g:solarized_termcolors=256
    let g:solarized_bold = 1
else
    " colorscheme solarized
    " let g:solarized_termcolors=256
    " let g:solarized_bold = 1
    " set bg=dark
    " colo badwolf gruvbox apprentice spacegray codeblocks-dark gotham onedark seoul256 molokai
    colo molokai
    " let g:rehash256 = 1
    let g:airline_theme='onedark' " 'gotham'
    " let g:seoul256_background = 234
endif

let mapleader="\<Space>"

" Enable persistent undo so that undo history persists across vim sessions
set undofile
set undodir=~/.vim/undo

" let g:neosnippet#disable_runtime_snippets = {
" \   '_' : 1,
" \ }

" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif
"" Tell Neosnippet about the other snippets
"let g:neosnippet#snippets_directory='~/.vim/plugged/vim-snippets/snippets'
"" Snippets {
"
"        " Use honza's snippets.
"
"        let g:neosnippet#snippets_directory='~/.vim/neosnippets'
"
"         "Enable neosnippet snipmate compatibility mode
"
"        let g:neosnippet#enable_snipmate_compatibility = 1
"
"         "For snippet_complete marker.
"
"            if has('conceal')
"
"                set conceallevel=2 concealcursor=i
"
"            endif
"
"         "Enable neosnippets when using go
"
"        let g:go_snippet_engine = "neosnippet"
"
"        " Disable the neosnippet preview candidate window
"
"        " When enabled, there can be too much visual noise
"
"        " especially when splits are used.
"
"        set completeopt-=preview
"
"" }

let g:deoplete#enable_at_startup = 1
set expandtab
filetype plugin indent on
syntax enable
set nowrap        " don't wrap lines
set tabstop=4     " a tab is four spaces
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
" set number        " always show line numbers
set nu | set rnu
set shiftwidth=4  " number of spaces to use for autoindenting
"set matchtime=1
set showmatch     " set show matching parenthesis
set smarttab      " insert tabs on the start of a line according to shiftwidth, not tabstop
set listchars=tab:>-,trail:~,extends:>,precedes:<
set list
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set title                " change the terminal's title
set wildmenu
set cursorline
set wrap
set lazyredraw
set fdm=indent
set foldlevelstart=12

"set ignorecase
set smartcase

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :tabe $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

"nmap <leader>f i <esc>x:%!astyle -k3xkxnxcxC100pjCYHxnxcxk<CR>:w<esc>gi<esc>
"nmap <leader>f i <esc>xgg=GgggqGg;
"nmap <leader>f i <esc>x:%!astyle -k3xkxnxcpjCYHA3<CR>:w<esc>gi<esc>
:command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> - |fmt -csw78

nmap <leader>q :q<CR>

nnoremap ; :
" inoremap kj <esc>:up<CR>l
inoremap kj <esc>

" nmap <C-Tab> gt
" nmap <C-S-Tab> gT
nmap H gT
nmap L gt

set scrolloff=999

set formatoptions+=w
set formatoptions+=o
set tw=100
set hidden

"plugin stuff:

" The Silver Searcher
if executable('ag')
    " Use ag over grep
    set grepprg=ag\ --nogroup\ --nocolor

    " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

    " ag is fast enough that CtrlP doesn't need to cache
    let g:ctrlp_use_caching = 0

    " bind K to grep word under cursor
    " nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
endif

function! StripTrailingWhitespace()
  if !&binary && &filetype != 'diff'
    normal mz
    if &filetype == 'mail'
" Preserve space after e-mail signature separator
      %s/\(^--\)\@<!\s\+$//e
    else
      %s/\s\+$//e
    endif
    normal `z
    normal h
  endif
endfunction

" GUI Options {

  " Toggle between normal and relative numbering.
  nnoremap <leader>rn :call NumberToggle()<cr>

  " Sets a status line. If in a Git repository, shows the current branch.
  " Also shows the current file name, line and column number.
  if has('statusline')
      set laststatus=2
      " Broken down into easily includeable segments
      set statusline=%<%f\                     " Filename
      set statusline+=%w%h%m%r                 " Options
      "set statusline+=%{fugitive#statusline()} " Git Hotness
      set statusline+=\ [%{&ff}/%Y]            " Filetype
      set statusline+=\ [%{getcwd()}]          " Current dir
      set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
  endif
" }
" Keybindings {
  " Save file
    "nnoremap <Leader>w :call StripTrailingWhitespace()<CR> :w<CR>
    nnoremap <Leader>w :up<CR>
    "Copy and paste from system clipboard
    "Disabled because we use system clipboard by default
    " vmap <Leader>y "+y
    " vmap <Leader>d "+d
    " nmap <Leader>p "+p
    " nmap <Leader>P "+P
    " vmap <Leader>p "+p
    " vmap <Leader>P "+P

" }

" Airline {
    "let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#enabled = 2
    let g:airline#extensions#tabline#fnamemod = ':t'
    let g:airline#extensions#tabline#left_sep = ' '
    let g:airline#extensions#tabline#left_alt_sep = '|'
    let g:airline#extensions#tabline#right_sep = ' '
    let g:airline#extensions#tabline#right_alt_sep = '|'

    let g:airline_right_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_left_alt_sep= ''
    let g:airline_left_sep = ''
    " let g:airline_theme= 'serene'
    " }

" CtrlP {
" Open file menu
let g:ctrlp_by_filename=0
let g:ctrlp_cmd='CtrlPMixed' " 'CtrlPMRU'
" Open buffer menu
nnoremap <Leader>b :CtrlPBuffer<CR>
" Open most recently used files
nnoremap <Leader>m :CtrlPMRUFiles<CR>
" }

set ff=unix

let g:vim_markdown_folding_disabled=1

"nmap <CR> li<CR><esc>k$

nmap <Leader>ts :exe('stj '.expand('<cword>'))<CR>

let cmdline_follow_colorscheme = 1
nmap <Leader>id o<Esc>:r! date "+\%Y-\%m-\%d"<CR>kJA** [jayakrishnan.v]<Esc>I- **<Esc>A Initial Version<Esc>
noremap <expr> n (v:searchforward ? 'n' : 'N')
noremap <expr> N (v:searchforward ? 'N' : 'n')
" nnoremap <Leader>f :call StripTrailingWhitespace()<CR>:retab<CR> :up<CR> :nohlsearch<CR>
nnoremap <Leader>f :call StripTrailingWhitespace()<CR>:retab<CR> :nohlsearch<CR>:redraw!<CR> gg=G<C-o>
tnoremap <Esc> <C-\><C-n>
" nnoremap <C-n> :FZF<CR>
nnoremap <C-n> :CtrlP<CR>

let g:tagbar_type_julia = {
    \ 'ctagstype' : 'julia',
    \ 'kinds'     : ['a:abstract', 'i:immutable', 't:type', 'f:function', 'm:macro']
    \ }

function! s:tags_sink(line)
    let parts = split(a:line, '\t\zs')
    let excmd = matchstr(parts[2:], '^.*\ze;"\t')
    execute 'silent e' parts[1][:-2]
    let [magic, &magic] = [&magic, 0]
    execute excmd
    let &magic = magic
endfunction

function! s:tags()
    if empty(tagfiles())
        echohl WarningMsg
        echom 'Preparing tags'
        echohl None
        call system('ctags -R')
    endif

  " call fzf#run({
  " \ 'source':  'cat '.join(map(tagfiles(), 'fnamemodify(v:val, ":S")')).
  " \            '| grep -v ^!',
  " \ 'options': '+m -d "\t" --with-nth 1,4.. -n 1 --tiebreak=index',
  " \ 'down':    '40%',
  " \ 'sink':    function('s:tags_sink')})
endfunction

command! Tags call s:tags()
nnoremap <Leader>tg :TagbarToggle<CR>
nnoremap <Leader>g :CtrlPTag<CR>
map <Leader>jl :tabe<CR>:terminal<CR>julia<CR>

nnoremap <c-]> :CtrlPtjump<cr>
vnoremap <c-]> :CtrlPtjumpVisual<cr>
let g:ctrlp_tjump_only_silent = 1
" Reload file
nmap <Leader>rl :e<CR>

"nnoremap <Leader>d iprintln(@__LINE__, " CtrlPTag<CR>

" set pastetoggle=<F2>
" Read somewhere that this can be used to avoid pastetoggle -
set mouse=a

let g:session_autoload = 'no'
let g:session_autosave = 'no'
" let g:startify_change_to_dir = 0

" R script settings
" let maplocalleader = ","

" NVIM-R plugin settings
" vmap K <Plug>RDSendSelection
" nmap K <Plug>RDSendLine

let vimrplugin_vsplit=1
let R_assign = 0

" nnoremap <leader>va :VtrAttachToPane<cr>
" nnoremap <leader>ror :VtrReorientRunner<cr>
nnoremap <leader>sc :VtrSendCommandToRunner<cr>
nnoremap <CR> :VtrSendLinesToRunner<cr>j
vnoremap <CR> :VtrSendLinesToRunner<cr>
nnoremap <leader>o :VtrOpenRunner<cr>
" nnoremap <leader>fr :VtrFocusRunner<cr>
" nnoremap <leader>dr :VtrDetachRunner<cr>
" nnoremap <leader>cr :VtrClearRunner<cr>
" nnoremap <leader>fc :VtrFlushCommand<cr>
nnoremap <leader>sf :VtrSendFile<cr>

" Block insert
vnoremap <C-c> <Esc>
" Mainly for vim-commentary
autocmd FileType julia setlocal commentstring=#\ %s
" autocmd FileType javascript.jsx setlocal commentstring={/*\ %s \ /*}

"Performance improvements
set synmaxcol=200 "Don't bother highlighting anything over 200 chars
let did_install_default_menus = 1 "No point loading gvim menu stuff

" let g:nvim_ipy_perform_mappings = 0
set inccommand=nosplit
set termguicolors

let g:highlightedyank_highlight_duration = 200

" use surround.vim keymap for vim-sandwich
runtime macros/sandwich/keymap/surround.vim

" Ignore node_modules during tag generation
let g:gutentags_ctags_exclude = ['node_modules']

" GitGutter settings
let g:updatetime= 500 " vim swap file write interval and gitgutter update time
autocmd BufWritePost * GitGutter " Refresh signs when saved

vmap <silent> <Leader>h :s/\(\S\)\([\+\-/\*><]\)\(\S\)/\1 \2 \3/g<CR>
nmap <silent> <Leader>h :s/\(\S\)\([\+\-/\*><]\)\(\S\)/\1 \2 \3/g<CR>
" Remap ex mode key to repeat recent macro
nnoremap Q @@

" yy is easy enough combination to yank full line.
" Remap Y to yank till the end
nmap Y y$

" !jq '.' For formatting
" Save two keystrokes :)
cnoreabbrev ag Ack!
" Always use system clipboard
set clipboard=unnamedplus

" Make this working to prevent duplicate tabs buffers when tab jumping
" function! ReturnTagFileUnderCursor()
"    try
"       let tag = expand('<cword>')
"       let tagString = split(execute("tselect ".tag), "\n")[1]
"       let tagString = matchstr(tagString, '[^/\\]*$')
"       return tagString
"    catch /^Vim\%((\a\+)\)\=:E426/
"       echohl ERROR
"       echo \"Tag not found!\"
"       echohl NORMAL
"       return ""
"    endtry
" endfunction

" Windows like Ctrl-S behaviour
imap <C-s>     <Esc>:w<CR><Esc>
nnoremap <C-s>     :w<CR>
imap <A><S>L <CR>
nmap <Alt-e> :VtrSendLinesToRunner<CR>

let g:copilot_ui_side = "right"
