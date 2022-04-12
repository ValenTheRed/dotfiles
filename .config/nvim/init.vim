"{{{ Vim options

let mapleader = ","

" use true colours; for nvim-colorizer.lua
set termguicolors

" allow mouse
set mouse=nvi

" Set the order of file encodings when reading and creating files.
set fileencodings=utf-8

"Set the order of line endings when reading and creating files.
set fileformats=unix,dos,mac

" number column
set number relativenumber

" always convert `tab` into spaces
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Ignore case unless capital letters present in search
set ignorecase smartcase

set wildignore+=*/tmp/*,*/virenvs/*,*/venvs/*,*/.venv/*,*.so,*.swp,*.zip

" hightlight current line
set cursorline

" delay changing from insert to normal mode in lightline reduced
set ttimeout

" fold manually along indent
set foldmethod=manual

" change signcolumn to accomodate signs
set signcolumn=auto

" time -- in ms -- after which swap file will be written
set updatetime=1000

" for the popup menu in insert mode
set completeopt=menuone,noselect

" NOTE: make sure to set the colour of the colour column wiht the colourscheme
set colorcolumn=79

set matchpairs+=<:>

set splitright splitbelow

" use undo files. Undo directory set sensibly by default
set undofile

" inc/dec works with alphabets
set nrformats+=alpha

" save window sizes with :mks
set sessionoptions+=resize,winpos

" Patience is better than the default in some cases.
" Explanation of indent-heuristic:
" https://vimways.org/2018/the-power-of-diff/#the-indent-heuristics
set diffopt+=algorithm:patience,indent-heuristic

if executable('rg')
    set grepprg=rg\ --vimgrep
    set grepformat^=%f:%l:%c:%m
endif

"}}}

" {{{ Plugins

let s:data_dir = stdpath('data').'/site'
if empty(glob(s:data_dir . '/autoload/plug.vim'))
    if has('win32') || has('win64')
        silent execute '!powershell -c iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim | ni "'.s:data_dir.'" -Force'
    else
        silent execute '!curl -fLo '.s:data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    endif
    augroup vim_plug_bootstrap
        au!
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    augroup END
endif

call plug#begin(stdpath('data') . '/plugged')
Plug 'junegunn/vim-plug'
Plug 'tpope/vim-commentary'     " Comment stuff out
Plug 'tpope/vim-fugitive'       " git integration
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-dispatch'
Plug 'vimwiki/vimwiki'
Plug 'danro/rename.vim'         " Rename file currently working on
Plug 'godlygeek/tabular'        " aligning
Plug 'ValenTheRed/ltspice.vim'
Plug 'ValenTheRed/material.vim'

Plug 'windwp/nvim-autopairs'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': 'TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'lukas-reineke/indent-blankline.nvim' " Indentation guide
Plug 'norcalli/nvim-colorizer.lua'         " RGB code colouring
Plug 'lewis6991/gitsigns.nvim'             " Git Gutter
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'L3MON4D3/LuaSnip'
Plug 'nvim-lualine/lualine.nvim'
" Plug 'ray-x/lsp_signature.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'saadparwaiz1/cmp_luasnip'
" Plug 'uga-rosa/cmp-dictionary'
call plug#end()

let g:material_terminal_italics = 1
let g:material_theme_style = 'ocean'

colorscheme material
hi ColorColumn guibg=#1F2233

" }}}

"{{{ Plugin config

lua require("ps.indentline")
lua require('ps.autopairs')
lua require('ps.colorizer')
lua require('ps.gitsigns')
lua require('ps.treesitter')
lua require('ps.tree_playground')
lua require('ps.cmp')
lua require('ps.lsp')
lua require('ps.telescope.setup')
lua require('ps.telescope.mappings')
lua require('ps.lualine')

"}}}

" {{{ Autocmds

" Re-source $MYVIMRC if changed
augroup re_source
    au!
    autocmd BufWritePost $MYVIMRC nested :source $MYVIMRC
augroup END

" Doesn't work if moved into ftplugin\<ft>.vim
let s:config = has('nvim') ? stdpath('config') : '~/.vim'
augroup skele
    au!
    autocmd BufNewFile *.* silent! execute '0r '.s:config.'/templates/skeleton.'.expand("%:e")
augroup END

" from :help incsearch
" TODO: preserve `hlsearch`: on -> '/' on -> on; off -> '/' on -> off
augroup vimrc_incsearch_highlight
    autocmd!
    autocmd CmdlineEnter /,\? :set hlsearch
    " autocmd CmdlineLeave /,\? :set nohlsearch
augroup END

" Remove trailing whitespaces when file is saved.
augroup fmt
    au!
    autocmd BufWritePre * :%s/\s\+$//e
augroup END

" }}}

" {{{ Plugin keymaps

nmap <leader><space><space> <Plug>VimwikiToggleListItem

" }}}

" {{{ Keymaps

" 10j moves down by 10 lines while j moves by gj
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
vnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
vnoremap <expr> k (v:count == 0 ? 'gk' : 'k')

" Switch command line search history and Ex mode
nnoremap Q q:
nnoremap q: Q

cnoremap <C-k> <Up>
cnoremap <C-j> <Down>

" Yank till EOF; consistency with 'D', 'C' etc.
nnoremap Y y$

" Toggle search hightlighting
nnoremap <F3> :set hlsearch! hlsearch?<CR>

" Search and Replace word and WORD under the cursor throughout the buffer
nnoremap <Leader>r :%s/\<<C-r><C-w>\>//g<Left><Left>
nnoremap <Leader>R :%s/\<<C-r><C-A>\>//g<Left><Left>

" Break lines at cursor
nnoremap <silent> <Leader>j i<CR><ESC>

" Run a terminal emulator at current working directory
if has('win32') || has('win64')
    " run windows terminal
    nnoremap <silent> <leader>tw :silent !wt -d .<CR>
endif

" Browser like tab movement
nnoremap <C-Tab> gt
nnoremap <C-S-Tab> gT

" Copy/pasting from system clipboard
nnoremap <M-p> "+]p
vnoremap <M-y> "+y
inoremap <M-p> <C-\><C-o>:set paste<CR><C-r><C-+><C-\><C-o>:set nopaste<CR>

" Buffer
nnoremap ]b :bn<CR>
nnoremap [b :bp<CR>
nnoremap <Leader># :b#<CR>
nnoremap <Leader>d :b#\|bd! #<CR>

" change directory for whole of nvim
nnoremap <silent> <leader>cd :cd %:p:h<CR>:pwd<CR>
" change directory for the current window
nnoremap <silent> <leader>lc :lcd %:p:h<CR>:pwd<CR>

" Visual diff maps
vnoremap <leader>do :diffget<CR>
vnoremap <leader>dp :diffput<CR>

" A poor man's 'zoom' -- open buffer in a new tab
nnoremap <leader>oo :tab split<CR>

" Easy move between split panes
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-h> <C-w><C-h>
nnoremap <C-l> <C-w><C-l>

" Easy resize of split panes
nnoremap <M-j> <C-w><C-->
nnoremap <M-k> <C-w><C-+>
nnoremap <M-l> <C-w><C->>
nnoremap <M-h> <C-w><C-<>

nnoremap <leader>erc :e $MYVIMRC<CR>
nnoremap <leader>grc :e $MYGVIMRC<CR>

" }}}

" vim: set fdm=marker:
