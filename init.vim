set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

source ~/.vimrc

let mapleader = "\\"

lua << EOF
require("flash").setup({
  label = {
    rainbow = {
      enabled = true,
    },
    uppercase = false,
  },
  modes = {
    search = {
      enabled = true,
    },
    char = {
      enabled = false,
    }
  },
})
require('mini.indentscope').setup()
EOF

" Enable logo (Command/Windows) key support in Neovide
let g:neovide_input_use_logo = 1
" Command+V to paste
nmap <D-v> "+p
imap <D-v> <Esc>"+pi
cmap <D-v> <C-r>+
tmap <D-v> <C-\><C-n>"+pi
" Command+C to copy selection
nmap <D-c> "+yy
vmap <D-c> "+y
" Command+X to cut selection
nmap <D-x> "+dd
vmap <D-x> "+d
" Command+S to save
nmap <D-s> :w<CR>
imap <D-s> <Esc>:w<CR>gi
vmap <D-s> <Esc>:w<CR>gv
" Command + A to select all
nmap <D-a> ggVG
imap <D-a> <Esc>ggVG
vmap <D-a> <Esc>ggVG

