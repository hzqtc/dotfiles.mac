set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

source ~/.vimrc

let mapleader = "\\"

lua << EOF
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.have_nerd_font = true
vim.o.winborder = 'rounded'

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Plugin config
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
    python = { "ruff_organize_imports", "ruff_fix", "ruff_format" },
  },
  format_on_save = {
    timeout_ms = 500,
  },
})
require("aerial").setup({
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
})
require("nvim-tree").setup()
require("blink.cmp").setup({
  keymap = { preset = "enter" },
  fuzzy = { implementation = "lua" }
})

-- LSP config
vim.lsp.config['gopls'] = {
  cmd = { 'gopls' },
  filetypes = { 'go' },
  root_markers = { 'go.mod', 'go.sum', '.git' },
}
vim.lsp.enable('gopls')

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

vim.diagnostic.config({ virtual_text = true })
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

