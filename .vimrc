" init vundle and plugin code
source $HOME/dotfiles/.vim.plugins


" Some starter commands
set nu  " having this set will set current line to be line number instead of 0
set relativenumber "if things get slow, try toggling this
set noswapfile  " no backup files


" allow some commands to take over when in insert mode 
inoremap :w <ESC>:w
inoremap <C-w> <ESC><C-w>

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


"set autochdir " change to current directory within vim when opening a file
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
"set cinoptions=>1s "tab 1x shiftwidth on newline" -- maybe just if cpp? or disable in python?

" some utilities for closing
nnoremap `` :q<CR> 
nnoremap <leader>qa :bufdo bwipeout<CR> " close all buffers but dont close vim

set showmatch " show matching parens
set ignorecase
set smartcase
set smarttab
syntax on
set timeoutlen=350 " default 1000, timeout commands more quickly

"find what these are
au FileType * setl fo-=cro
set incsearch " allow using s//new_word after search
set nostartofline

" set lazyredraw
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

" for react files
au BufNewFile,BufRead *.jsx set tabstop=2 shiftwidth=2 softtabstop=2

" for copy pasting between tmux
" copy something in vim, then call c to write it to a file
nmap <Leader>c :call writefile(split(@@, "\n", 1), '/tmp/vimcopy')<CR>
" me trying to update it
" noremap <Leader>c :call writefile(@@, '/tmp/vimcopy', 'b')<CR>
noremap <leader>v :r! cat /tmp/vimcopy<CR>

" more general stuff
set laststatus=2
set cf  " something about error files"
"set isk+=_,$,@,%,#, " these are not word separators
set ruler " show row, column
set diffopt+=iwhite
set wildmenu "allow tabbing to autocomplete
set wildmode=list:longest
" set hidden
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
    au BufEnter * call matchadd('ColorColumn', '\%121v.', 100) "set column nr
augroup END


"set colorcolumn=80 "color just column 80


"Navigation mapping
"nnoremap ' `
"nnoremap ` '
nnoremap j gj
nnoremap k gk
"nnoremap gk k
"nnoremap gj j
"map <C-a> ^
"map <C-e> $

" Tab keyboard mapping
set wildcharm=<C-z>
":noremap <C-t> :tabnew<cr>:FZF $DATA_REPO<cr>
nnoremap <C-t> :tabnew<cr>:call FastFzf()<CR>
nnoremap <C-e> :tabnew %:h<C-z>
nnoremap <leader>ee :e %:h<C-z>
nnoremap <leader>et :tabe 
:nmap<C-j> :tabprevious<cr>
:nmap<C-k> :tabnext<cr>

" If in insert mode, leave insert mode before moving files
"imap <C-t> <ESC>:tabnew<cr>:FZF $DATA_REPO<cr>
imap <C-t> <ESC>:tabnew<cr>:call FastFzf()<CR>
imap <C-e> <ESC>:tabnew %:h<C-z>
:imap<C-j> <ESC>:tabprevious<cr>cr
:imap<C-k> <ESC>:tabnext<cr>

" for ctags
" for now, stop scanning tags until i can find why its so slow
set complete-=t
"":noremap <Leader>t <C-t>
" open tag in a new tab
" map <Leader>t :tab split<CR>:exec("tag ".expand("<cword>"))<CR> 
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


cnoremap vr vertical resize

" cool function to create a url w/ respect to a file. More of an exercise since created around a specific url. It also doesnt work sometimes, but idk when
" todo: split out getting the file_path
function! GetUrl(base_url)
    "let l:current_file=expand('%:t') " use this when you just want the 
    let l:current_file=expand('%:.') " 
    let l:file_path = trim(system('git ls-files --full-name ' . l:current_file))
    let l:line = line('.')
    let l:url = a:base_url . l:file_path . '#' . l:line
    echo l:url
endfunc

function! GitRoot()
    " git root is defined in git_scripts
    return trim(system('git root'))
endfunc



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

" useful functions
inoremap <Leader>p import ipdb; ipdb.set_trace()
nnoremap <Leader>w :%s/\s\+$//e<cr>  " clean trailing whitespace for the file
nnoremap  <Leader>s :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>

" this is for making netrw (vim explorer) behave more like nerdtree, have not used much
" let g:netrw_banner = 1 " 0 to disable"
" let g:netrw_liststyle = 3
" let g:netrw_browse_split = 4
" let g:netrw_altv = 1
" let g:netrw_winsize = 25
" augroup ProjectDrawer
"     autocmd!
"     autocmd VimEnter * :Vexplore
" augroup END


" only show the name of the tab in tabname
function MyTabLabel(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    "return bufname(buflist[winnr - 1])
    return fnamemodify(bufname(buflist[winnr - 1]), ':t')
endfunction

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

set tabline=%!MyTabLine()

" this is the default statuline (ish) - taken from stackoverflow
" statusline=%f\ %h%w%m%r%=%-14.(%l,%c%V%)\ %P
" set statusline=%F%h%m  
set statusline=%F%h%m\ %h%w%m%r%=%-14.(%l,%c%V%)\ %P " show full path in status bar, help buffer, then modfiied"
" end tab stuff
