" init vundle and plugin code
source $HOME/dotfiles/.vim.plugins


" Some starter commands
set nu  " having this set will set current line to be line number instead of 0
set relativenumber "if things get slow, try toggling this
set noswapfile  " no backup files

" let me escape basically however i want
"inoremap jj <ESC>
"inoremap jJ <ESC>
"inoremap jk <ESC>

" save out of insert mode
inoremap :w <ESC>:w
noremap Y y$

" map leader key to \ properly
let mapleader="\\"
"set pastetoggle=<Leader>v " this doesnt really work right
"set path+=src,codegen,generated


"clear highlighting after search
noremap <ESC><ESC> :noh<cr><ESC>
noremap K <nop>
noremap C-[ <nop>
noremap C-] <nop>
"cnoremap sh bash  "sh !sh bash


set autochdir " change to current directory within vim when opening a file
cnoremap cdf cd %:h   " use cdf to move to current directory.

" mouse stuff
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

" stuff about tabbing
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab "tabs to spaces
filetype plugin indent on
set shiftround " use multiples of shiftwidth when using < and >
set cindent
set cinoptions=>1s "tab 1x shiftwidth on newline"

set showmatch " show matching parens
set ignorecase
set smartcase
set smarttab
syntax on

"find what these are
au FileType * setl fo-=cro
set incsearch " allow using s//new_word after search
set nostartofline

set lazyredraw
set ttyfast
set nocompatible " stuff with vi compatibility. not exactly sure what this does

" For makefiles
"au BufNewFile,BufRead Makefile set filetype=make
"au BufNewFile,BufRead *.make set filetype=make
"au FileType make set noexpandtab

" set aurora files to python
au BufNewFile,BufRead *.aurora set filetype=python

" For csc2 files
au BufNewFile,BufRead *.csc2 set filetype=csc2
au Filetype csc2 set wrap!


" more general stuff
set laststatus=2
set cf  " something about error files"
"set isk+=_,$,@,%,#, " these are not word separators
set ruler " show row, column
set lazyredraw " do not redraw during macros
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
set statusline=%F%h%m  " show full path in status bar, help buffer, then modfiied"

"highlight OverLength ctermbg=red ctermfg=white guibg=#592929
"match OverLength /\%81v.*/

"match ErrorMsg '\%>80v.\+'

"set to whatever you like
augroup vimrc_autocmds
    au BufEnter * highlight ColorColumn ctermbg=darkred
    au BufEnter * call matchadd('ColorColumn', '\%121v.', 100) "set column nr
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
:noremap <C-t> :tabnew<cr>:FZF $DATA_REPO<cr>
:noremap <C-e> :tabnew<cr>:e<space>
:nmap<C-j> :tabprevious<cr>
:nmap<C-k> :tabnext<cr>

" If in insert mode, leave insert mode before moving files
imap <C-t> <ESC>:tabnew<cr>:FZF $DATA_REPO<cr>
imap <C-e> <ESC>:tabnew<cr>:e<space>
:imap<C-j> <ESC>:tabprevious<cr>cr
:imap<C-k> <ESC>:tabnext<cr>

" for ctags
"":noremap <Leader>t <C-t>
map <Leader>t :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
" set tags=tags;$HOME
" set complete-=i "dont search all included files

"call pathogen#infect()
"call pathogen#helptags() " Load the help tags for all plugins
"syntax on
"filetype plugin indent on
set encoding=utf-8


" python with virtualenv support
" py << EOF
" import os
" import sys
" if 'VIRTUAL_ENV' in os.environ:
"     project_base_dir = os.environ['VIRTUAL_ENV']
"     activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
"     execfile(activate_this, dict(__file__=activate_this))
" EOF


" For multiple windows touse t
" set this to something else?
"nnoremap t <c-w>
"noremap tt <C-w><C-w>
"noremap ff t
"noremap FF T
cnoremap vr vertical resize

" Navigation

" For folding
"set foldenable
"set foldlevelstart=18 " open most folds by defautl"
"nnoremap <space> za
"set foldmethod=indent "others are marker, manual, expr, syntax, diff

"always show gutter aka sign column, and clear its colour
autocmd BufEnter * sign define dummy
autocmd BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
highlight clear SignColumn

" Colors
highlight Comment ctermfg=darkgray   " make comments dark gray
highlight Visual ctermbg=black   " without this, cant see comments in visual mode
" make python docstring color like comments
syn region Comment start=/\'\'\'/ end=/\'\'\'/


" for modline maybe?
set nocompatible
filetype plugin on
set modeline
set modelines=5


"nnoremap <Leader>m :call ToggleMouse()<CR>

" useful functions
inoremap <Leader>p import pdb; pdb.set_trace()
nnoremap <Leader>w :%s/\s\+$//e<cr>  " clean trailing whitespace for the file
nnoremap  <Leader>s :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>
noremap <Leader>f :FZF $DATA_REPO<cr>




" only show the name of the tab in tabname
function MyTabLine()
    let s = ''
    for i in range(tabpagenr('$'))
        " select the highlighting
        if i + 1 == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
        endif

        " set the tab page number (for mouse clicks)
        let s .= '%' . (i + 1) . 'T'

        " the label is made by MyTabLabel()
        let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
    endfor

    " after the last tab fill with TabLineFill and reset tab page nr
    let s .= '%#TabLineFill#%T'

    " right-align the label to close the current tab page
    if tabpagenr('$') > 1
        let s .= '%=%#TabLine#%999Xclose'
    endif

    return s

endfunction

function MyTabLabel(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    "return bufname(buflist[winnr - 1])
    return fnamemodify(bufname(buflist[winnr - 1]), ':t')
endfunction

set tabline=%!MyTabLine()
" end tab stuff
