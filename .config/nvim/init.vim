" NOTE: stdpath('data') on MacOS = ~/.local/share/nvim
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')
Plug 'sainnhe/gruvbox-material'
Plug 'sainnhe/edge'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'windwp/nvim-autopairs'
Plug 'lewis6991/gitsigns.nvim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'cespare/vim-toml', { 'branch': 'main' }
Plug 'neovim/nvim-lspconfig'
call plug#end()

" colorscheme
set termguicolors		        " enable true color terminal
syntax enable                   " enable syntax processing
set background=light
colorscheme edge

" fix scrolling colors in Vim
" https://github.com/kovidgoyal/kitty/issues/108
" let &t_ut=''

" whitespace
set expandtab			        " convert tabs to spaces
set tabstop=4			        " number of visual spaces per TAB
set softtabstop=4		        " number of spaces in TAB when editing
set shiftwidth=4		        " size of indent
set backspace=indent,eol,start  " make backspace work as expected
filetype indent on		        " load filetype-specific indent files

" built-in eye-candy
set number			            " show line numbers
set ruler			            " show ruler
set showcmd			            " show command in bottom bar
set cursorline			        " highlight current line
set lazyredraw			        " redraw only when we need to
set showmatch			        " highlight matching [{()}]
set colorcolumn=80,120		    " draw a line at 80/120 characters

" scrolling
set mouse=a

" allow copy to system clipboard
set clipboard=unnamed

" enable omnifunc for manual completion
filetype plugin on
set omnifunc=syntaxcomplete#Complete
" automatically close scratch buffer upon exiting insert mode
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
" disable scratch buffer entirely
" set completeopt=menu

" -----------------------------------------------------------------------------
" Start: Plugin configurations
" -----------------------------------------------------------------------------

" ---nvim-tree setup---
lua << END
require('nvim-tree').setup {
    update_focused_file = {
        enable = true,
        update_cwd = true,
    },
    view = {
        width = 40,
        side = "left",
    },
    renderer = {
        icons = {
          show = {
            file = true,
            folder = false,
            folder_arrow = true,
            git = true,
          },
          glyphs = {
            default = "●",
            symlink = "◎",
            folder = {
              arrow_open = "▼",
              arrow_closed = "▶",
            },
            git = { 
              unstaged = "✗",
              staged = "✓",
              unmerged = "*",
              renamed = "➜",
              untracked = "U",
              deleted = "D",
              ignored = "◌",
            },
          },
        },
    }
}
END
" map ctrl-x to toggle NERDTree
nmap <C-x> :NvimTreeToggle<CR>

" ---fzf keybinds---
" map ctrl-a to search in filename
nmap <C-a> :Files<CR>

" ---lualine setup---
lua << END
require('lualine').setup {
    options = { 
        icons_enabled = false,
        component_separators = ''
    }
}
END

" ---nvim-treesitter setup---
lua << END
require('nvim-treesitter.configs').setup {
    -- one of "all" or a list of languages
    ensure_installed = { 
        "c", 
        "python", 
        "go", 
        "yaml",
        "json",
        "bash", 
        "vim",
        "lua",
        "comment"
    },
    -- List of parsers to ignore installing
	ignore_install = { "" }, 
	highlight = {
        -- false will disable the whole extension
		enable = true,
        -- list of languages that will be disabled
		disable = { "toml" }, 
	},
	indent = { enable = true, disable = { "" } }
}
END

" ---nvim-autopairs setup---
lua << EOF
require("nvim-autopairs").setup()
EOF

" ---gitsigns setup---
lua << END
require('gitsigns').setup()
END

" ---nvim-lspconfig setup---
lua << END
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Update global diagnostic config (specifically, no virtual text)
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = false,
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

require('lspconfig')['clangd'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}

require('lspconfig')['pyright'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}
END
