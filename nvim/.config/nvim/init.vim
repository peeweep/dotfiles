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
" insert
Plug 'lfilho/cosco.vim'
" vimtex
" Plug 'lervag/vimtex'
" Plug 'fedorenchik/gtags.vim'
Plug 'pechorin/any-jump.vim'
" blame
Plug 'APZelos/blamer.nvim'
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

" insert ;
autocmd FileType javascript,css,YOUR_LANG nmap <silent> <Leader>; <Plug>(cosco-commaOrSemiColon)
autocmd FileType javascript,css,YOUR_LANG imap <silent> <Leader>; <c-o><Plug>(cosco-commaOrSemiColon)

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
set nofixendofline

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

let g:tagbar_type_go = {
	\ 'ctagstype' : 'go',
	\ 'kinds'     : [
		\ 'p:package',
		\ 'i:imports:1',
		\ 'c:constants',
		\ 'v:variables',
		\ 't:types',
		\ 'n:interfaces',
		\ 'w:fields',
		\ 'e:embedded',
		\ 'm:methods',
		\ 'r:constructor',
		\ 'f:functions'
	\ ],
	\ 'sro' : '.',
	\ 'kind2scope' : {
		\ 't' : 'ctype',
		\ 'n' : 'ntype'
	\ },
	\ 'scope2kind' : {
		\ 'ctype' : 't',
		\ 'ntype' : 'n'
	\ },
	\ 'ctagsbin'  : 'gotags',
	\ 'ctagsargs' : '-sort -silent'
\ }


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

" any-jump
" Normal mode: Jump to definition under cursor
nnoremap <leader>j :AnyJump<CR>

" Visual mode: jump to selected text in visual mode
xnoremap <leader>j :AnyJumpVisual<CR>

" Normal mode: open previous opened file (after jump)
nnoremap <leader>ab :AnyJumpBack<CR>

" Normal mode: open last closed search window again
nnoremap <leader>al :AnyJumpLastResults<CR>


" yank and paste
nnoremap <leader>p "+P<cr>
vnoremap <leader>y "+y<cr>

" switch tab
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>0 :tablast<cr>

" coc extensions
let g:coc_global_extensions = [
      \ 'coc-json',
      \ 'coc-pairs',
      \ 'coc-prettier',
      \ 'coc-tsserver',
\ ]

" make table key work on coc.nvim completion
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" blamer
let g:blamer_delay = 10
let g:blamer_prefix = ' > '
highlight Blamer guifg=lightgrey
nnoremap <leader>bt :BlamerToggle<CR>
