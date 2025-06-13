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
if has('nvim')
  Plug 'echasnovski/mini.indentscope'
else
  Plug 'Yggdroot/indentLine'
endif

" Move text
Plug 'matze/vim-move'
let g:move_key_modifier = 'C'
let g:move_key_modifier_visualmode = 'C'

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

if has('nvim')
  " Faster search
  Plug 'folke/flash.nvim'
  " Auto fix typos
  Plug 'ck-zhang/mistake.nvim'
endif

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

let g:filetype_icons = {
      \ 'python':     '',
      \ 'javascript': '',
      \ 'typescript': '',
      \ 'html':       '',
      \ 'css':        '',
      \ 'scss':       '',
      \ 'json':       '',
      \ 'yaml':       '',
      \ 'toml':       '',
      \ 'markdown':   '',
      \ 'lua':        '',
      \ 'vim':        '',
      \ 'sh':         '',
      \ 'zsh':        '',
      \ 'bash':       '',
      \ 'make':       '',
      \ 'c':          '',
      \ 'cpp':        '',
      \ 'java':       '',
      \ 'go':         '',
      \ 'rust':       '',
      \ 'php':        '',
      \ 'ruby':       '',
      \ 'perl':       '',
      \ 'r':          '󰟔',
      \ 'dockerfile': '',
      \ 'gitcommit':  '',
      \ 'gitconfig':  '',
      \ 'text':       '',
      \ 'conf':       '',
      \ 'ini':        '',
      \ 'sql':        '',
      \ 'default':    '',
      \ }

" Buffers list with the current buffer name in []
function! AirlineBufferList()
  let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val)')
  let names = []
  " Show buffers' indexes rather than buffer numbers
  let index = 1
  for b in buffers
    let path = bufname(b)
    let ft = getbufvar(b, '&filetype')
    let icon = get(g:filetype_icons, ft, g:filetype_icons['default'])
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
      let name .= ' ●'
    endif

    if b == bufnr('')
      call add(names, printf('[%d %s %s]', index, icon, name))
    else
      call add(names, printf('%d %s %s', index, icon, name))
    endif
    let index += 1
  endfor
  return join(names, ' | ')
endfunction
let g:airline_section_c = '%{AirlineBufferList()}'

function! AirlineFiletype()
  let ft = &filetype
  return get(g:filetype_icons, ft, g:filetype_icons['default']) . ' ' . ft
endfunction

let g:airline_section_x = '%{AirlineFiletype()}'

" Current working directory
function! AirlineCwd()
  return fnamemodify(getcwd(), ':~:.')
endfunction
let g:airline_section_y = '%{AirlineCwd()}'

function! AirlineSectionZ()
  let os_icon = ''
  if has('mac') || has('macunix') || has('osx')
    let os_icon = "󰀵"
  elseif has('unix') && !has('macunix')
    let os_icon = "󰌽"
  elseif has('win32') || has('win64')
    let os_icon = "󰍲"
  endif
  let lnum = line('.')
  let colnum = col('.')
  let total = line('$')
  let scroll = float2nr(100.0 * lnum / total)
  return os_icon . ' ' . lnum . ':' . colnum . ' ' . scroll . '% '
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
nmap Y y$
" Close current buffer
nmap <leader>x :bw<CR>
" Close all buffers with confirmation
nmap <leader>X :call ConfirmCloseAllBuffers()<CR>
" Toggle search highlights
nmap <leader>h :set hlsearch!<CR>
" Open Startify
nmap <leader>s :Startify<CR>
" Toggle background between light and dark
nmap <leader>b :call ToggleBackground()<CR>
" Edit .vimrc
nmap <leader>e :e ~/.vimrc<CR>
" Edit init.vim
nmap <leader>E :e ~/.config/nvim/init.vim<CR>
" Source current file.
nmap <leader>r :source %<CR>
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
" Quick dial for buffer 1-4
nmap <F1> :call SwitchBuffer(0)<CR>
imap <F1> <Esc>:call SwitchBuffer(0)<CR>
nmap <F2> :call SwitchBuffer(1)<CR>
imap <F2> <Esc>:call SwitchBuffer(1)<CR>
nmap <F3> :call SwitchBuffer(2)<CR>
imap <F3> <Esc>:call SwitchBuffer(2)<CR>
nmap <F4> :call SwitchBuffer(3)<CR>
imap <F4> <Esc>:call SwitchBuffer(3)<CR>
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

" Set .as file as applescript
autocmd BufRead,BufNewFile *.as set filetype=applescript

if exists("g:neovide")
  set lines=42
  set columns=160
elseif has("gui_running")
  set guioptions=egmic
  set lines=35
  set columns=159
endif

if has("gui_running") || exists("g:neovide")
  set showtabline=0
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

