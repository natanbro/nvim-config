" Python venvs --------------------------------------------------------------{{{

  let g:python_host_prog = $HOME.'/.config/nvim/pyenv2/bin/python'
  let g:python3_host_prog = $HOME.'/.config/nvim/pyenv3/bin/python'
"}}}

" Setup NeoBundle  ----------------------------------------------------------{{{

  if (!isdirectory(expand("$HOME/.config/nvim/repos/github.com/Shougo/dein.vim")))
    call system(expand("mkdir -p $HOME/.config/nvim/repos/github.com"))
    call system(expand("git clone https://github.com/Shougo/dein.vim $HOME/.config/nvim/repos/github.com/Shougo/dein.vim"))
  endif

  set runtimepath+=~/.config/nvim/repos/github.com/Shougo/dein.vim/
  call dein#begin(expand('~/.config/nvim'))

  call dein#add('Shougo/dein.vim')

" syntax
  call dein#add('sheerun/vim-polyglot')
  call dein#add('benekastah/neomake')
  call dein#add('Chiel92/vim-autoformat')

" color
  call dein#add('mhartington/oceanic-next')

" git
  call dein#add('tpope/vim-fugitive')
  call dein#add('Xuyuanp/nerdtree-git-plugin')

" traverse
  call dein#add('scrooloose/nerdtree')

" decorate
  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes')

" autocomplete
  call dein#add('Shougo/deoplete.nvim')
  call dein#add('zchee/deoplete-jedi') " python


" unite
  call dein#add('Shougo/unite.vim')
  call dein#add('Shougo/unite-outline')
  call dein#add('ujihisa/unite-colorscheme')
  call dein#add('osyo-manga/unite-quickfix')

" finish set up
  if dein#check_install()
    call dein#install()
    let pluginsExist=1
  endif

  call dein#end()
  filetype plugin indent on

"}}}

" Python development --------------------------------------------------------{{{

  let g:neomake_python_enabled_makers = ['flake8']
"}}}

" General -------------------------------------------------------------------{{{

" colors
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=0
  set colorcolumn=79

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

" Unite ---------------------------------------------------------------------{{{

  let g:unite_data_directory='~/.config/nvim/cache/unite'
  let g:unite_prompt='» '

  autocmd FileType unite nmap <esc> <Plug>(unite_exit)

  nnoremap <silent> <c-p> :Unite -auto-resize -start-insert -direction=botright file_rec/neovim<CR>
  nnoremap <silent> <c-j> :Unite -auto-resize -start-insert -direction=botright location_list<CR>
  nnoremap <silent> <leader>u :call dein#update()<CR>
  let g:unite_source_rec_async_command =['ag', '--follow', '--nocolor', '--nogroup','--hidden', '-g', '', '--ignore', '.git', '--ignore', '*.png', '--ignore', 'lib']
"}}}

" Vim format ----------------------------------------------------------------{{{

  noremap <silent> <leader>f :Autoformat<CR>
"}}}

" Depolete ------------------------------------------------------------------{{{

  let g:deoplete#enable_at_startup = 1
  let g:deoplete#auto_completion_start_length = 1
  let g:deoplete#enable_smart_case = 1
  " set omni complete
  if !exists('g:deoplete#omni#input_patterns')
    let g:deoplete#omni#input_patterns = {} 
  endif

  " Close the documentation window when completion is done
  autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

  " map ctrl+space for complete
  inoremap <silent><expr> <c-space>
          \ pumvisible() ? "\<C-n>" :
	  \ deoplete#mappings#manual_complete()
" Theme ---------------------------------------------------------------------{{{

  syntax on
  colorscheme OceanicNext
  set background=dark
" }}}

" vim-airline ---------------------------------------------------------------{{{

  let g:airline#extensions#tabline#enabled = 1
  set hidden
  let g:airline#extensions#tabline#fnamemod = ':t'
  let g:airline#extensions#tabline#show_tab_nr = 1
  let g:airline#extensions#tabline#buffer_idx_mode = 1
  let g:airline_powerline_fonts = 0
  let g:airline_theme='oceanicnext'

  nmap <a-right> :bnext<CR>
  nmap <a-left> :bprevious<CR>
  nmap <leader>q :bdelete<CR>

"}}}

" NERDTree ------------------------------------------------------------------{{{

  map <C-\> :NERDTreeToggle<CR>
  autocmd StdinReadPre * let s:std_in=1
  " autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
  let NERDTreeShowHidden=1
  let g:NERDTreeWinSize=45
  let g:NERDTreeAutoDeleteBuffer=1
  " NERDTress File highlighting
  function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
  exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
  exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
  endfunction

  call NERDTreeHighlightFile('jade', 'green', 'none', 'green', 'none')
  call NERDTreeHighlightFile('md', 'blue', 'none', '#6699CC', 'none')
  call NERDTreeHighlightFile('config', 'yellow', 'none', '#d8a235', 'none')
  call NERDTreeHighlightFile('conf', 'yellow', 'none', '#d8a235', 'none')
  call NERDTreeHighlightFile('json', 'green', 'none', '#d8a235', 'none')
  call NERDTreeHighlightFile('python', 'green', 'none', '#d8a235', 'none')
  call NERDTreeHighlightFile('html', 'yellow', 'none', '#d8a235', 'none')
  call NERDTreeHighlightFile('css', 'cyan', 'none', '#5486C0', 'none')
  call NERDTreeHighlightFile('scss', 'cyan', 'none', '#5486C0', 'none')
  call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', 'none')
  call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', 'none')
  call NERDTreeHighlightFile('ts', 'Blue', 'none', '#6699cc', 'none')
  call NERDTreeHighlightFile('ds_store', 'Gray', 'none', '#686868', 'none')
  call NERDTreeHighlightFile('gitconfig', 'black', 'none', '#686868', 'none')
  call NERDTreeHighlightFile('gitignore', 'Gray', 'none', '#7F7F7F', 'none')
"}}}

" neomake -------------------------------------------------------------------{{{

  autocmd! BufWritePost * Neomake
  let g:neomake_verbose = 0
"}}}

" keyboard short-cuts -------------------------------------------------------{{{
  nmap <leader>t :term<cr>
"}}}
