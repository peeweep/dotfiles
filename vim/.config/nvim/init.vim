set number
set relativenumber
set wrap
set autoindent expandtab tabstop=2 shiftwidth=2
set paste

let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'
let g:ruby_host_prog = '/usr/bin/ruby'

" disable ← → ↑ ↓
nnoremap <Up> :echomsg "Use k"<cr>
nnoremap <Down> :echomsg "Use k"<cr>
nnoremap <Left> :echomsg "Use h"<cr>
nnoremap <Right> :echomsg "Use l"<cr>

" next prev confirm
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"
 

call plug#begin('~/.vim/plugged')

" nerdtree
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.DS_Store$', '\.git$']

" lsp
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
 

if executable('pyls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
endif

if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd', '-background-index']},
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
" generate compile_commands.json:
" $ cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -Bbuild; ln -sf `realpath ./build/compile_commands.json` ./
endif


" colorscheme 
Plug 'itchyny/lightline.vim'
Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }

call plug#end()


colorscheme challenger_deep
if has('nvim') || has('termguicolors')
    set termguicolors
endif
let g:lightline = { 'colorscheme': 'challenger_deep'}

