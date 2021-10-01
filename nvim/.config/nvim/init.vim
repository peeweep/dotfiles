call plug#begin('~/.vim/plugged')
" git
Plug 'tpope/vim-fugitive'
" nerdtree
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
" clang-foramt
" Plug 'rhysd/vim-clang-format'
" colorscheme
Plug 'vim-airline/vim-airline'
Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
" translator
Plug 'voldikss/vim-translator'
" coc
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" history
Plug 'mhinz/vim-startify'
" tagbar
Plug 'preservim/tagbar'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
call plug#end()

" nerdtree
let g:NERDTreeShowHidden=1
let g:NERDTreeIgnore=['\.DS_Store$', '\.git$']

"  " clang-format
"  let g:clang_format#command = 'clang-format'
"  autocmd FileType c ClangFormatAutoEnable
"  let g:clang_format#detect_style_file = 1

" colorscheme
colorscheme challenger_deep
if has('nvim') || has('termguicolors')
    set termguicolors
endif

" full file path
let g:airline_section_c='%F'

" vim
set number
set relativenumber
set autoindent
set expandtab
set tabstop=2
set shiftwidth=2
set nobackup
set nowritebackup
set showtabline=2
set modifiable
set ff=unix
set encoding=utf-8
set fencs=utf-8,ucs-bom,gb18030,gbkgb2312,shift-jis,cp936
set termencoding=utf-8
set fileencoding=utf-8
set whichwrap+=<,>,h,l

" jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif


" gopls add missing import
autocmd BufWritePre *.go silent! call CocAction('runCommand', 'editor.action.organizeImport')

" NERDTree
nnoremap <space>e :NERDTree<cr>

" Formatting selected json.
vnoremap <space>fj :CocCommand prettier.formatFile<cr>

" tagbar
nmap <F8> :TagbarToggle<CR>

" vim-translator
" Echo translation in the cmdline
nmap <silent> <Leader>t <Plug>Translate
vmap <silent> <Leader>t <Plug>TranslateV
" Display translation in a window
nmap <silent> <Leader>w <Plug>TranslateW
vmap <silent> <Leader>w <Plug>TranslateWV
" Replace the text with translation
nmap <silent> <Leader>r <Plug>TranslateR
vmap <silent> <Leader>r <Plug>TranslateRV

" yank and paste
nnoremap <leader>p "+P<cr>
vnoremap <leader>y "+y<cr>

" switch tab
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>0 :tablast<cr>
