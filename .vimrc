set shell=/bin/zsh

"-----------
" encoding
"-----------
set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8
set termencoding=utf8
set fileencodings=utf-8,ucs-boms,euc-jp,ep932
set fileformats=unix,dos,mac
set ambiwidth=double
set nobomb
set t_Co=256

"------------
" vim options
"------------
" スワップファイルの作成先を変更
set noswapfile

" ヤンクをクリップボードへ繋ぐ
set clipboard+=unnamed

" ビープ音を消す
set belloff=all

" 行番号系
set number

" タイトル系
set title

" 挿入モードでバックスペース削除を有効
set backspace=indent,eol,start

" カーソル位置 
set cursorline
set cursorcolumn
set ruler

" タブ表示
set showtabline=2

" ステータスバー表示
set laststatus=2

"------------
" search
"------------
" 検索するときに大文字小文字を区別しない
set ignorecase

" 検索パターンに大文字が含まれる場合は区別する
set smartcase

" 検索した時にハイライト
set hlsearch

" インクリメンタルサーチ
set incsearch

" ESC２回でハイライト解除
nnoremap <ESC><ESC> :noh<CR>

" vimgrep, grep, Ggrepなどで自動的にquickfix-windowを開く
autocmd QuickFixCmdPost *grep* cwindow

"------------
" indent
"------------
filetype plugin indent on
set expandtab
set tabstop=2
set softtabstop=2
set autoindent
set smartindent
set shiftwidth=2
au FileType go setlocal sw=4 ts=4 sts=4 noet

"------------
" key bind
"------------
" xで削除した時はヤンクしない
vnoremap x "_x
nnoremap x "_x

" dで削除した時はヤンクしない
vnoremap d "_d
nnoremap d "_d

" 1 で行頭に移動
nnoremap 1 ^

" 2で行末に移動
nnoremap 2 $

" 9 で前のバッファタブへ
nnoremap <silent> 9 :bprev<CR>

" 0 で次のバッファタブへ
nnoremap <silent> 0 :bnext<CR>

" Option + | でファイル内の文字置換
nnoremap \ :%s/old/new/g<LEFT><LEFT><LEFT><LEFT><LEFT><LEFT><LEFT><LEFT>

" 現在のバッファ削除
nnoremap bd :bd<CR>

" 括弧の補完
" inoremap {<Enter> {}<Left><CR><ESC><S-o>
" inoremap [<Enter> []<Left><CR><ESC><S-o>
" inoremap (<Enter> ()<Left><CR><ESC><S-o>
inoremap { {}<Left>
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap ( ()<ESC>i
inoremap (<Enter> ()<Left><CR><ESC><S-o>

" クオーテーションの補完
inoremap ' ''<LEFT>
inoremap " ""<LEFT>

" visulaモードでインデント調整後に選択範囲を開放しない
vnoremap > >gv
vnoremap < <gv

" 画面分割系
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap ss :<C-u>sp<CR><C-w>j
nnoremap sv :<C-u>vs<CR><C-w>l



"------------
" plugins
"------------

" vim-plug setup
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-git-status.vim'
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'lambdalisue/glyph-palette.vim'
Plug 'yuki-yano/fern-preview.vim'

" lsp
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'mattn/vim-lsp-icons'
Plug 'mattn/vim-goimports'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

Plug 'mhinz/vim-startify'

Plug 'alvan/vim-closetag'


Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Initialize plugin system
call plug#end()

"--------------
" Plugin config
" -------------
" fern design
let g:fern#renderer = 'nerdfont'
augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
  autocmd FileType nerdtree,startify call glyph_palette#apply()
augroup END

nnoremap <silent><C-e> :Fern . -reveal=%<CR>
function! s:fern_settings() abort
  nmap <silent> <buffer> p     <Plug>(fern-action-preview:toggle)
  nmap <silent> <buffer> <C-p> <Plug>(fern-action-preview:auto:toggle)
  nmap <silent> <buffer> <C-d> <Plug>(fern-action-preview:scroll:down:half)
  nmap <silent> <buffer> <C-u> <Plug>(fern-action-preview:scroll:up:half)
endfunction

augroup fern-settings
  autocmd!
  autocmd FileType fern call s:fern_settings()
augroup END
"------------
" lsp setting
"------------
let g:goimports_simplify = 1  " 保存時に`gofmt -s`を実行する

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

"------------
" color scheme
"------------
autocmd ColorScheme * highlight Normal ctermfg=250 ctermbg=236
autocmd ColorScheme * highlight LineNr ctermbg=236
autocmd ColorScheme * highlight SignColumn ctermbg=236
autocmd ColorScheme * highlight GitGutterAdd ctermbg=236
autocmd ColorScheme * highlight CursorColumn ctermbg=237
autocmd ColorScheme * highlight CursorLine ctermbg=237
autocmd ColorScheme * highlight Special ctermfg=202

syntax enable
" solarized options 
set background=dark
let g:solarized_visibility="high"
let g:solarized_contrast="high"
let g:solarized_termcolors=256
colorscheme solarized

"------------
" Design
"------------

" status line
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" }
      \ }

" auto complete
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
