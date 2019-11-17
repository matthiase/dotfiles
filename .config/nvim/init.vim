call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'scrooloose/nerdcommenter'
Plug 'kien/ctrlp.vim'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'kshenoy/vim-signature'
Plug 'sheerun/vim-polyglot'
Plug 'mattn/emmet-vim'
Plug 'airblade/vim-gitgutter'
Plug 'Yggdroot/indentLine'
Plug 'w0rp/ale'
Plug 'plasticboy/vim-markdown'
Plug 'itchyny/lightline.vim'
Plug 'jacoborus/tender.vim'
call plug#end()

set termguicolors
set showcmd
set autoindent                    " set auto indent
set expandtab                     " use spaces, not tab characters
set ts=2                          " set indent to 2 spaces
set shiftwidth=2 softtabstop=2    " number of spaces per tab
set showmatch                     " show bracket matches
set ignorecase                    " ignore case in search
set hlsearch                      " highlight all search matches
set smartcase                     " pay attention to case when caps are used
set incsearch                     " show search results as I type
set mouse=a                       " enable mouse support
set vb                            " enable visual bell (disable audio bell)
set number                        " display line numbers
set ruler                         " show row and column in footer
set laststatus=2                  " always show status bar
set list listchars=tab:»·,trail:· " show extra space characters
set nofoldenable                  " open all folds by default
set foldmethod=indent             " set fold method
set nowrap                        " disable visible word wrap
set background=dark               " set background color
set shortmess=I                   " disable startup message
set ttyfast                       " enable fast terminal connection
set lazyredraw                    " speed optimization
set history=9999                  " increase history size
set backspace=indent,eol,start    " Allows the backspace to delete indenting
if has('persistent_undo')         " Turn on persistent undo
  set undofile
  set undolevels=1000
  set undoreload=10000
end
set clipboard+=unnamedplus        " send clipboard operations to the '*' register

let mapleader = ","
"map <Leader>\ :NERDTreeToggle<CR>
nnoremap <CR> :noh<CR><CR>

" Turn off search result highlighting
nmap <space><space> :nohlsearch<CR>

" Remove trailing whitespace and retab automatically on save
" autocmd BufWritePre * %s/\s\+$//e
" autocmd BufWritePre :set expandtab<CR> :retab<CR>

syntax on
syntax enable
colorscheme tender

let g:lightline = {
      \ 'colorscheme': 'tenderplus',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

" Buffergator
let g:buffergator_suppress_keymaps = 1
let g:buffergator_viewport_split_policy = "R"
let g:buffergator_autoexpand_on_split = 0
nmap <leader>b? :map <leader>b<cr>
nmap <leader>bb :CtrlPBuffer<cr>
nmap <leader>bl :BuffergatorOpen<cr>
nmap <leader>bm :CtrlPMixed<cr>
nmap <leader>bq :bp <BAR> bd #<cr>
nmap <leader>bs :CtrlPMRU<cr>
nmap <leader>T :enew<cr>
nmap <leader>jj :BuffergatorMruCyclePrev<cr>
nmap <leader>kk :BuffergatorMruCycleNext<cr>

" CtrlP
let g:ctrlp_user_command = {
      \ 'types': {
      \ 1: ['.git', 'cd %s && git ls-files --exclude-standard --others --cached'],
      \ 2: ['.hg', 'hg --cwd %s locate -I .'],
      \ },
      \ 'fallback': 'find %s -type f'
      \ }

" Use nearest .git dir
let g:ctrlp_working_path_mode = 'ra'

" Fugitive
nmap <leader>gb :Gblame<cr>
nmap <leader>gc :Gcommit<cr>
nmap <leader>gd :Gdiff<cr>
nmap <leader>gg :Ggrep
nmap <leader>gl :Glog<cr>
nmap <leader>gp :Git pull<cr>
nmap <leader>gP :Git push<cr>
nmap <leader>gs :Gstatus<cr>
nmap <leader>gw :Gbrowse<cr>
nmap <leader>g? :map <leader>g<cr>

" Emmet
let g:user_emmet_leader_key=','

" NERDTree
map <C-n> :NERDTreeToggle<CR>
nmap <Leader>r :NERDTreeFocus<cr> \| R \| <c-w><c-p> \| :CtrlPClearCache<cr>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeWinPos = "left"
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

" indent guides
let g:indentLine_enabled = 1
let g:indentLine_color_term = 254
let g:indentLine_char = '┆'

" Ale linting
let g:ale_fixers = {
\   'javascript': ['prettier'],
\   'vue': ['prettier'],
\   'css': ['prettier'],
\}
let g:ale_linters_explicit = 1
let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 0
let g:ale_open_list = 0
let g:ale_keep_list_window_open = 0

" Mouse Support
if has('mouse')
  set mouse=a
endif

" disable header folding
let g:vim_markdown_folding_disabled = 1

" do not use conceal feature, the implementation is not so good
let g:vim_markdown_conceal = 0

" disable math tex conceal feature
let g:tex_conceal = ""
let g:vim_markdown_math = 1

" support front matter of various format
let g:vim_markdown_frontmatter = 1  " for YAML format
let g:vim_markdown_toml_frontmatter = 1  " for TOML format
let g:vim_markdown_json_frontmatter = 1  " for JSON format

" Reload files when changed
set autoread
au CursorHold * checktime

" Custom commands
command PrettyJson :%!python -m json.tool

fun! ToggleWhitespace()
    if &list
        set nolist
    else
        set list listchars=tab:»·,trail:·
        set list
    endif
endfun
nmap <leader>ws :call ToggleWhitespace()<cr>

" Toggle signcolumn (Works only on vim >= 8.0)
fun! ToggleSignColumn()
    if !exists("b:signcolumn_on") || b:signcolumn_on
        set scl=no
        let b:signcolumn_on=0
    else
        set scl=auto
        let b:signcolumn_on=1
    endif
endfun
nmap <leader>sc :set number!<CR>:call ToggleSignColumn()<CR>

filetype plugin on
