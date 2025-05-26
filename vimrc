set nocompatible
filetype off

call plug#begin()

" Status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Code structure outline
Plug 'preservim/tagbar'

" Show diff in the sign column
Plug 'mhinz/vim-signify'

" Papercolor color scheme
Plug 'NLKNguyen/papercolor-theme'

" File explorer
Plug 'preservim/nerdtree'

" Auto pairs
Plug 'LunarWatcher/auto-pairs'

" D2 syntax highlight
Plug 'terrastruct/d2-vim'

" Visualize edit history
Plug 'mbbill/undotree'

" Markdown table editing
Plug 'dhruvasagar/vim-table-mode'

" Applescript syntax highlight
Plug 'vim-scripts/applescript.vim'

" All of your Plugins must be added before the following line
call plug#end()

filetype plugin indent on
syntax enable

" Force 2 spaces indent
autocmd FileType * setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

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
if !has('nvim')
  set ttymouse=xterm2
endif
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
set noautoread
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
  return lnum . ':' . colnum . ' ' . scroll . '% '
endfunction
let g:airline_section_z = '%{AirlineSectionZ()}'

" Switch to buffer by index (not buffer number)
function! SwitchBuffer(index)
  let l:list = []
  for b in range(1, bufnr('$'))
    if buflisted(b)
      call add(l:list, b)
    endif
  endfor

  if a:index >= 0 && a:index < len(l:list)
    execute 'buffer' l:list[a:index]
  else
    echohl ErrorMsg
    echom "Invalid buffer index: " . a:index
    echohl None
  endif
endfunction

" Y to copy to end of line
map Y y$

" Quick buffer navigation
nmap <F1> :call SwitchBuffer(0)<CR>
nmap <F2> :call SwitchBuffer(1)<CR>
nmap <F3> :call SwitchBuffer(2)<CR>
nmap <F4> :call SwitchBuffer(3)<CR>
" Toggle nerd tree
nmap <F5> :NERDTreeToggle<CR>
" Locate current file in nerdtree
nmap <F6> :NERDTreeFind<CR>
" Toggle Undotree
nmap <F7> :UndotreeToggle<CR>
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

" Set .as file as applescript
autocmd BufRead,BufNewFile *.as set filetype=applescript

if exists("g:neovide")
  set lines=42
  set columns=160
elseif has("gui_running")
  set guioptions=egmic
  set lines=42
  set columns=159
endif

if has("gui_running") || exists("g:neovide")
  set guifont=Fira\ Code:h13
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

