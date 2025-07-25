set nocompatible
filetype off

" Using https://github.com/junegunn/vim-plug
call plug#begin()

" Status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Show diff in the sign column
Plug 'mhinz/vim-signify'

" Color scheme
Plug 'NLKNguyen/papercolor-theme'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }

" D2 syntax highlight
Plug 'terrastruct/d2-vim'

" Visualize edit history
Plug 'mbbill/undotree'

" Markdown table editing
Plug 'dhruvasagar/vim-table-mode'

" Applescript syntax highlight
Plug 'vim-scripts/applescript.vim'

" Indent line indication
if has('nvim')
  Plug 'echasnovski/mini.indentscope'
else
  Plug 'Yggdroot/indentLine'
endif

" Fancy start screen
Plug 'mhinz/vim-startify'

" Quickly change between single-line and multi-line code syntax
Plug 'AndrewRadev/splitjoin.vim'

" Quickly comment/uncomment code
Plug 'tpope/vim-commentary'

" Surround or remove surrounding symbols (e.g. ", ', {, [)
Plug 'tpope/vim-surround'

if has('nvim')
  " Diff view
  Plug 'sindrets/diffview.nvim'
  " Directory editor
  Plug 'stevearc/oil.nvim'
  " Code formatter
  Plug 'stevearc/conform.nvim'
  " Code outline
  Plug 'stevearc/aerial.nvim'
  " File explorer
  Plug 'nvim-tree/nvim-tree.lua'
  Plug 'nvim-tree/nvim-web-devicons'
  " Auto complete
  Plug 'saghen/blink.cmp'
endif

" Provide nerd font icons for other plugins
Plug 'ryanoasis/vim-devicons'

" All of your Plugins must be added before the following line
call plug#end()

filetype plugin on
syntax enable

" Quicker updates for 'vim-signify'
set updatetime=100
" Longer timeout for long commands in normal mode
set timeoutlen=2000
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
set undofile
set hidden
set ignorecase
set smartcase
set incsearch
set hlsearch
set wrapscan
set gdefault
set completeopt=fuzzy,menu,popup,noselect
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
set virtualedit=block

" File types that forces/prefers tabs
autocmd FileType make,go setlocal noexpandtab

" Set .as file as applescript
autocmd BufRead,BufNewFile *.as set filetype=applescript

" Remember the following view options and restore automatically
set viewoptions=folds,cursor,curdir
autocmd BufWinLeave * silent! mkview
autocmd BufWinEnter * silent! loadview
" Always set cursor to the first line first column when editing a git commit message
autocmd FileType gitcommit call cursor(1, 1)

" Removing trailing spaces on save
autocmd BufWritePre * :%s/\s\+$//e

" Don't autofold
set foldlevelstart=99
" Set foldmethod to 'diff' when in diff mode, 'indent' otherwise
autocmd WinEnter,BufWinEnter * if &diff | setlocal foldmethod=diff | else | setlocal foldmethod=indent | endif
autocmd OptionSet diff if &diff | setlocal foldmethod=diff | else | setlocal foldmethod=indent | endif

" ======================
" Airline config section
" ======================
" Disable dev icons in airline because I want to customize where icons show up
let g:webdevicons_enable_airline_statusline = 0
" Disable some plugins to save space
let g:airline#extensions#tagbar#enabled = 0
let g:airline#extensions#searchcount#enabled = 0

" Buffers list with the current buffer name in []
function! AirlineSectionC()
  let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val)')
  let names = []
  " Show buffers' indexes rather than buffer numbers
  let index = 1
  for b in buffers
    let name = fnamemodify(bufname(b), ':t')
    let path = fnamemodify(bufname(b), ':p')
    let icon = WebDevIconsGetFileTypeSymbol(name)
    if name ==# ''
      let name = '<New>'
    endif

    if getbufvar(b, '&readonly')
      let name .= ' '
    elseif getbufvar(b, '&modified')
      let name .= ' ●'
    else
      " Check if there are hunks (git changes) in the buffer using vim-signify
      let bsy = getbufvar(b, 'sy')
      if !empty(bsy) && len(bsy.hunks) > 0
        let name .= ' +'
      endif
    endif

    if b == bufnr('')
      call add(names, printf('[%d %s%s]', index, icon, name))
    else
      call add(names, printf('%d %s%s', index, icon, name))
    endif
    let index += 1
  endfor
  return join(names, ' | ')
endfunction
let g:airline_section_c = '%{AirlineSectionC()}'

function! AirlineSectionX()
  let ft = &filetype
  let path = expand('%:p')
  return WebDevIconsGetFileTypeSymbol(path) . ft
endfunction
let g:airline_section_x = '%{AirlineSectionX()}'

function! AirlineSectionY()
  let os_icon = ''
  if has('mac') || has('macunix') || has('osx')
    let os_icon = "󰀵"
  elseif has('unix') && !has('macunix')
    let os_icon = "󰌽"
  elseif has('win32') || has('win64')
    let os_icon = "󰍲"
  endif
  return os_icon . ' ' . fnamemodify(getcwd(), ':~:.')
endfunction
let g:airline_section_y = '%{AirlineSectionY()}'

function! AirlineSectionZ()
  let lnum = line('.')
  let colnum = col('.')
  let total = line('$')
  let scroll = float2nr(100.0 * lnum / total)
  return lnum . ':' . colnum . ' ' . scroll . '%'
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

" ==========================
" End Airline config section
" ==========================

" Y to copy to end of line
nmap Y y$
" // to search selected text
vmap // y/<C-R>"<CR>N
" <ESC> in normal mode clears highlights
nmap <Esc> :nohl<CR>
" Close current buffer
nmap <leader>x :bw<CR>
" Close all buffers with confirmation
nmap <leader>X :call ConfirmCloseAllBuffers()<CR>
" Open Startify
nmap <leader>s :Startify<CR>
" Toggle background between light and dark
nmap <leader>b :call ToggleBackground()<CR>
" Remove trailing spaces
nmap <leader>f :%s/\s\+$//g<CR>
" Edit .vimrc
nmap <leader>e :e ~/.vimrc<CR>
" Edit init.vim
nmap <leader>E :e ~/.config/nvim/init.vim<CR>
" Source current file.
nmap <leader>r :source %<CR>
" Create an empty buffer
nmap <leader>n :enew<CR>
" Toggle Undotree
nmap <leader>u :UndotreeToggle<CR>
" Toggle tag bar
nmap <leader>a :AerialToggle<CR>

if has('nvim')
  " Open/close diff view
  nmap <leader>d :DiffviewOpen<CR>
  nmap <leader>D :DiffviewClose<CR>
  " History of the current file
  nmap <leader>h :DiffviewFileHistory %<CR>
  " History of the current repo
  nmap <leader>H :DiffviewFileHistory<CR>
endif

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

" Move lines
nmap <silent> <M-S-Up> :move -2<CR>
nmap <silent> <M-S-Down> :move +1<CR>
vmap <silent> <M-S-Up> :move -2<CR>
vmap <silent> <M-S-Down> :move +1<CR>

" Switch buffer by index (starting with 1). Note: not by buffer number.
for i in range(1, 9)
  execute 'nmap <leader>' . i . ' :call SwitchBuffer(' . (i - 1) . ')<CR>'
endfor
" Quick dial for buffer 1-8
nmap <F1> :call SwitchBuffer(0)<CR>
imap <F1> <Esc>:call SwitchBuffer(0)<CR>
nmap <F2> :call SwitchBuffer(1)<CR>
imap <F2> <Esc>:call SwitchBuffer(1)<CR>
nmap <F3> :call SwitchBuffer(2)<CR>
imap <F3> <Esc>:call SwitchBuffer(2)<CR>
nmap <F4> :call SwitchBuffer(3)<CR>
imap <F4> <Esc>:call SwitchBuffer(3)<CR>
nmap <F5> :call SwitchBuffer(4)<CR>
imap <F5> <Esc>:call SwitchBuffer(4)<CR>
nmap <F6> :call SwitchBuffer(5)<CR>
imap <F6> <Esc>:call SwitchBuffer(5)<CR>
nmap <F7> :call SwitchBuffer(6)<CR>
imap <F7> <Esc>:call SwitchBuffer(6)<CR>
nmap <F8> :call SwitchBuffer(7)<CR>
imap <F8> <Esc>:call SwitchBuffer(7)<CR>
" Toggle nerd tree
nmap <F9> :NvimTreeToggle<CR>
" Locate current file in nerdtree
nmap <F10> :NvimTreeFindFile<CR>
" Navigate buffers
nmap <F11> :bprevious<CR>
nmap <F12> :bnext<CR>

" Use ctrl-[hjkl] to select split panes
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

if exists("g:neovide")
  let g:neovide_opacity = 0.9
elseif has("gui_running")
  set guioptions=egmic
endif

if has("gui_running") || exists("g:neovide")
  set showtabline=0
  set guifont=FiraCode\ Nerd\ Font:h13
else
  set termguicolors
endif

colorscheme catppuccin_mocha
set background=dark

