execute pathogen#infect()
call pathogen#helptags()

set columns=100
set number

set autoindent
"set cindent
set shiftwidth=4
set expandtab

filetype plugin on
syntax enable
set bg=dark    " Setting dark mode
"solarized gruvbox badwolf molokai
colorscheme solarized

" Quickly edit/reload the vimrc file
let mapleader="\<Space>"

let g:solarized_termcolors=256
set nowrap        " don't wrap lines
set tabstop=4     " a tab is four spaces
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
set number        " always show line numbers
set shiftwidth=4  " number of spaces to use for autoindenting
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch     " set show matching parenthesis
set smarttab      " insert tabs on the start of a line according to shiftwidth, not tabstop
"set hlsearch      " highlight search terms
set incsearch     " show search matches as you type
set listchars=tab:>-,trail:~,extends:>,precedes:<
set list
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set title                " change the terminal's title
set pastetoggle=<F2>
"nnoremap ; :
set wildmenu
set cursorline
set wrap
set lazyredraw
set fdm=indent
set foldlevelstart=12

set ignorecase
set smartcase

nmap <silent> <leader>ev :tabe $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

nmap <leader>f i <esc>x:%!astyle -k3xkxnxcxC100pjCYHxnxcxk<CR>:w<esc>gi<esc>
"nmap <leader>f i <esc>x:%!astyle -k3xkxnxcpjCYHA3<CR>:w<esc>gi<esc>
:command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> - |fmt -csw78

nmap <leader>w :w<CR>
nmap <leader>q :q<CR>

inoremap kj <esc>:w<CR>l

nmap H gT
nmap L gt
set so=999

set nocompatible

set formatoptions+=w
set tw=100
set hidden

"plugin stuff:

runtime macros/matchit.vim
" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

  " bind K to grep word under cursor
  nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

endif


let g:airline#extensions#tabline#enabled = 1
set laststatus=2

set showmode

let g:ctrlp_by_filename=0
let g:ctrlp_cmd='CtrlPMixed'

"let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
"let g:ycm_confirm_extra_conf = 0

"let g:neocomplete#enable_at_startup = 1

"let g:nerdtree_tabs_open_on_console_startup=1

"set statusline += % #warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline += % *

let g:vim_markdown_folding_disabled=1
"nmap <CR> li<CR><esc>k$

"ctags stuff
nmap <Leader>tf :call CtagsFind(expand('<cword>'))<CR>
com! -nargs=+ Tf :call CtagsFind("<args>")
" split window and search for tag
nmap <Leader>ts :exe('stj '.expand('<cword>'))<CR>

" open new tab and search for tag
fun! CtagsFind(keyword)
    tabe
    exe "tj ".a:keyword
endfunction
