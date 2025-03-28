call plug#begin('~/.local/share/nvim/plugged')

" Go development plugins
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'  " optional, for file icons
Plug 'hashivim/vim-terraform'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'joshdick/onedark.vim'
Plug 'github/copilot.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'vim-test/vim-test'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'

call plug#end()

" Enable syntax highlighting
syntax on

" Enable file type detection
filetype plugin indent on

" Set up CoC (Conquer of Completion) for Go
let g:coc_global_extensions = ['coc-go']

let mapleader = "\<Space>"

let g:lightline = {
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'FugitiveHead'
  \ },
  \ }

" Optional: Set up some basic settings
set number
set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab

let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1

let g:copilot_filetypes = {
  \ 'go': v:true,
  \ 'markdown': v:true,
  \ 'text': v:true,
  \ 'html': v:true,
  \ 'javascript': v:true,
  \ 'typescript': v:true,
  \ 'python': v:true,
  \ }

lua << EOF
require'nvim-tree'.setup {
  -- Disable netrw at the start
  disable_netrw       = true,
  hijack_netrw        = true,
  open_on_tab         = false,
  hijack_cursor       = false,
  update_cwd          = true,
  update_focused_file = {
    enable      = true,
    update_cwd  = true,
    ignore_list = {}
  },
  view = {
    width = 45,
    side = 'left',
  },
  diagnostics = {
    enable = true,
  },
}
EOF

lua << EOF
vim.api.nvim_set_keymap('n', '<leader>t', ':vsplit | terminal fish<CR><C-w>J<C-w>30-', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>f', ':Files<CR>', { noremap = true, silent = true })
EOF

colorscheme onedark

lua << EOF
-- Define the Lua function to adjust the NvimTree width
vim.cmd([[
function! AdjustNvimTreeWidth(delta)
  let l:current_width = winwidth(0)
  execute "vertical resize" l:current_width + a:delta
endfunction
]])

-- Set key mappings using vim.api.nvim_set_keymap
vim.api.nvim_set_keymap('n', '<leader><Left>', ':call AdjustNvimTreeWidth(5)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader><Right>', ':call AdjustNvimTreeWidth(-5)<CR>', { noremap = true, silent = true })
EOF

lua << EOF
require'lspconfig'.gopls.setup{}
EOF

lua << EOF
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = false;
    ultisnips = false;
    luasnip = false;
  };
}
EOF

nnoremap <leader>cp :let @+ = expand('%:p')<CR>

" When opening the terminal, position it at the bottom and automatically enter
" fish shell.










