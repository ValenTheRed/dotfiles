let $MYGVIMRC = has('nvim') ? stdpath('config').'/ginit.vim' : '~/.vim/.gvimrc'

" From tpope's .vimrc
command! -bar -nargs=0 Bigger  :let &guifont = substitute(&guifont,'\d\+$','\=submatch(0)+1','')
command! -bar -nargs=0 Smaller :let &guifont = substitute(&guifont,'\d\+$','\=submatch(0)-1','')
nnoremap <silent> _ :Smaller<CR>
nnoremap <silent> + :Bigger<CR>

if exists('g:neovide') "{{{1
    set guifont=JetBrainsMonoNL\ Nerd\ Font:h10:#e-subpixelantialias
    let g:neovide_cursor_animation_length=0.04

    function NeovideToggleFullScreen()
        let g:neovide_fullscreen = !g:neovide_fullscreen
    endfunction
    nnoremap <F11> :call NeovideToggleFullScreen()<CR>

elseif exists('g:fvim_loaded') "{{{1
    " good old 'set guifont' compatibility
    set guifont=Jetbrains\ mono\ nl:h13

    nnoremap <F11> :FVimToggleFullScreen<CR>
    " 'none', 'transparent', 'blur' or 'acrylic'
    FVimBackgroundComposition 'none'
    FVimFontLigature v:false

    " external popup menu
    " FVimUIPopupMenu v:true

elseif has('gui_running') "{{{1
    set guifont=Fira_Code:h12
    " IMPORTANT: go-=... doesn't work without go=go
    set guioptions=go
    set guioptions-=mTrRlL
    " Stop error beeping. See wiki for more.
    set vb t_vb=
    if has('win32') || has('win64')
        " Enable ligature support for Windows (kind of)
        set renderoptions=type:directx
        " Full screen Gvim in Windows
        noremap <silent> <F11> :call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
        " Trick to maximising gvim when opening it
        au GUIenter * simalt ~x
    endif

else "{{{1
    set guifont=Fira\ Code:h12
endif
"}}}

" vim: set fdm=marker:
