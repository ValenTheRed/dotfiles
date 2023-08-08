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
set diffopt+=algorithm:patience,indent-heuristic,foldcolumn:1

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
" Plug 'vimwiki/vimwiki'
Plug 'danro/rename.vim'         " Rename file currently working on
Plug 'godlygeek/tabular'        " aligning
Plug 'ValenTheRed/ltspice.vim'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'wlangstroth/vim-racket'

Plug 'windwp/nvim-ts-autotag'
Plug 'ValenTheRed/psmdc.nvim'
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

lua require("ps.sessions")
lua require("ps.wiki")

" }}}

"{{{ Plugin config

colorscheme psmdc_dark

" diagnostic is an neovim module
lua require("ps.vim_diagnostic")
lua require("ps.indentline")
lua require('ps.autopairs')
lua require('ps.colorizer')
lua require('ps.gitsigns')
lua require('ps.treesitter')
lua require('ps.tree_playground')
lua require('ps.cmp')
lua require('ps.lsp')
lua require('ps.telescope')
lua require('ps.lualine')

let g:tex_flavor = "latex"

"}}}

" {{{ Autocmds

" Re-source $MYVIMRC if changed
augroup resource_vimrc
    au!
    autocmd BufWritePost $MYVIMRC nested :source $MYVIMRC
augroup END

lua << EOF
vim.api.nvim_create_autocmd("BufNewFile", {
    group = vim.api.nvim_create_augroup("load_from_skeleton_file", { clear=true }),
    pattern = "*.*",
    callback = function()
        -- To restore alternate file register after `:r` clobers it
        local alt_reg = vim.fn.getreg("#")
        local file = vim.fn.stdpath("config") .. [[/templates/skeleton.]] .. vim.fn.expand("%:e")
        if vim.fn.filereadable(file) ~= 0 then
            vim.cmd([[0r ]] .. file)
        end
        vim.fn.setreg("#", alt_reg)
    end,
})
EOF

" from :help incsearch
" TODO: preserve `hlsearch`: on -> '/' on -> on; off -> '/' on -> off
augroup vimrc_incsearch_highlight
    autocmd!
    autocmd CmdlineEnter /,\? :set hlsearch
    " autocmd CmdlineLeave /,\? :set nohlsearch
augroup END

augroup remove_trailing_whitespaces
    au!
    autocmd BufWritePre * :%s/\s\+$//e
augroup END

" }}}

" {{{ Plugin keymaps

" }}}

" {{{ Functions

lua << EOF
close_all_floating_windows = function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local config = vim.api.nvim_win_get_config(win);
        if config.relative ~= "" then
            vim.api.nvim_win_close(win, false);
            -- print('Closing window', win)
        end
    end
end
EOF

" }}}

" {{{ Keymaps

" 10j moves down by 10 lines while j moves by gj
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
vnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
vnoremap <expr> k (v:count == 0 ? 'gk' : 'k')

" remap Ex mode. We can still enter it using `gQ`
nnoremap Q q:

cnoremap <C-k> <Up>
cnoremap <C-j> <Down>

" Yank till EOF; consistency with 'D', 'C' etc.
nnoremap Y y$

" Toggle search hightlighting
nnoremap <F3> :set hlsearch! hlsearch?<CR>

" Search and Replace word and WORD under the cursor throughout the buffer
nnoremap <Leader>r :%s/\<<C-r><C-w>\>//g<Left><Left>
nnoremap <Leader>R :%s/\<<C-r><C-A>\>//g<Left><Left>
" Search using a word boundary
vnoremap <Leader>r "*y:%s/\V\<<C-r><S-*>\>//g<Left><Left>
" search using no word boundry
vnoremap <Leader>R "*y:%s/\V<C-r><S-*>//g<Left><Left>

" Break lines at cursor
nnoremap <silent> <leader>q i<CR><ESC>

" Run a terminal emulator at current working directory
if has('win32') || has('win64')
    " run windows terminal
    nnoremap <silent> <leader>tw :silent !wt -d .<CR>
endif

" Browser like tab movement
nnoremap <C-Tab> gt
nnoremap <C-S-Tab> gT

nnoremap <C-q> :qa<CR>

" Copy/pasting from system clipboard
nnoremap <M-p> "+]p
vnoremap <M-y> "+y
inoremap <M-p> <ESC>"+]pa

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

" We can emulate 'zoom' feature by opening the buffer in a new tab.
" builtin keymap is <C-W><C-T>

" Easy move between split panes
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-h> <C-w><C-h>
nnoremap <C-l> <C-w><C-l>

tnoremap <ESC> <C-\><C-n>

" :sp and :vs are easier to type than :vne and :new so, remap their shortcuts
nnoremap <silent> <C-w><C-v> :vne<Cr>
nnoremap <silent> <C-w><C-s> :new<Cr>

" Easy resize of split panes
nnoremap <M-j> <C-w><C-->
nnoremap <M-k> <C-w><C-+>
nnoremap <M-l> <C-w><C->>
nnoremap <M-h> <C-w><C-<>

nnoremap <leader>erc :e $MYVIMRC<CR>
nnoremap <leader>grc :e $MYGVIMRC<CR>

" }}}

" vim: set fdm=marker:
