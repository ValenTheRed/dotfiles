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
