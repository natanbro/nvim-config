" Python venvs ------------------------------------------------------------{{{

  let g:python_host_prog = $HOME.'/.config/nvim/pyenv2/bin/python'
  let g:python3_host_prog = $HOME.'/.config/nvim/pyenv3/bin/python'
"}}}

" Setup Vim-Plug ----------------------------------------------------------{{{
  call plug#begin('~/.local/share/nvim/plugged')

" aux
  Plug 'Shougo/vimproc.vim', {'do' : 'make'}
  Plug 'xolox/vim-misc'
  Plug 'embear/vim-localvimrc'

" syntax
  Plug 'sheerun/vim-polyglot'
  Plug 'benekastah/neomake'
  Plug 'Chiel92/vim-autoformat'
  Plug 'rust-lang/rust.vim'

" buffer management
  Plug 'mhinz/vim-sayonara'

" color
  Plug 'mhartington/oceanic-next'
  Plug 'flazz/vim-colorschemes'
  Plug 'felixhummel/setcolors.vim'

" git
  Plug 'tpope/vim-fugitive'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'airblade/vim-gitgutter'

" decorate
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

" autocomplete
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'zchee/deoplete-jedi' " python
  Plug 'xolox/vim-lua-ftplugin' " lua
  Plug 'fatih/vim-go' " go
  Plug 'zchee/deoplete-go', {'do': 'make'}
  Plug 'Valloric/YouCompleteMe', {'do': './install.py --all'}

" snippets
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'

" IDE
  Plug 'davidhalter/jedi-vim' " python
  Plug 'junegunn/fzf'
  Plug 'autozimu/LanguageClient-neovim'
  Plug 'itchyny/vim-cursorword' " highlight word under cursor
  Plug 'scrooloose/nerdtree'
  Plug 'idanarye/vim-vebugger'
  Plug 'powerman/vim-plugin-viewdoc' " Doc integration
  Plug 'majutsushi/tagbar'

" movement
  Plug 'tpope/vim-surround'
  Plug 'ficoos/plumb.vim'

" denite
  Plug 'Shougo/denite.nvim'
  Plug 'nixprime/cpsm'

" config
  Plug 'editorconfig/editorconfig-vim'

" finish set up
  call plug#end()
  filetype plugin indent on

"}}}

" Disable Arrow keys in Escape mode ---------------------------------------{{{
  "map <up> <nop>
  "map <down> <nop>
  "map <left> <nop>
  "map <right> <nop>

"}}}

" Python development ------------------------------------------------------{{{

  let g:neomake_python_enabled_makers = ['flake8']
  call neomake#configure#automake('nw', 750)
  " we use deoplete-jedi
  let g:jedi#completions_enabled = 0
  " autocmd BufWinEnter '__doc__' setlocal bufhidden=delete
  let g:jedi#goto_command = "<leader>d"
  let g:jedi#goto_assignments_command = "<leader>g"
  let g:jedi#goto_definitions_command = ""
  let g:jedi#documentation_command = "<leader>?"
  let g:jedi#usages_command = "<leader>n"
  let g:jedi#completions_command = "<C-Space>"
  let g:jedi#rename_command = "<leader>r"

"}}}

" C/C++ Development -------------------------------------------------------{{{
  let g:neomake_c_enabled_makers = ['clang']
  let linter = neomake#makers#ft#c#clang()
  function linter.fn(jobinfo) abort
    let maker = copy(self)
    if filereadable('.clang')
      let maker.args += split(join(readfile('.clang'), "\n"))
    endif
    return maker
  endfunction

  let g:neomake_c_clang_maker = linter
"}}}

" General -----------------------------------------------------------------{{{

" colors
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=0
  set colorcolumn=79
  "let loaded_matchparen = 1

" search
  set hlsearch
  set smartcase
  set incsearch

  if maparg('<C-L>', 'n') ==# ''
    nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
  endif

" line numbering
  set number
  set cursorline
"}}}

" Denite ------------------------------------------------------------------{{{

  call denite#custom#option('default', 'prompt', '»')
  call denite#custom#source(
        \ 'default', 'matchers', ['matcher_cpsm'])

  " Change mappings.
  call denite#custom#map(
  \ 'insert',
  \ '<down>',
  \ '<denite:move_to_next_line>',
  \ 'noremap'
  \)
  call denite#custom#map(
  \ 'insert',
  \ '<up>',
  \ '<denite:move_to_previous_line>',
  \ 'noremap'
  \)

  nnoremap <silent> <c-p> :Denite -auto-resize -direction=botright file_rec<CR>
  nnoremap <silent> <c-j> :Denite -auto-resize -direction=botright location_list<CR>
  nnoremap <silent> <a-p> :DeniteCursorWord -auto-resize -direction=botright grep<CR>
  nnoremap <silent> <a-s-p> :Denite -auto-resize -direction=botright grep<CR>
  nnoremap <silent> <leader>u :PlugUpdate<CR>
  call denite#custom#var('file_rec', 'command',
        \['ag',
        \'--follow',
        \'--nocolor',
        \'--nogroup',
        \'-g', ''])
"}}}

" Vim format --------------------------------------------------------------{{{

  noremap <silent> <leader>f :Autoformat<CR>
"}}}

" UltiSnips ---------------------------------------------------------------{{{
  let g:UltiSnipsExpandTrigger="<tab>"
  let g:UltiSnipsJumpForwardTrigger="<tab>"
  let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
"}}}

" Depolete ----------------------------------------------------------------{{{

  set completeopt="menuone,longest,noinsert"
  let g:deoplete#enable_at_startup = 1
  let g:deoplete#auto_completion_start_length = 1
  let g:deoplete#enable_smart_case = 1
  " set omni complete
  if !exists('g:deoplete#omni#input_patterns')
    let g:deoplete#omni#input_patterns = {}
  endif
  call deoplete#custom#set('ultisnips', 'matchers', ['matcher_fuzzy'])

  " Close the documentation window when completion is done
  autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

  " map ctrl+space for complete
  inoremap <silent><expr> <c-space>
           \ pumvisible() ? "<C-n>" :
           \ deoplete#mappings#manual_complete()
  " lua
  let g:lua_check_syntax = 0
  let g:lua_complete_omni = 1
  let g:lua_complete_dynamic = 0
  let g:lua_define_completion_mappings = 0

  if !exists('g:deoplete#sources')
    let g:deoplete#sources={}
  endif
  let g:deoplete#sources._=['buffer', 'file', 'ultisnips']
  let g:deoplete#sources.python=['buffer', 'file', 'ultisnips', 'jedi']
  let g:deoplete#sources.rust=['ultisnips', 'LanguageClient']
  let g:deoplete#sources.cpp=['ultisnips', 'clang']
  let g:deoplete#sources.c=['ultisnips', 'clang']
  let g:deoplete#sources.go=['ultisnips', 'go']
  let g:deoplete#sources#clang#libclang_path='/usr/lib64/libclang.so'
  let g:deoplete#sources#clang#clang_header='/usr/lib64/clang/'

  if !exists('g:deoplete#omni#functions')
    let g:deoplete#omni#functions = {}
  endif
  let g:deoplete#omni#functions.lua = 'xolox#lua#omnifunc'
"}}}

" Theme -------------------------------------------------------------------{{{

  syntax on
  "let g:gruvbox_contrast_dark = "hard"
  set background=dark
  colorscheme jellybeans
  highlight SpecialKey ctermfg=darkgrey guibg=none gui=NONE
"}}}

" IDE ---------------------------------------------------------------------{{{
  nmap <f6> :wa<bar>make<CR>
  nmap <f5> :enew<CR>:call termopen(runprg, {'name': '[execution]'})<CR>
"}}}

" vim-airline -------------------------------------------------------------{{{

  let g:airline#extensions#tagbar#enabled = 1
  let g:airline#extensions#tabline#enabled = 1
  set hidden
  let g:airline#extensions#tabline#fnamemod = ':t'
  let g:airline#extensions#tabline#show_tab_nr = 1
  let g:airline#extensions#tabline#buffer_idx_mode = 1
  let g:airline_left_sep = ''
  let g:airline_left_alt_sep = ''
  let g:airline_right_sep = ''
  let g:airline_right_alt_sep = ''
  let g:airline_powerline_fonts = 0
  let g:airline_theme='jellybeans'

  tmap <esc><esc> <c-\><c-n>
  nmap <a-right> :bnext<CR>
  nmap <a-left> :bprevious<CR>
  tmap <a-right> <C-\><C-n>:bprevious<CR>
  tmap <a-left> <C-\><C-n>:bprevious<CR>
  nmap <a-l> :bnext<CR>
  nmap <a-h> :bprevious<CR>
  tmap <a-l> <C-\><C-n>:bprevious<CR>
  tmap <a-h> <C-\><C-n>:bprevious<CR>
  nmap <leader>q :Sayonara<CR>
  nmap <leader>c :bp<bar>sp<bar>bn<bar>bd<CR>
  nmap <leader>C :bp<bar>sp<bar>bn<bar>bd!<CR>
  cnoreabbrev <expr> q getcmdtype() == ":" && getcmdline() == 'q' ? 'Sayonara' : 'q'
  tmap <leader>1  <C-\><C-n><Plug>AirlineSelectTab1
  tmap <leader>2  <C-\><C-n><Plug>AirlineSelectTab2
  tmap <leader>3  <C-\><C-n><Plug>AirlineSelectTab3
  tmap <leader>4  <C-\><C-n><Plug>AirlineSelectTab4
  tmap <leader>5  <C-\><C-n><Plug>AirlineSelectTab5
  tmap <leader>6  <C-\><C-n><Plug>AirlineSelectTab6
  tmap <leader>7  <C-\><C-n><Plug>AirlineSelectTab7
  tmap <leader>8  <C-\><C-n><Plug>AirlineSelectTab8
  tmap <leader>9  <C-\><C-n><Plug>AirlineSelectTab9
  nmap <leader>1 <Plug>AirlineSelectTab1
  nmap <leader>2 <Plug>AirlineSelectTab2
  nmap <leader>3 <Plug>AirlineSelectTab3
  nmap <leader>4 <Plug>AirlineSelectTab4
  nmap <leader>5 <Plug>AirlineSelectTab5
  nmap <leader>6 <Plug>AirlineSelectTab6
  nmap <leader>7 <Plug>AirlineSelectTab7
  nmap <leader>8 <Plug>AirlineSelectTab8
  nmap <leader>9 <Plug>AirlineSelectTab9
"}}}

" nerdtree ----------------------------------------------------------------{{{
  nmap <leader>o :TagbarToggle<CR>

"}}}

" nerdtree ----------------------------------------------------------------{{{
  function IsNerdTreeEnabled()
    return exists('t:NERDTreeBufName') && bufwinnr(t:NERDTreeBufName) != -1
  endfunction

  function NERDTreeFindToggle()
    if IsNerdTreeEnabled()
      :NERDTreeClose
    else
      :NERDTreeFind
    endif
  endfunction

  nnoremap <silent> <C-\> :call NERDTreeFindToggle()<CR>

" rust --------------------------------------------------------------------{{{

  set hidden
  let g:neomake_rust_enabled_makers = []
  autocmd BufWritePost *.rs Neomake! cargo
  let g:racer_cmd = $HOME."/.cargo/bin/racer"
  let g:LanguageClient_serverCommands = {
    \ 'rust': ['cargo', 'run', '--release', '--manifest-path='.$HOME.'/.config/nvim/rust/rls/Cargo.toml'],
    \ }


  nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
  nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
  nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
"}}}

" neomake -----------------------------------------------------------------{{{

  autocmd! BufWritePost * Neomake
  let g:neomake_verbose = 0
"}}}

" keyboard short-cuts -----------------------------------------------------{{{

  nmap <leader>t :term<cr>
  nmap <silent> <c-s-up> :call feedkeys( line('.')==1 ? '' : 'ddkP' )<CR>
  nmap <c-s-down> ddp
  nmap <silent> <c-s-k> :call feedkeys( line('.')==1 ? '' : 'ddkP' )<CR>
  nmap <c-s-j> ddp
  nmap <c-s> :w<CR>
  vmap <leader>y "+y
"}}}

" extra whitespace --------------------------------------------------------{{{

  :highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
  :au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  :au InsertLeave * match ExtraWhitespace /\s\+$/
  :set listchars=tab:▸\ ,trail:·
  :set list

"}}}

" cscope ------------------------------------------------------------------{{{

 if has("cscope")
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
     cs add cscope.out
     " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
     cs add $CSCOPE_DB
   endif
  endif

  nmap <leader>] :cs find s <C-R>=expand("<cword>")<CR><CR>
  nmap <leader>d <c-w>}
"}}}
" viewdoc -------------------------------------------------------------------{{{
  let g:no_plugin_maps = 1
  let g:viewdoc_open='new'
  let g:viewdoc_only=1
  let g:viewdoc_openempty=0
  nmap <leader>D :doc! <cword><CR>
  let g:viewdoc_godoc_cmd='go doc'
"

" plumb -------------------------------------------------------------------{{{

  nmap <leader>p "zyy:call plumb#exec('<c-r>z') <CR>
  vmap <leader>p "zy:call plumb#exec(@z) <CR>
"}}}

" terminal ----------------------------------------------------------------{{{

  " when in built-in terminal open in current vim
  let $EDITOR="nvim_open"
"}}}

" ag ----------------------------------------------------------------------{{{
  set grepprg=ag\ --vimgrep
"}}}

" syonara -----------------------------------------------------------------{{{
    let g:sayonara_filetypes = {
        \ 'nerdtree': 'NERDTreeClose',
        \ }
"}}}

" lvimrc ------------------------------------------------------------------{{{

  let g:localvimrc_whitelist=$HOME.'/[Pp]rojects/.*'
"}}}

" cscope ------------------------------------------------------------------{{{

  function! RefreshCScope()
    if filereadable(".cscope")
      :silent exec "!./.cscope"
      :cscope reset
    endif
  endfunction

  autocmd! BufWritePost * call RefreshCScope()

"}}}

" vim: set tabstop=2 shiftwidth=2 expandtab:
