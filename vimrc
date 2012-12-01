set nocompatible

filetype off

" use vundle to manage plugins
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'tpope/vim-markdown'

Bundle 'altercation/vim-colors-solarized'
let g:solarized_italic=0
let g:solarized_hitrail=1

Bundle 'FencView.vim'
let g:fencview_autodetect=0

Bundle 'scrooloose/nerdtree'
map <F6> :NERDTreeToggle<CR>

Bundle 'scrooloose/nerdcommenter'
let g:NERDMenuMode=0
" toggle comment on and off
map <F7> \c<Space>

Bundle 'majutsushi/tagbar'
map <F8> :TagbarToggle<CR>
let g:tagbar_sort=0
let g:tagbar_compact=1

Bundle 'kien/ctrlp.vim'
map <C-B> :CtrlPBuffer<CR>

Bundle 'Gundo'
map <F4> :GundoToggle<CR>

" sort and unqiue selection lines
map <F2> :sort u<CR>
" convert current buffer to utf-8 encoding and save
map <F3> :FencAutoDetect<CR>:set fenc=utf-8<CR>:w<CR>

filetype plugin indent on
syntax enable

set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
set expandtab
set backspace=indent,eol,start
set nofoldenable

set mousehide
set mouse=a
set ttymouse=xterm2

set fileencodings=utf-8
set encoding=utf-8
set nobackup
set hidden

set ignorecase
set smartcase
set incsearch
" replace with 'g' option in default
set gdefault

set wildmenu
set novisualbell
set noerrorbells
set nu
set ruler
set showmatch
set showcmd
set showmode

" always display statusline
set laststatus=2
" statsuline: filename, mode, filetype, line number, scroll position
set statusline=%F\ %m%r%h%w\ %y\ [%{&fenc}]\ %=\ row:%l,\ col:%c\ %<%P

set tags=tags;
set autochdir
set formatoptions=tcroqlm
set textwidth=80

" jump to last position
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

if has("gui_running")
    " only show gui tabline and icon, and use console instead of popup dialog
    set guioptions=eic
    set guifont=Monaco
    set lines=30
    set columns=110
    colorscheme solarized
    set background=dark
    call togglebg#map("<F5>")
else
    colorscheme default
    set background=dark
endif
