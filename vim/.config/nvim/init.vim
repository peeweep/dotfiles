call plug#begin('~/.vim/plugged')
" nerdtree
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
" clang-foramt
Plug 'rhysd/vim-clang-format'
" colorscheme
Plug 'itchyny/lightline.vim'
Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
" lsp
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
call plug#end()

" nerdtree
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.DS_Store$', '\.git$']
" clang-format
let g:clang_format#command = 'clang-format'
autocmd FileType c ClangFormatAutoEnable
let g:clang_format#detect_style_file = 1
" python-language-server
if executable('pyls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
endif
" " clangd
" generate compile_commands.json by cmake:
" $ cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -Bbuild; ln -sf `realpath ./build/compile_commands.json` ./
if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd', '-background-index']},
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
endif
" colorscheme
colorscheme challenger_deep
if has('nvim') || has('termguicolors')
    set termguicolors
endif
let g:lightline = { 'colorscheme': 'challenger_deep'}

set number
set relativenumber
set autoindent
set expandtab
set tabstop=2
set shiftwidth=2

let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'

" disable ← → ↑ ↓
nnoremap <Up> :echomsg "Use k"<cr>
nnoremap <Down> :echomsg "Use k"<cr>
nnoremap <Left> :echomsg "Use h"<cr>
nnoremap <Right> :echomsg "Use l"<cr>

" next prev confirm
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"
