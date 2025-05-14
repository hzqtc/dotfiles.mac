set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Status bar
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" Code structure outline
Plugin 'preservim/tagbar'

" Show diff in the sign column
Plugin 'mhinz/vim-signify'

" Papercolor color scheme
Plugin 'NLKNguyen/papercolor-theme'

" File explorer
Plugin 'preservim/nerdtree'

" Auto pairs
Plugin 'LunarWatcher/auto-pairs'

" D2 syntax highlight
Plugin 'terrastruct/d2-vim'

" All of your Plugins must be added before the following line
call vundle#end()

filetype plugin indent on
syntax enable

" Quicker updates for 'vim-signify'
set updatetime=100
set autoindent
set smartindent
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smarttab
set expandtab
set backspace=indent,eol,start
set nofoldenable
set splitright
set splitbelow
set mousehide
set mouse=a
set ttymouse=xterm2
set fileencodings=ucs-bom,utf-8,gb18030,gbk,gb2312,cp936
set encoding=utf-8
set nobackup
set noswapfile
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
set tags=tags;
set autochdir
set formatoptions=tcroqlmM
set textwidth=150
" Remember the following view options and restore automatically
set viewoptions=folds,cursor,curdir
autocmd BufWinLeave * silent! mkview
autocmd BufWinEnter * silent! loadview

" Config airline C section to show all buffers with active buffer name in []
function! AirlineBufferList()
  let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val)')
  let names = []
  for b in buffers
    let name = bufname(b) ==# '' ? '<New>' : fnamemodify(bufname(b), ':t')
    if getbufvar(b, '&modified')
      let name .= '*'
    endif
    if b == bufnr('')
      " Current buffer: bold using airline's raw part
      call add(names, printf('[%d:%s]', b, name))
    else
      call add(names, printf('%d:%s', b, name))
    endif
  endfor
  return join(names, ' | ')
endfunction
let g:airline_section_c = '%{AirlineBufferList()}'

function! AirlineSectionZ()
  let lnum = line('.')
  let colnum = col('.')
  let total = line('$')
  let scroll = float2nr(100.0 * lnum / total)
  let win_size = winheight(0) . 'x' . winwidth(0)
  return lnum . ':' . colnum . ' ' . scroll . '% ' . win_size
endfunction
let g:airline_section_z = '%{AirlineSectionZ()}'

" Y to copy to end of line
map Y y$
" Quick buffer navigation
nmap <F1> :b1<CR>
nmap <F2> :b2<CR>
nmap <F3> :b3<CR>
nmap <F4> :b4<CR>

" Toggle nerd tree
nmap <F5> :NERDTreeToggle<CR>
" Locate current file in nerdtree
nmap <F6> :NERDTreeFind<CR>
" Toggle tag bar
nmap <F8> :TagbarToggle<CR>
" Navigate buffers
nmap <F9> :bprevious<CR>
nmap <F10> :bnext<CR>

" Use ctrl-[hjkl] to select the active split!
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif
" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if &buftype != 'quickfix' && getcmdwintype() == '' | silent NERDTreeMirror | endif

if has("gui_running")
  " only show gui tabline and icon, and use console instead of popup dialog
  set guioptions=eic
  set guifont=FiraCodeRoman-Regular:h13
  set lines=42
  set columns=159
  " Light background before 8PM
  if strftime("%H") < 20
    set background=light
  else
    set background=dark
  endif
else
  " Alwasy dark background in terminal
  set background=dark
endif
colorscheme PaperColor

