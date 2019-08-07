" init vundle
" :PluginInstall after adding a new
" :PluginClean after deleting
set nocompatible
filetype off
"set rtp+=~/.vim/bundle/vundle
"call vundle#rc()
"
"Plugin 'Raimondi/delimitMate'
"Plugin 'ericcurtin/CurtineIncSw.vim'
"Plugin 'craigemery/vim-autotag'
""Plugin 'Valloric/YouCompleteMe'
""Plugin 'scrooloose/syntastic'

"end vundle

" Some starter commands
set nu
"set relativenumber "too slow :/
set noswapfile
inoremap jj <ESC>
inoremap jJ <ESC>   " let me mess this up sometimes
inoremap :w <ESC>:w
noremap Y y$
nnoremap \ ^
set pastetoggle=<Leader>v
"set path+=src,codegen,generated
nnoremap <Leader>w :%s/\s\+$//e<cr>  " clean trailing whitespace for the file

"clear highlighting after search
noremap <ESC><ESC> :noh<cr><ESC>
noremap K <nop>
noremap C-[ <nop>
noremap C-] <nop>
"cnoremap sh bash  "sh !sh bash
set mouse=a

function! ToggleMouse()
    " check if mouse is enabled
    if &mouse == 'a'
        " disable mouse
        set mouse=
    else
        " enable mouse everywhere
        set mouse=a
    endif
endfunc

nnoremap <Leader>m :call ToggleMouse()<CR>


set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab "tabs to spaces
filetype plugin indent on
set shiftround " use multiples of shiftwidth when using < and >
set cindent

set showmatch " show matching parens
set ignorecase
set smartcase
set smarttab
syntax on

"find what these are
set cino=>4
au FileType * setl fo-=cro
set incsearch " allow using s//new_word after search
set nostartofline

set lazyredraw
set ttyfast
set nocp

" For makefiles
"au BufNewFile,BufRead Makefile set filetype=make
"au BufNewFile,BufRead *.make set filetype=make
"au FileType make set noexpandtab

" For csc2 files
au BufNewFile,BufRead *.csc2 set filetype=csc2
au Filetype csc2 set wrap!

" more general stuff
set so=7 " leave 7 lines when moving screen
set ruler " show row, column

set laststatus=2
set cf

"set isk+=_,$,@,%,#, " these are not word separators
set lz " do not redraw during macors
set diffopt+=iwhite
set wildmenu "allow tabbing to autocomplete
set wildmode=list:longest
set hidden
set backspace=indent,eol,start
"let loaded_matchparen=1
set tabpagemax=25
set scrolloff=3
set timeout timeoutlen=1000 ttimeoutlen=100
set hlsearch
colorscheme desert

"highlight OverLength ctermbg=red ctermfg=white guibg=#592929
"match OverLength /\%81v.*/

"match ErrorMsg '\%>80v.\+'

"set to whatever you like
augroup vimrc_autocmds
    au BufEnter * highlight ColorColumn ctermbg=darkred
    au BufEnter * call matchadd('ColorColumn', '\%81v.', 100) "set column nr
augroup END


"set colorcolumn=80 "color just column 80


"Navigation mapping
"nnoremap ' `
"nnoremap ` '
"nnoremap j gj
"nnoremap k gk
"nnoremap gk k
"nnoremap gj j
"map <C-a> ^
"map <C-e> $

" Tab keyboard mapping
:noremap <C-t> :tabnew<cr>:e<space>

:nmap<C-j> :tabprevious<cr>
:nmap<C-k>  :tabnext<cr>
" If in insert mode, leave insert mode before moving files
imap <C-t>t <ESC>:tabnew<cr>:e<space>
:imap<C-j> <ESC>:tabprevious<cr>
:imap<C-k> <ESC>:tabnext<cr>

" for ctags
"":noremap <Leader>t <C-t>
map <Leader>t :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
set tags=tags;$HOME
set complete-=i "dont search all included files

" For using YouCompleteMe
set nocompatible " already set for vundle
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/ycm_extra_conf.py'
"call pathogen#infect()
"call pathogen#helptags() " Load the help tags for all plugins
"syntax on
"filetype plugin indent on
set encoding=utf-8

"YouCompleteMe
"-----------------------------------
let g:ycm_global_ycm_extra_conf = '~/.vim/ycm_extra_conf.py'
let g:ycm_show_diagnostics_ui = 1
let g:ycm_max_diagnostics_to_display = 1000
let g:ycm_always_populate_location_list = 1
let g:ycm_autoclose_preview_window_after_completion = 1

"this is experimental, these should be default settings!
let g:ycm_auto_trigger = 1
let g:ycm_semantic_triggers =  {
  \   'c' : ['->', '.'],
  \   'objc' : ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
  \             're!\[.*\]\s'],
  \   'ocaml' : ['.', '#'],
  \   'cpp,objcpp' : ['->', '.', '::'],
  \   'perl' : ['->'],
  \   'php' : ['->', '::'],
  \   'cs,java,javascript,typescript,d,python,perl6,scala,vb,elixir,go' : ['.'],
  \   'ruby' : ['.', '::'],
  \   'lua' : ['.', ':'],
  \   'erlang' : [':'],
  \ }
let g:ycm_path_to_python_interpreter="/opt/bb/bin/python"

"diagmode of ycm
"nnoremap <F3> <Esc> :YcmDiags<CR>
"nnoremap <F2> :YcmCompleter FixIt<CR>
"nnoremap <F7> :YcmCompleter GoToDefinition<CR>
"nnoremap <F8> :YcmCompleter GoToDeclaration<CR>

"always show gutter aka sign column, and clear its colour
autocmd BufEnter * sign define dummy
autocmd BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
highlight clear SignColumn

"Only enable ycm for certain types of file
let g:ycm_filetype_whitelist = { 'cpp': 1, 'c': 1, 'python': 1}




" For multiple windows
" set this to something else?
nnoremap t <c-w>
noremap tt <C-w><C-w>
cnoremap vr vertical resize

" Navigation
noremap ff t
noremap FF T

"For Bloomberg
"inoremap JJ // <C-R>=expand("%:t")<CR><CR><CR>#include <sysutil_ident.h><CR>SYSUTIL_IDENT_RCSID(<C-R>=expand("%:t:r  ")<CR>_cpp, "$Id$ $CSID$")<CR><CR>#include <<C-R>=expand("%:t:r")<CR>.h><CR><CR>namespace BloombergLP {<CR><CR><CR><  CR>} // Close BloombergLP<UP><UP>
"inoremap KK  // <C-R>=expand("%:t")<CR><CR>#ifndef INCLUDED_<C-R>=toupper(expand("%:t:r"))<CR><CR>#define INCLUDED_  <C-R>=toupper(expand("%:t:r"))<CR><CR><CR>#ifndef INCLUDED_SYSUTIL_IDENT<CR>#include <sysutil_ident.h><CR>#endif<CR>  SYSUTIL_IDENT_RCSID(<C-R>=expand("%:t:r")<CR>_h, "$Id$ $CSID$")<CR>SYSUTIL_PRAGMA_ONCE<CR><CR>namespace BloombergLP   {<CR><CR><CR><CR>} // Close BloombergLP<CR><CR>#endif<UP><UP><UP><UP>

" For folding
set foldenable
set foldlevelstart=18 " open most folds by defautl"
nnoremap <space> za
let g:ycm_auto_trigger = 1
let g:ycm_semantic_triggers =  {
  \   'c' : ['->', '.'],
  \   'objc' : ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
  \             're!\[.*\]\s'],
  \   'ocaml' : ['.', '#'],
  \   'cpp,objcpp' : ['->', '.', '::'],
  \   'perl' : ['->'],
  \   'php' : ['->', '::'],
  \   'cs,java,javascript,typescript,d,python,perl6,scala,vb,elixir,go' : ['.'],
  \   'ruby' : ['.', '::'],
  \   'lua' : ['.', ':'],
  \   'erlang' : [':'],
  \ }
let g:ycm_path_to_python_interpreter="/opt/bb/bin/python"

"diagmode of ycm
"nnoremap <F3> <Esc> :YcmDiags<CR>
"nnoremap <F2> :YcmCompleter FixIt<CR>
"nnoremap <F7> :YcmCompleter GoToDefinition<CR>
"nnoremap <F8> :YcmCompleter GoToDeclaration<CR>

"always show gutter aka sign column, and clear its colour
autocmd BufEnter * sign define dummy
autocmd BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
highlight clear SignColumn

"Only enable ycm for certain types of file
let g:ycm_filetype_whitelist = { 'cpp': 1, 'c': 1, 'python': 1}




" For multiple windows
" set this to something else?
nnoremap t <c-w>
noremap tt <C-w><C-w>
cnoremap vr vertical resize

" Navigation
noremap ff t
noremap FF T

"For Bloomberg
"inoremap JJ // <C-R>=expand("%:t")<CR><CR><CR>#include <sysutil_ident.h><CR>SYSUTIL_IDENT_RCSID(<C-R>=expand("%:t:r  ")<CR>_cpp, "$Id$ $CSID$")<CR><CR>#include <<C-R>=expand("%:t:r")<CR>.h><CR><CR>namespace BloombergLP {<CR><CR><CR><  CR>} // Close BloombergLP<UP><UP>
"inoremap KK  // <C-R>=expand("%:t")<CR><CR>#ifndef INCLUDED_<C-R>=toupper(expand("%:t:r"))<CR><CR>#define INCLUDED_  <C-R>=toupper(expand("%:t:r"))<CR><CR><CR>#ifndef INCLUDED_SYSUTIL_IDENT<CR>#include <sysutil_ident.h><CR>#endif<CR>  SYSUTIL_IDENT_RCSID(<C-R>=expand("%:t:r")<CR>_h, "$Id$ $CSID$")<CR>SYSUTIL_PRAGMA_ONCE<CR><CR>namespace BloombergLP   {<CR><CR><CR><CR>} // Close BloombergLP<CR><CR>#endif<UP><UP><UP><UP>

" For folding
set foldenable
set foldlevelstart=18 " open most folds by defautl"
nnoremap <space> za
set foldmethod=indent "others are marker, manual, expr, syntax, diff

" Colors
" make comments dark gray
hi Comment ctermfg=darkgray
" make python docstring color like comments
syn region Comment start=/\'\'\'/ end=/\'\'\'/

"custom with leader
let mapleader = "\\"
inoremap <Leader>p import pdb; pdb.set_trace()

" for modline maybe?
set nocompatible
filetype plugin on
set modeline
set modelines=5

"TODO: get this back
" DelimitMate
"let delimitMate_expand_cr = 1
"let delimitMate_expand_space = 1

" little tool for getting the largest bo field for aimom
function! GetLargestId(name)
    return "hi"
    "let max_id = system("grep 'id: ' " + a:name + " | sed -e 's/^.*id: //\' | sort -n | tail -1")
    "echom max_id
    "let new_id = max_id + 1
    "echom new_id
endfunc

"nnoremap <Leader>m :call ToggleMouse()<CR>


nnoremap  <Leader>s :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>
" CurineIncSw " switched out for above
"CurtineIncSw()<CR>

" Syntastic
"let g:syntastic_cpp_compiler_options='
" \ -I/bb/build/Linux-x86_64-32/release/robolibs/prod/lib/dpkgroot/opt/bb/include
" \ -I/bb/build/Linux-x86_64-32/release/robolibs/prod/lib/dpkgroot/opt/bb/include/stlport
" \'


