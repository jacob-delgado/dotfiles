set nocompatible
filetype off

call plug#begin('~/.vim/plugged')

" nnoremap [c   (Jump between hunks)
" nnoremap ]c 
" nnoremap <leader>hp (Preview hunks)
" nnoremap <leader>hs (Stage hunks)
" nnoremap <leader>hs (Undo hunks)
Plug 'airblade/vim-gitgutter'

Plug 'AndrewRadev/splitjoin.vim'
Plug 'bling/vim-airline'
Plug 'fatih/molokai'
Plug 'fatih/vim-go'
Plug 'gregsexton/gitv'
Plug 'jiangmiao/auto-pairs'

" nnoremap <leader>be :BufExplorer
" nnoremap <leader>bt :BufExplorerToggle
" nnoremap <leader>bs :BufExplorerHorizontalSplit
" nnoremap <leader>bv :BufExplorerVerticalSplit
Plug 'jlanzarotta/bufexplorer'

" let g:ctrlp_map = '<c-p>'
Plug 'kien/ctrlp.vim'

" nnoremap <leader>tt :TagbarToggle<CR>
Plug 'majutsushi/tagbar'

" Open Ack and prompt the user
map <leader>a :Ack<space>
Plug 'mileszs/ack.vim'

Plug 'rust-lang/rust.vim'
Plug 'scrooloose/nerdcommenter'

" nerdtree settings
" nnoremap <leader>nf :NERDTreeFind<CR>
" nnoremap <leader>nt :NERDTreeToggle<CR>
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'Shougo/neocomplete.vim'
Plug 'SirVer/ultisnips'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-projectionist'

call plug#end()

filetype on
filetype plugin indent on
let c_space_errors=1
let mapleader=','

set autochdir
set autoindent
set autoread
set autowrite
set background=dark
set backspace=indent,eol,start
set backup
set backupdir=~/.vim/backup
set cindent
set cmdheight=2
let &colorcolumn="80,".join(range(120,999),",")
set completeopt=menu,longest,preview
set cul
set cursorline
set diffopt=filler,iwhite,vertical
set directory=~/.vim/tmp
set encoding=utf-8
set expandtab
set ff=unix
set fileformats=unix
set formatoptions=qrn1
set gdefault
set guicursor+=v:blinkon0
set history=200
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set lazyredraw
set lbr
set magic
set modelines=0
set mouse=a
set nodigraph
set noea
set noerrorbells
set nohidden
set nospell
set novb
set nowrap
set number
"set relativenumber
set report=0
set ruler
set scrolloff=5
set shell=bash
set shiftround
set shiftwidth=4
set showcmd
set showmatch
set showmode
set showtabline=2
set sidescrolloff=5
set smartcase
set smartindent
set smarttab
set softtabstop=4
set statusline=%F%m%r%h%w\ (%{&ff}){%Y}\ [%l,%v][%p%%]
set t_vb=
set tabstop=4
set tags=tags;/
set textwidth=200
set title
set ttyfast
set undodir=~/.vim/undo
set undofile
set undolevels=500
set updatetime=250
set viminfo='20,\"50,:20,/20,%,n~/.viminfo

" Remember info about open buffers on close
set viminfo^=%

set visualbell
set whichwrap+=<,>,h,l
set wildignore=*.o,*~,*.pyc,*.pyo,*.exe,.git\*,.idea\*
set wildmenu
set wildmode=list:longest,full

" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W w !sudo tee % > /dev/null

" Close the current buffer (w/o closing the current window)
nnoremap <leader>bd :Bclose<cr>

" Close all the buffers
map <leader>bda :%bd!<cr>

inoremap <silent> <Down> <C-o>gj
inoremap <silent> <Down> <Esc>gja
inoremap <silent> <Up> <C-o>gk
inoremap <silent> <Up> <Esc>gka
inoremap jj <Esc>

map <leader>dc :q<cr>:diffoff!<cr>
map <leader>do :DiffOrig<cr>
map <leader>rt :retab<cr>
map <leader>sc :setlocal spell!<CR>
map <leader>url :call Browser ()<CR>
map <silent> <leader><space> :noh<CR>
map Q gq

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<CR>`z
nmap <M-k> mz:m-2<CR>`z
vmap <M-j> :m'>+<CR>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<CR>`>my`<mzgv`yo`z

nnoremap # #zz
nnoremap * *zz
nnoremap / /\v
nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>ln :set invnumber<CR>
nnoremap <leader>nw :set invwrap<CR>
nnoremap <leader>rn :set invrelativenumber<CR>
nnoremap <leader>sc :set invspell<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap <silent> j gj
nnoremap <silent> k gk
nnoremap <tab> %
nnoremap JJJJ <Nop>
nnoremap N Nzz
nnoremap g# g#zz
nnoremap g* g*zz
nnoremap n nzz

vnoremap < <gv
vnoremap <tab> %
vnoremap > >gv

if has('syntax')
    syntax on
    " Remember that rxvt-unicode has 88 colors by default; enable this
    " only if you are using the 256-color patch
    if &term == 'rxvt-unicode' || &term == 'xterm'
        set t_Co=256
    endif
endif

augroup vimrcEx
  au!
  autocmd FileType text setlocal textwidth=80
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
augroup END

set guifont=Consolas\ 12

colorscheme wombat256mod
au FileType go let g:rehash256=1
au FileType go let g:molokai_original=1
au FileType go colorscheme molokai

"{{{ Functions

""{{{ Open URL in browser

command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis | wincmd p

function! Browser ()
  let line = getline (".")
  let line = matchstr (line, "http[^   ]*")
  exec "!firefox ".line
endfunction

" gitgutter settings
nnoremap <leader>gg :GitGutterLineHighlightsToggle<cr>
highlight SignColumn guibg=black ctermbg=black
highlight GitGutterDeleteLine guibg=#900000 ctermbg=88
highlight GitGutterAddLine guibg=#005000 ctermbg=22

" tagbar settings
nnoremap <leader>tt :TagbarToggle<CR>

" nerdtree settings
nnoremap <leader>nf :NERDTreeFind<CR>
nnoremap <leader>nt :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.o$', '\.pyc$', '\.exe\~$']

" ctrlp settings
let g:ctrlp_map='<c-p>'

" syntastic settings
" not needed since I run vim-airline
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=1
let g:syntastic_check_on_open=1
let g:syntastic_check_on_wq=0
let g:syntastic_python_checkers=['pylint']
" set passive mode for go due to vim-go plugin
let g:syntastic_mode_map = {
    \ "mode": "active",
    \ "passive_filetypes": ["go"] }

" highlight unwanted trailing whitespace as red
" on buffer entrance/leave as well as insert mode
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" misc highlight settings
highlight Cursor guibg=yellow
highlight ColorColumn ctermbg=236 guibg=#303030
highlight CursorLine guibg=#303030 ctermbg=236
highlight CursorLineNr guibg=blue ctermbg=4
highlight LineNr gui=NONE guibg=#4e4e4e guifg=pink ctermbg=gray ctermfg=red
highlight MatchParen ctermbg=2 guibg=#008000
highlight NonText ctermbg=235 guibg=#262626
"highlight SpecialKey ctermbg=1 guibg=powderblue

" omnicompletion settings
" set completeopt-=preview

" vim-go specific bindings
au FileType go nmap <leader>c <Plug>(go-coverage-toggle)
au FileType go nmap <leader>ds <Plug>(go-def-split)
au FileType go nmap <leader>dt <Plug>(go-def-tab)
au FileType go nmap <leader>dv <Plug>(go-def-vertical)
au FileType go nmap <leader>e <Plug>(go-rename)
au FileType go nmap <leader>ga :GoAlternate<CR>
au FileType go nmap <leader>gb <Plug>(go-doc-browser)
au FileType go nmap <leader>gd <Plug>(go-doc)
au FileType go nmap <leader>gl <Plug>(go-metalinter)
au FileType go nmap <leader>gv <Plug>(go-doc-vertical)
au FileType go nmap <leader>i <Plug>(go-info)
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>s <Plug>(go-implements)
au FileType go nmap <leader>t <Plug>(go-test)

" quickfix list mappings
nnoremap <c-n> :cnext<CR>
nnoremap <c-m> :cprevious<CR>
nnoremap <leader>q :cclose<CR>

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#cmd#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>

let g:go_auto_sameids = 1
let g:go_auto_type_info = 1
let g:go_fmt_command="goimports"
let g:go_highlight_build_constraints=1
let g:go_highlight_fields=1
let g:go_highlight_functions=1
let g:go_highlight_methods=1
let g:go_highlight_operators=1
let g:go_highlight_structs=1
let g:go_highlight_types=1
" compatibility with syntastic recommends all windows be quickfix lists
let g:go_list_type="quickfix"
let g:go_metalinter_autosave=1

" neocomplete settings
" Disable AutoComplPop.
let g:acp_enableAtStartup=0
" Use neocomplete.
let g:neocomplete#enable_at_startup=1
" Use smartcase.
let g:neocomplete#enable_smart_case=1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length=3
let g:neocomplete#lock_buffer_name_pattern='\*ku\*'

" Plug key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  " For no inserting <CR> key.
  return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" <BS>: close popup and delete backward char
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

" Delete trailing white space on save
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.go :call DeleteTrailingWS()
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.sh :call DeleteTrailingWS()

" Open Ack and prompt the user
map <leader>a :Ack<space>

" Switch between the last two files
nnoremap <leader><leader> <C-^>
