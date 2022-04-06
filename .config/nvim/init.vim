set termguicolors "use true colours; for nvim-colorizer.lua

"{{{ PLUGINS

let s:data_dir = has('nvim') ? stdpath('data').'/site' : '~/.vim'
if empty(glob(s:data_dir . '/autoload/plug.vim'))
    " NOTE: set $XDG_DATA_HOME beforehand
    if has('win32') || has('win64')
        silent execute 'iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim | ni "'.s:data_dir.'" -Force'
    else
      silent execute '!curl -fLo '.s:data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  endif
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin((has('nvim') ? stdpath('data') : '~/.vim') . '/plugged')
Plug 'junegunn/vim-plug'
Plug 'tpope/vim-commentary'     " Comment stuff out
Plug 'tpope/vim-fugitive'       " git integration
" Plug 'itchyny/lightline.vim'    " Better status bar
Plug 'joshdick/onedark.vim'     " ColorScheme
Plug 'ValenTheRed/oceanic-next'
Plug 'ValenTheRed/material.vim'
Plug 'ValenTheRed/ltspice.vim'
Plug 'danro/rename.vim'         " Rename file currently working on
" Plug 'ctrlpvim/ctrlp.vim'       " Fuzzy finder
Plug 'godlygeek/tabular'        " aligning
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'vimwiki/vimwiki'
Plug 'tpope/vim-dispatch'
if has('nvim')
    Plug 'windwp/nvim-autopairs'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-treesitter/nvim-treesitter', {'branch': '0.5-compat'}
    Plug 'lukas-reineke/indent-blankline.nvim' " Indentation guide
    Plug 'norcalli/nvim-colorizer.lua'         " RGB code colouring
    Plug 'lewis6991/gitsigns.nvim'             " Git Gutter
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
    Plug 'L3MON4D3/LuaSnip'
    Plug 'nvim-lualine/lualine.nvim'
    " Plug 'ray-x/lsp_signature.nvim'
    " Plug 'hrsh7th/nvim-compe'                  " Completion engine
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'saadparwaiz1/cmp_luasnip'
    " Plug 'uga-rosa/cmp-dictionary'
endif
call plug#end()

let g:material_terminal_italics = 1
let g:material_theme_style = 'ocean'
colorscheme material
"}}}

"{{{ VIM OPTIONS

filetype plugin indent on
set mouse=nvi
"Set the order of file encodings when reading and creating files.
set fileencodings=utf-8
"Set the order of line endings when reading and creating files.
set fileformats=unix,dos,mac
set number relativenumber
set expandtab
set tabstop=4 shiftwidth=4
set softtabstop=4
" Next 2: search case-insensitive if lower case string
" sensitive if one or more upper case char in string
set smartcase
set ignorecase
set wildignore+=*/tmp/*,*/virenvs/*,*/venvs/*,*.so,*.swp,*.zip
" Removes --MODE-- when status bar present
" set noshowmode
" hightlight current line
set cursorline
" delay changing from insert to normal mode in lightline reduced
set ttimeout
" fold manually along indent
set foldmethod=manual
" change signcolumn to accomodate signs
set signcolumn=auto
set updatetime=1000
set completeopt=menuone,noselect
set colorcolumn=79
hi ColorColumn guibg=#1F2233
set matchpairs+=<:>
set splitright splitbelow
" tell it to use an undo file
set undofile
" path of the file
" inc/dec works with alphabets
set nrformats+=alpha
set sessionoptions+=resize,winpos
" Uses '/' as path seperator
let mapleader = ","

if executable('rg')
    set grepprg=rg\ --vimgrep
    set grepformat^=%f:%l:%c:%m
endif
"}}}

"{{{ PLUGIN CONFIG

" Lightline config
let g:lightline = {
   \ 'colorscheme': 'material_vim',
   \ 'active': {
   \   'left': [[ 'mode', 'paste' ],
   \            ['gitbranch', 'readonly', 'relativepath', 'modified']],
   \  },
   \  'component_function': {
   \   'gitbranch': 'FugitiveHead',
   \  },
   \ }
let s:extra_lightline = { 'component': { } }

if has('nvim')

    let g:lightline['active']['left'][1] = ['gitsigns_status'] + g:lightline['active']['left'][1]
    call extend(g:lightline, {
       \ 'inactive': {
       \   'left': [[ 'gitsigns_status', 'relativepath', 'modified']]
       \  },
       \ })
    call extend(s:extra_lightline['component'], {
     \    'gitsigns_status': "%{get(b:, 'gitsigns_status', '')}"
     \ })

    let g:indent_blankline_char = '¦'
    let g:indent_blankline_filetype_exclude = ['help', 'markdown', 'vimwiki']
    let g:indent_blankline_buftype_exclude = ['terminal']

    lua require('ps.autopairs')
    lua require('ps.colorizer')
    lua require('ps.gitsigns')
    lua require('ps.treesitter')
    " lua require'compe-config'
    lua require('ps.cmp')
    lua require('ps.lsp')
    lua require('ps.telescope')
    lua require('ps.lualine')
endif
call extend(g:lightline, s:extra_lightline)

let g:ctrlp_map = '<c-\>'
let g:ctrlp_working_path_mode = 'ra'
"}}}

"{{{ PLUGIN KEYMAP
" nnoremap <Leader>fm :CtrlPMRUFiles<CR>
nmap <leader><space><space> <Plug>VimwikiToggleListItem
"}}}

"{{{ KEYMAPS

"if has('win32')
"  call serverstart('\\.\pipe\nvim-pipe-14380-0')
"else
"  call serverstart('nvim.sock')
"endif

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

" from :help incsearch (hlsearch before / is not retained)
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

" Yank till EOF
nnoremap Y y$

" Toggle search hightlighting
nnoremap <F3> :set hlsearch! hlsearch?<CR>

" Search and Replace word and WORD under the cursor throughout the buffer (on
" and each line)
nnoremap <Leader>r :%s/\<<C-r><C-w>\>//g<Left><Left>
nnoremap <Leader>R :%s/\<<C-r><C-A>\>//g<Left><Left>

" Break lines at cursor
nnoremap <silent> <Leader>j i<CR><ESC>

" Run a terminal prog at current working directory
if has('win32') || has('win64')
    nnoremap <silent> <leader>ta :silent !alacritty --hold --working-directory .<CR>
    nnoremap <silent> <leader>tw :silent !wt -d .<CR>
"else
"    nnoremap <silent> <leader>t :vert term ++cols=40<CR>
endif

" Tab movement
nnoremap <C-Tab> gt
nnoremap <C-S-Tab> gT

" Paste from system clipboard
nnoremap <M-p> "+]p
vnoremap <M-y> "+y
inoremap <M-p> <C-\><C-o>:set paste<CR><C-r><C-+><C-\><C-o>:set nopaste<CR>

" Buffer stuff
nnoremap ]b :bn<CR>
nnoremap [b :bp<CR>
nnoremap <Leader># :b#<CR>
nnoremap <Leader>d :b#\|bd! #<CR>
nnoremap <silent> <leader>cd :cd %:p:h<CR>:pwd<CR>
nnoremap <silent> <leader>lc :lcd %:p:h<CR>:pwd<CR>

" Visual Diff stuff
vnoremap <leader>do :diffget<CR>
vnoremap <leader>dp :diffput<CR>

" Copy 'zoom' functionality by opening a window of the current buffer on
" another tab
nnoremap <leader>oo :tab split<CR>

" Move between split panes
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-h> <C-w><C-h>
nnoremap <C-l> <C-w><C-l>

" Resize split panes
nnoremap <M-j> <C-w><C-->
nnoremap <M-k> <C-w><C-+>
nnoremap <M-l> <C-w><C->>
nnoremap <M-h> <C-w><C-<>

nnoremap <leader>erc :e $MYVIMRC<CR>
nnoremap <leader>grc :e $MYGVIMRC<CR>
"}}}

" vim: set fdm=marker:
