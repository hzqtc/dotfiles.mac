set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" Allow Command+<C,V,S> in neovim
let g:neovide_input_use_logo = 1
" Command+V to paste
map <D-v> "+p<CR>
imap <D-v> <C-R>+
tmap <D-v> <C-R>+
" Command+C to copy selection
vmap <D-c> "+y
" Command+S to save
map <D-s> :w<CR>
imap <D-s> <Esc>:w<CR>gi
vmap <D-s> <Esc>:w<CR>gv
" Command + A to select all
map <D-a> ggVG
imap <D-a> <Esc>ggVG
vmap <D-a> <Esc>ggVG

