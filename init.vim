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
Plug 'vim-test/vim-test'

" Required for Copilot Chat
Plug 'nvim-lua/plenary.nvim' " For async functions and utility
Plug 'CopilotC-Nvim/CopilotChat.nvim', { 'branch': 'main', 'do': 'make tiktoken' }
" Optional: For better markdown rendering in the chat window
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " If you don't have it already
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' } " Another option for markdown
" CopilotChat.nvim recommends `render-markdown.nvim`
Plug 'MeanderingProgrammer/render-markdown.nvim'

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

let test#strategy = 'neovim'
let test#go#runner = 'gotest'
let g:ultest_use_pty = 1

nmap <leader>tn :TestNearest<CR>
nmap <leader>tf :TestFile<CR>
nmap <leader>ts :TestSuite<CR>
nmap <leader>tl :TestLast<CR>
nmap <leader>tv :TestVisit<CR>

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
vim.api.nvim_set_keymap('n', '<leader><up>', ':resize +2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader><down>', ':resize -2<CR>', { noremap = true, silent = true })
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

lua << EOF
require("CopilotChat").setup({
    -- Configuration options go here.
    -- These are just some common ones, refer to the plugin's README for a full list.

    -- General options for the chat window
    window = {
        layout = 'float', -- 'float' (floating window), 'split' (horizontal split), 'vsplit' (vertical split)
        width = 0.8,      -- Percentage of editor width
        height = 0.8,     -- Percentage of editor height
        row = 0.1,        -- Row offset (for float)
        col = 0.1,        -- Column offset (for float)
        relative = 'editor', -- 'editor' or 'cursor' for float position
    },

    -- Mappings (examples, adjust to your preference)
    mappings = {
        -- Open a new chat session (floating window)
        open_chat_window = {
            normal = '<leader>cc',
            insert = '<C-c>cc',
        },
        -- Ask a question about the current selection (visual mode)
        ask_selection = {
            visual = '<leader>ccx',
        },
        -- Explain selected code
        explain_selection = {
            visual = '<leader>cce',
        },
        -- Generate tests for selected code
        generate_tests_selection = {
            visual = '<leader>cct',
        },
        -- Review selected code
        review_selection = {
            visual = '<leader>ccr',
        },
        -- Fix selected code
        fix_selection = {
            visual = '<leader>ccf',
        },
        -- Accept nearest diff (if Copilot suggests a code change)
        accept_diff = {
            normal = '<leader>y', -- Example: <leader>y to accept
        },
        -- Submit prompt in chat window
        submit_prompt = {
            normal = '<CR>',
            insert = '<CR>',
        },
    },

    -- Prompts (customize or add your own)
    prompts = {
        -- Example of a custom prompt
        -- MyCustomPrompt = "Act as an expert {filetype} developer. {selection} Explain this code in detail.",
    },

    -- Agents (if you want to switch between different AI models/behaviors)
    -- This is an advanced feature and might not be immediately necessary.
    -- agents = {
    --     -- "perplexityai", -- Example if you set up an agent for Perplexity AI
    -- },

    -- Enable markdown rendering if you installed `render-markdown.nvim`
    render_markdown = {
        enabled = true,
    },
})

-- Optional: Setup render-markdown.nvim if you are using it
require('render-markdown').setup({
    file_types = { 'markdown', 'copilot-chat' }, -- Ensure it renders both markdown and copilot-chat buffers
})

EOF

nnoremap <leader>cp :let @+ = expand('%:p')<CR>

" When opening the terminal, position it at the bottom and automatically enter
" fish shell.