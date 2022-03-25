set exrc
set guicursor=
set relativenumber
set hidden
set nohlsearch
set number
set cursorline
set showmatch
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set nu
set smartindent
set nowrap
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8
set noshowmode
set signcolumn=yes
set colorcolumn=120
set splitbelow
"silent pattern not found in compe
set shortmess+=c
set completeopt=menu,menuone,noselect
let g:completetion_matching_strategy_list = ['fuzzy', 'substring', 'exact']
set splitbelow
set splitright
set list
set listchars=tab:»·,eol:↲,nbsp:␣,space:·

set updatetime=50

let mapleader = " "

set background=dark
highlight Normal guibg=dark

filetype plugin indent on
syntax on

call plug#begin('~/.config/nvim/plugged')
Plug 'christoomey/vim-tmux-navigator'
Plug 'rust-lang/rust.vim'
Plug 'rust-lang/rust.vim'
Plug 'ziglang/zig.vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'dstein64/vim-startuptime'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'nvim-lualine/lualine.nvim'
Plug 'vim-pandoc/vim-pandoc'
Plug 'gruvbox-community/gruvbox'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'nvim-lua/popup.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'onsails/lspkind-nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'

Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rhysd/committia.vim'
Plug 'nvim-neorg/neorg'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'numToStr/comment.nvim'
call plug#end()

colorscheme gruvbox
" configure plugins
lua require('burm')

nnoremap <TAB> :tabn<CR>
nnoremap <S-TAB> :tabp<CR>
nnoremap <leader>t :tabnew<CR>
nnoremap <leader><CR> :so ~/.config/nvim/init.vim<CR>
nnoremap <leader>cd :lcd %:p:h<CR>
nnoremap ]p :cnext<CR>
nnoremap [p :cprev<CR>
nnoremap <C-q> <cmd>lua require('burm.funcs').toggle_quickfix()<CR>
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({previewer=false, layout_config={width=0.65}}))<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fd <cmd>lua require('telescope.builtin').diagnostics(require('telescope.themes').get_dropdown({layout_config={width=0.80}}), {bufnr=0})<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>gf <cmd>lua require('telescope.builtin').git_files()<cr>
nnoremap <leader>df <cmd>lua require('telescope.builtin').git_files( { cwd = "$SRC/dotfiles" } )<cr>
nnoremap <leader>j <cmd>lua require('burm.custom.neorg').journal_today()<cr>
" Yank into clipboard
vnoremap <leader>y "+y
nnoremap <leader>p "+p
" LSP Telescope
nnoremap <leader>ds <cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>
" Nvim Tree Lua
nnoremap <C-n> :NvimTreeToggle<cr>
nnoremap <leader>r :NvimTreeRefresh<cr>
" Terminal mappings
tnoremap <ESC> <C-\><C-n>

let g:airline#extensions#syntastic#enabled = 1

" Rust configuration
let g:rustfmt_autosave = 1

augroup BURMUDAR
    autocmd!
    autocmd BufWritePre * %s/\s\+$//e
augroup END

augroup PYTHON
    autocmd BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent
augroup END

augroup RUST
    autocmd BufNewFile,BufRead *.rs nnoremap <F5> :RustRun<CR>
augroup END