" Use .vim for vim user settings on Windows
if has('win32') || has('win64')
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif
set nocompatible
"Set default buffer encoding to UTF-8.
set encoding=utf-8
"Set the order of file encodings when reading and creating files.
set fileencodings=utf-8
"Set the order of line endings when reading and creating files.
set fileformats=unix,dos,mac
" make backspace work like most other programs
set backspace=2
" use true colours
set termguicolors
set number relativenumber
set tabstop=4 shiftwidth=4 softtabstop=4 expandtab
set autoindent
filetype plugin indent on
" Hightlight searches
set hlsearch
" Show matches while searching
set incsearch
" Next 2: search case-insensitive if lower case string
" sensitive if one or more upper case char in string
set smartcase
set ignorecase
" Remove trailing whitespaces when file is saved.
autocmd BufWritePre * :%s/\s\+$//e
set wildignore+=*/tmp/*,*/venvs/*,*.so,*.swp,*.zip
" Shows the status bar in single file mode
set laststatus=2
" Removes --MODE-- when status bar present
set noshowmode
" hightlight current line
set cursorline
" delay changing from insert to normal mode in lightline reduced
set ttimeout ttimeoutlen=50
" fold manually along indent
set foldmethod=indent
" folds are not applied when file is opened
set nofoldenable
" auto reload file if changes happened outside of vim
set autoread
" change signcolumn to accomodate signs
set signcolumn=yes
set updatetime=1000

" Hightligts all the text beyond 80col in dark grey
" augroup vimrc_autocmds
"     autocmd BufEnter * highlight OverLength ctermbg=darkgrey guibg=#592929
"     autocmd BufEnter * match OverLength /\%80v.*/
" augroup END
set colorcolumn=80

" To stop spiting vim files all over the system
set backupdir=~/.vim/tmp
set directory=~/.vim/tmp
set splitright splitbelow
" delete comment characters when joining commented lines
set formatoptions+=j
" tell it to use an undo file
set undofile
" path of the file
set undodir=~/.vim/vimundo
" inc/dec works with alphabets
set nrformats+=alpha

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" ---PLUGINS----
""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:polyglot_disabled = ['autoindent', 'sensible']
call plug#begin('~/.vim/plugged')
" File explorer in vim
Plug 'preservim/nerdtree'
" Comment stuff out
Plug 'tpope/vim-commentary'
" Insert or delete brackets, quotes in pair
Plug 'jiangmiao/auto-pairs'
" git integration
Plug 'tpope/vim-fugitive'
" Better status bar
Plug 'itchyny/lightline.vim'
let g:lightline = {
   \ 'colorscheme': 'onedark',
   \ 'active': {
   \   'left': [[ 'mode', 'paste' ],
   \            ['gitbranch', 'readonly', 'filename', 'modified']]
   \  },
   \  'component_function': {
   \   'gitbranch': 'FugitiveHead'
   \  },
   \ }
" ColorScheme
Plug 'joshdick/onedark.vim'
" Rename file currently working on
Plug 'danro/rename.vim'
" Indentation guide
Plug 'Yggdroot/indentLine'
" Fuzzy finder
Plug 'ctrlpvim/ctrlp.vim'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-surround'

Plug 'sheerun/vim-polyglot'
Plug 'airblade/vim-gitgutter'
Plug 'dhruvasagar/vim-zoom'
Plug 'tpope/vim-repeat'
Plug 'vimwiki/vimwiki'
call plug#end()
"""""""""""""""""""
" ---END PLUGINS---
"""""""""""""""""""

syntax on
colorscheme onedark


""""""""""""""""
" ---Keymaps---
""""""""""""""""
let mapleader = ","
nmap <leader><space><space> <Plug>VimwikiToggleListItem
let g:indentLine_fileTypeExclude = ['help', 'terminal', 'markdown', 'tex', 'vimwiki']
let g:ctrlp_map = '<c-\>'
let g:ctrlp_working_path_mode = 'ra'
map <silent> <F2> :NERDTreeToggle<CR>
nnoremap <Leader>z :CtrlPBuffer<CR>
" 10j moves down by 10 lines while j moves by gj
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap Y y$
nnoremap <Leader>sa ggVG
nnoremap <F3> :set hlsearch! hlsearch?<CR>
nnoremap <Leader>r :%s/\<<C-r><C-w>\>//g<Left><Left>
if has('win32') || has('win64')
    nnoremap <silent> <leader>ta :term ++hidden ++close alacritty --hold --working-directory .<CR>
    nnoremap <silent> <leader>tw :term ++hidden ++close wt -d .<CR>
else
    nnoremap <silent> <leader>t :vert term ++cols=40<CR>
endif
" Buffer stuff
nnoremap <Leader>n :bn<CR>
nnoremap <Leader>p :bp<CR>
nnoremap <Leader># :b#<CR>
nnoremap <Leader>d :b#\|bd! #<CR>
nnoremap <silent> <leader>cd :lcd %:p:h<CR>:pwd<CR>
" Break lines at cursor
nnoremap <silent> <Leader>j i<CR><ESC>
" Move between split panes
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-h> <C-w><C-h>
nnoremap <C-l> <C-w><C-l>
nnoremap <leader>erc :e $MYVIMRC<CR>
nnoremap <leader>grc :e $MYGVIMRC<CR>

" Just use `Vgq` to break at textwidth...
function SplitLineAt(column)
    if len(getline(".")) > a:column
        let test = match(getline(".")[a:column], '\zs\s')
        if test == 0
            execute("norm! 0". a:column. "li\r")
        else
            execute("norm! 0". a:column. "lBi\r")
        endif
        return 1
    else
        return 0
    endif
endfunction
nnoremap <silent> <leader><leader>j :call SplitLineAt(80)<CR>
