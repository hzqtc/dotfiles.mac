set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

source ~/.vimrc

let mapleader = "\\"

lua << EOF
require('mini.indentscope').setup()
require("oil").setup({
  buf_options = {
    buflisted = true,
  },
  delete_to_trash = true,
})
require("conform").setup({
  formatters_by_ft = {
    go = { "goimports", "gofmt" },
    json = { "prettier" },
    markdown = { "prettier" },
    sh = { "shfmt" },
    objc = { "clang-format" },
    python = { "ruff-format" },
  },
  format_on_save = {
    timeout_ms = 500,
  },
})
EOF

" Enable logo (Command/Windows) key support in Neovide
let g:neovide_input_use_logo = 1
" Command+V to paste
nmap <D-v> "+p
imap <D-v> <Esc>"+pa
cmap <D-v> <C-r>+
tmap <D-v> <C-\><C-n>"+pa
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

if !filereadable('/tmp/nvimsocket')
  call serverstart('/tmp/nvimsocket')
endif

" briefly highlight yanked text
autocmd TextYankPost * silent! lua vim.highlight.on_yank()

