" Python venvs ------------------------------------------------------------{{{

  let g:python_host_prog = $HOME.'/.config/nvim/pyenv2/bin/python'
  let g:python3_host_prog = $HOME.'/.config/nvim/pyenv3/bin/python'
"}}}

" Setup NeoBundle  --------------------------------------------------------{{{

  if (!isdirectory(expand("$HOME/.config/nvim/repos/github.com/Shougo/dein.vim")))
    call system(expand("mkdir -p $HOME/.config/nvim/repos/github.com"))
    call system(expand("git clone https://github.com/Shougo/dein.vim $HOME/.config/nvim/repos/github.com/Shougo/dein.vim"))
  endif

  set runtimepath+=~/.config/nvim/repos/github.com/Shougo/dein.vim/
  call dein#begin(expand('~/.config/nvim'))

  call dein#add('Shougo/dein.vim')

" aux
  call dein#add('Shougo/vimproc.vim', {'build' : 'make'})
  call dein#add('xolox/vim-misc')

" syntax
  call dein#add('sheerun/vim-polyglot')
  call dein#add('benekastah/neomake')
  call dein#add('Chiel92/vim-autoformat')

" buffer management
  call dein#add('mhinz/vim-sayonara')

" color
  call dein#add('mhartington/oceanic-next')
  call dein#add('flazz/vim-colorschemes')
  call dein#add('felixhummel/setcolors.vim')

" git
  call dein#add('tpope/vim-fugitive')
  call dein#add('Xuyuanp/nerdtree-git-plugin')

" decorate
  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes')

" autocomplete
  call dein#add('Shougo/deoplete.nvim')
  call dein#add('zchee/deoplete-jedi') " python
  call dein#add('racer-rust/vim-racer') " rust
  call dein#add('xolox/vim-lua-ftplugin') " lua

" snippets
  call dein#add('SirVer/ultisnips')
  call dein#add('honza/vim-snippets')

" IDE
  call dein#add('davidhalter/jedi-vim') " python

" movement
  call dein#add('tpope/vim-surround')
  call dein#add('ficoos/plumb.vim')

" denite
  call dein#add('Shougo/denite.nvim')

" config
  call dein#add('editorconfig/editorconfig-vim')

" finish set up
  if dein#check_install()
    call dein#install()
    let pluginsExist=1
  endif

  call dein#end()
  filetype plugin indent on

"}}}

" Python development ------------------------------------------------------{{{

  let g:neomake_python_enabled_makers = ['flake8']
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
  let g:neomake_c_enabled_makers = ['clangcheck']
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
  nnoremap <silent> <a-p> :Denite -auto-resize -direction=botright grep<CR>
  nnoremap <silent> <leader>u :call dein#update()<CR>
  call denite#custom#var('file_rec', 'command',
        \['ag',
        \'--follow',
        \'--nocolor',
        \'--nogroup',
        \'--hidden',
        \'-g', '',
        \'--ignore', '.git',
        \'--ignore', '*.png',
        \'--ignore', 'lib',
        \'--ignore-dir', 'node_modules',
        \'--ignore-dir', 'bower_components',
        \'--ignore-dir', 'tmp',
        \])
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
  inoremap <silent><expr> <tab> pumvisible() ? '<down><return>' : "\t"

  " map ctrl+space for complete
  inoremap <silent><expr> <c-space>
           \ pumvisible() ? "<C-n>" :
           \ deoplete#mappings#manual_complete()
  " lua
  let g:lua_check_syntax = 0
	let g:lua_complete_omni = 1
	let g:lua_complete_dynamic = 0
	let g:lua_define_completion_mappings = 0

  let g:deoplete#sources={}
  let g:deoplete#sources._=['buffer', 'file', 'ultisnips']

  if !exists('g:deoplete#omni#functions')
    let g:deoplete#omni#functions = {}
  endif
	let g:deoplete#omni#functions.lua = 'xolox#lua#omnifunc'
"}}}

" Theme -------------------------------------------------------------------{{{

  syntax on
  let g:gruvbox_contrast_dark = "hard"
  set background=dark
  colorscheme gruvbox
  highlight CursorLine guifg=none guibg=none gui=NONE
"}}}

" vim-airline -------------------------------------------------------------{{{

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
  let g:airline_theme='ubaryd'

  tmap <leader>/ <c-\><c-n>
  nmap <a-right> :bnext<CR>
  nmap <a-left> :bprevious<CR>
  tmap <a-right> <C-\><C-n>:bprevious<CR>
  tmap <a-left> <C-\><C-n>:bprevious<CR>
  nmap <leader>q :Sayonara<CR>
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

" vimfiler ----------------------------------------------------------------{{{

  :let g:vimfiler_as_default_explorer = 1

  map <C-\> :VimFiler -project -explorer<CR>

" racer -------------------------------------------------------------------{{{

  set hidden
  let g:racer_cmd = $HOME."/.cargo/bin/racer"
"}}}

" neomake -----------------------------------------------------------------{{{

  autocmd! BufWritePost * Neomake
  let g:neomake_verbose = 0
"}}}

" keyboard short-cuts -----------------------------------------------------{{{

  nmap <leader>t :term<cr>
  nmap <silent> <c-s-up> :call feedkeys( line('.')==1 ? '' : 'ddkP' )<CR>
  nmap <c-s-down> ddp
  nmap <c-s> :w<CR>
  vmap <leader>y "+y
"}}}

" extra whitespace --------------------------------------------------------{{{

  :highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
  :au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  :au InsertLeave * match ExtraWhitespace /\s\+$/

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
"}}}

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

" must be last
" localconfig -------------------------------------------------------------{{{
  let lvimrc_path=".lvimrc"
  if filereadable(expand(lvimrc_path))
    exec "source " . lvimrc_path
  endif
"}}}

" vim: set tabstop=2 shiftwidth=2 expandtab:
