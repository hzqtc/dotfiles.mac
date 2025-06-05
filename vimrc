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

" Indent line indication
Plug 'Yggdroot/indentLine'

" Fancy start screen
Plug 'mhinz/vim-startify'

" Quickly change between single-line and multi-line code syntax
Plug 'AndrewRadev/splitjoin.vim'

" Quickly comment/uncomment code
Plug 'tpope/vim-commentary'

" Surround or remove surrounding symbols (e.g. ", ', {, [)
Plug 'tpope/vim-surround'

" Automatic session management
Plug 'tpope/vim-obsession'

" All of your Plugins must be added before the following line
call plug#end()

filetype plugin indent on
syntax enable

" Force 2 spaces indent on all file types
autocmd FileType * setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

" Quicker updates for 'vim-signify'
set updatetime=100
set autoindent
set smartindent
set tabstop=2
set shiftwidth=2
set softtabstop=2
set shiftround
set smarttab
set expandtab
set backspace=indent,eol,start
set nofoldenable
set splitright
set splitbelow
set cursorline
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
set hlsearch
set wrapscan
set gdefault
set completeopt+=noselect
set wildmenu
set wildignore+=*/*.egg-info/**,*/.git/*,*/dist/**,*/__pycache__/**
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
" Always set cursor to the first line first column when editing a git commit message
autocmd FileType gitcommit call cursor(1, 1)

" Don't autofold
set foldlevelstart=99
" Set foldmethod to 'diff' when in diff mode, 'indent' otherwise
autocmd WinEnter,BufWinEnter * if &diff | setlocal foldmethod=diff | else | setlocal foldmethod=indent | endif
autocmd OptionSet diff if &diff | setlocal foldmethod=diff | else | setlocal foldmethod=indent | endif

" Buffers list with the current buffer name in []
function! AirlineBufferList()
  let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val)')
  let names = []
  " Show buffers' indexes rather than buffer numbers
  let index = 1
  for b in buffers
    let path = bufname(b)
    if path ==# ''
      let name = '<New>'
    else
      let parts = split(fnamemodify(path, ':~:.'), '/')
      if len(parts) > 1
        " Shorten all but the last part (the filename)
        let last = remove(parts, -1)
        let short_parts = map(parts, {_, val -> (val[0] ==# '.' ? val[:1] : val[0])})
        let name = join(short_parts, '/') . '/' . last
      else
        let name = parts[0]
      endif
    endif

    if getbufvar(b, '&modified')
      let name .= ' *'
    endif

    if b == bufnr('')
      call add(names, printf('[%d %s]', index, name))
    else
      call add(names, printf('%d %s', index, name))
    endif
    let index += 1
  endfor
  return join(names, ' | ')
endfunction
let g:airline_section_c = '%{AirlineBufferList()}'

" Current working directory
function! AirlineCwd()
  return fnamemodify(getcwd(), ':~:.')
endfunction
let g:airline_section_y = '%{AirlineCwd()}'

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

" <tab> to auto complete
imap <Tab> <C-n>
" Y to copy to end of line
nmap Y y$
" Close current buffer
nmap <leader>x :bw<CR>
" Close all buffers with confirmation
nmap <leader>X :call ConfirmCloseAllBuffers()<CR>
" Clear highlights
nmap <leader>h :nohl<CR>
" Open Startify
nmap <leader>s :Startify<CR>
" Toggle background between light and dark
nmap <leader>b :call ToggleBackground()<CR>
" Edit ~/.vimrc
nmap <leader>e :e ~/.vimrc<CR>
" Source ~/.vimrc
nmap <leader>r :source ~/.vimrc<CR>
" Create an empty buffer
nmap <leader>n :enew<CR>

function! ConfirmCloseAllBuffers()
  let answer = input("Close all buffers? (y/N): ")
  if tolower(answer) ==# 'y'
    bufdo bw
  endif
endfunction

function! ToggleBackground()
  if &background ==# "dark"
    set background=light
  else
    set background=dark
  endif
endfunction

" Switch buffer by index (starting with 1). Note: not by buffer number.
for i in range(1, 9)
  execute 'nmap <leader>' . i . ' :call SwitchBuffer(' . (i - 1) . ')<CR>'
endfor
" Navigate buffers
nmap <F2> :bprevious<CR>
nmap <F3> :bnext<CR>
" Toggle nerd tree
nmap <F5> :NERDTreeToggle<CR>
" Locate current file in nerdtree
nmap <F6> :NERDTreeFind<CR>
" Toggle Undotree
nmap <F7> :UndotreeToggle<CR>
" Toggle tag bar
nmap <F8> :TagbarToggle<CR>

" Use ctrl-[hjkl] to select the active split!
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

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
  set guifont=FiraCode\ Nerd\ Font:h13
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

