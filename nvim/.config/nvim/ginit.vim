set mouse=a
" Guifont DejaVuSansMono Nerd Font Mono:h11
" Paste with middle mouse click
vmap <LeftRelease> "*ygv
" Paste with <Shift> + <Insert>
imap <S-Insert> <C-R>*
" Right Click Context Menu (Copy-Cut-Paste)
nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
xnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
snoremap <silent><RightMouse> <C-G>:call GuiShowContextMenu()<CR>gv
