set nocompatible
filetype off

call plug#begin('~/.vim/plugged')

" Editing essentials (tpope stack)
Plug 'tpope/vim-commentary'         " gcc / gc{motion} to toggle comments
Plug 'tpope/vim-surround'           " cs'\" / ys{motion}{char} / ds{char}
Plug 'tpope/vim-repeat'             " makes the above '.'-repeatable
Plug 'tpope/vim-sleuth'             " auto-detect indent settings per file
Plug 'tpope/vim-fugitive'           " :Git, :Gdiffsplit, :Gblame, etc.
Plug 'tpope/vim-dispatch'           " async build / test runner
Plug 'tpope/vim-projectionist'

" UI
Plug 'vim-airline/vim-airline'      " statusline
Plug 'jlanzarotta/bufexplorer'      " <leader>be / bt / bs / bv
Plug 'preservim/nerdtree'           " <leader>nt / nf
Plug 'majutsushi/tagbar'            " <leader>tt
Plug 'mbbill/undotree'              " :UndotreeToggle — visualize undo branches

" Fuzzy finder (replaces ctrlp + ack)
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'             " :Files, :Rg, :Buffers, :GFiles?, :History

" Editor integrations
Plug 'editorconfig/editorconfig-vim'
Plug 'christoomey/vim-tmux-navigator'   " <C-h/j/k/l> jumps across vim+tmux
Plug 'airblade/vim-gitgutter'           " gutter diff markers; ]c [c <leader>h{s,p,u}
Plug 'AndrewRadev/splitjoin.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'SirVer/ultisnips'

" Linting / LSP-lite (replaces syntastic)
Plug 'dense-analysis/ale'

" Languages
Plug 'fatih/vim-go'
Plug 'rust-lang/rust.vim'

" Colors
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'fatih/molokai'                " used for go filetype only

call plug#end()

filetype on
filetype plugin indent on
let c_space_errors=1
let mapleader=','

" --- General settings ----------------------------------------------------
set autoindent
set autoread
set autowrite
set background=dark
set backspace=indent,eol,start
set backup
set backupdir=~/.vim/backup
set cindent
set clipboard=unnamed,unnamedplus   " system clipboard on both Mac and Linux
set cmdheight=2
let &colorcolumn="80,".join(range(120,999),",")
set completeopt=menu,menuone,noselect
set cursorline
set diffopt=filler,iwhite,vertical
set directory=~/.vim/tmp
set encoding=utf-8
set expandtab
set fileformats=unix
set formatoptions=qrn1
set gdefault
set guicursor+=v:blinkon0
set hidden                          " allow switching buffers with unsaved changes
set history=200
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set lazyredraw
set linebreak
set magic
set modelines=0
set mouse=a
set noerrorbells
set nospell
set novisualbell
set nowrap
set number
set report=0
set ruler
set scrolloff=5
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
set splitbelow
set splitright
set statusline=%F%m%r%h%w\ (%{&ff}){%Y}\ [%l,%v][%p%%]
set t_vb=
set tabstop=4
set tags=tags;/
set termguicolors                   " true color; pairs with tmux terminal-overrides
set textwidth=200
set title
set ttyfast
set undodir=~/.vim/undo
set undofile
set undolevels=500
set updatetime=250
set viminfo='20,\"50,:20,/20,%,n~/.viminfo
set viminfo^=%
set whichwrap+=<,>,h,l
set wildignore=*.o,*~,*.pyc,*.pyo,*.exe,.git\*,.idea\*
set wildmenu
set wildmode=list:longest,full

" :W sudo saves the file
command! W w !sudo tee % > /dev/null

" --- Buffer management ---------------------------------------------------
nnoremap <leader>bd :Bclose<cr>
map <leader>bda :%bd!<cr>

" --- Insert-mode tweaks --------------------------------------------------
inoremap <silent> <Down> <C-o>gj
inoremap <silent> <Up>   <C-o>gk
inoremap jj <Esc>

" --- Leader maps ---------------------------------------------------------
map <leader>dc :q<cr>:diffoff!<cr>
map <leader>do :DiffOrig<cr>
map <leader>rt :retab<cr>
map <leader>sc :setlocal spell!<CR>
map <leader>url :call Browser()<CR>
map <silent> <leader><space> :noh<CR>
map Q gq

" Switch between the last two files
nnoremap <leader><leader> <C-^>

" Edit / source vimrc quickly
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Toggles
nnoremap <leader>ln :set invnumber<CR>
nnoremap <leader>nw :set invwrap<CR>
nnoremap <leader>rn :set invrelativenumber<CR>

" Tabs
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>tc :tabclose<CR>

" --- Move lines up/down --------------------------------------------------
nmap <M-j> mz:m+<CR>`z
nmap <M-k> mz:m-2<CR>`z
vmap <M-j> :m'>+<CR>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<CR>`>my`<mzgv`yo`z

" --- Search ergonomics ---------------------------------------------------
nnoremap # #zz
nnoremap * *zz
nnoremap g# g#zz
nnoremap g* g*zz
nnoremap n nzz
nnoremap N Nzz
nnoremap / /\v

" --- Window navigation (vim-tmux-navigator wires these to also cross tmux panes)
" The plugin overrides these mappings — defining them here as fallback if it's missing.
nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l

" Visual reselect after indent
vnoremap < <gv
vnoremap > >gv

" Match brackets with <tab> (overrides default % use)
nnoremap <tab> %
vnoremap <tab> %
nnoremap JJJJ <Nop>

" Treat j/k as visual-line movement
nnoremap <silent> j gj
nnoremap <silent> k gk

if has('syntax')
    syntax on
endif

augroup vimrcEx
  au!
  autocmd FileType text setlocal textwidth=80
  " Restore cursor position on file reopen
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
augroup END

" --- Colors --------------------------------------------------------------
colorscheme dracula
au FileType go let g:rehash256=1
au FileType go let g:molokai_original=1
au FileType go colorscheme molokai

" --- Functions and commands ---------------------------------------------
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis | wincmd p

" Open the URL under the cursor in the system's default browser
function! Browser()
  let line = matchstr(getline('.'), 'http[s]\?:\/\/[^ \t]*')
  if empty(line) | return | endif
  if has('mac')
    silent exec "!open '" . line . "'"
  elseif executable('xdg-open')
    silent exec "!xdg-open '" . line . "'"
  endif
  redraw!
endfunction

" --- Plugin: vim-gitgutter -----------------------------------------------
nnoremap <leader>gg :GitGutterLineHighlightsToggle<cr>
highlight SignColumn          guibg=black   ctermbg=black
highlight GitGutterDeleteLine guibg=#900000 ctermbg=88
highlight GitGutterAddLine    guibg=#005000 ctermbg=22

" --- Plugin: tagbar ------------------------------------------------------
nnoremap <leader>tt :TagbarToggle<CR>

" --- Plugin: NERDTree ----------------------------------------------------
nnoremap <leader>nf :NERDTreeFind<CR>
nnoremap <leader>nt :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.o$', '\.pyc$', '\.exe\~$']

" --- Plugin: fzf.vim -----------------------------------------------------
nnoremap <C-p>     :Files<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>a :Rg<space>
nnoremap <leader>h :History<CR>

" --- Plugin: ALE (replaces syntastic) -----------------------------------
" Vim-go owns Go diagnostics, so disable ALE there.
let g:ale_linters_explicit = 1
let g:ale_linters = {
\ 'python': ['pylint'],
\ 'sh':     ['shellcheck'],
\ 'yaml':   ['yamllint'],
\}
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_save = 1
let g:airline#extensions#ale#enabled = 1

" --- Plugin: undotree ----------------------------------------------------
nnoremap <leader>u :UndotreeToggle<CR>

" --- Highlight trailing whitespace --------------------------------------
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" --- Misc highlight settings --------------------------------------------
highlight Cursor       guibg=yellow
highlight ColorColumn  ctermbg=236 guibg=#303030
highlight CursorLine   guibg=#303030 ctermbg=236
highlight CursorLineNr guibg=blue   ctermbg=4
highlight LineNr       gui=NONE guibg=#4e4e4e guifg=pink ctermbg=gray ctermfg=red
highlight MatchParen   ctermbg=2   guibg=#008000
highlight NonText      ctermbg=235 guibg=#262626

" --- vim-go --------------------------------------------------------------
au FileType go nmap <leader>c  <Plug>(go-coverage-toggle)
au FileType go nmap <leader>ds <Plug>(go-def-split)
au FileType go nmap <leader>dt <Plug>(go-def-tab)
au FileType go nmap <leader>dv <Plug>(go-def-vertical)
au FileType go nmap <leader>e  <Plug>(go-rename)
au FileType go nmap <leader>ga :GoAlternate<CR>
au FileType go nmap <leader>gb <Plug>(go-doc-browser)
au FileType go nmap <leader>gd <Plug>(go-doc)
au FileType go nmap <leader>gl <Plug>(go-metalinter)
au FileType go nmap <leader>gv <Plug>(go-doc-vertical)
au FileType go nmap <leader>i  <Plug>(go-info)
au FileType go nmap <leader>r  <Plug>(go-run)
au FileType go nmap <leader>s  <Plug>(go-implements)
au FileType go nmap <leader>t  <Plug>(go-test)

" Quickfix navigation
nnoremap <C-n>     :cnext<CR>
nnoremap <C-m>     :cprevious<CR>
nnoremap <leader>q :cclose<CR>

" :GoBuild or :GoTestCompile based on the file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#cmd#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction
autocmd FileType go nmap <leader>gb :<C-u>call <SID>build_go_files()<CR>

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
let g:go_list_type="quickfix"
let g:go_metalinter_autosave=1

" --- Delete trailing whitespace on save ---------------------------------
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.go :call DeleteTrailingWS()
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.sh :call DeleteTrailingWS()
