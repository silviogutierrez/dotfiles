set shell=/bin/bash
set clipboard=unnamed
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'Shougo/vimproc'
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/syntastic'
Bundle 'wgibbs/vim-irblack'
Bundle 'chriskempson/vim-tomorrow-theme'
Bundle 'tpope/vim-surround'
Bundle 'wincent/Command-T'
Bundle 'ZenCoding.vim'
Bundle 'groenewege/vim-less'
Bundle 'klen/python-mode'
Bundle 'plasticboy/vim-markdown'
Bundle 'tpope/vim-fugitive'
Bundle 'pangloss/vim-javascript'
Bundle 'leafgarland/typescript-vim'
Bundle 'Quramy/tsuquyomi'
" Plugin 'itchyny/lightline.vim'

call vundle#end()            " required
filetype plugin indent on    " required

" autocmd BufNewFile,BufRead *.ts,*.tsx setlocal filetype=typescript
autocmd BufNewFile,BufRead *.md,*.ts,*.tsx,*.py, setlocal spell
set spellfile=~/Sites/libraries/dotfiles/en.utf-8.add

let g:vim_markdown_folding_disabled=1

let g:syntastic_python_python_exec = 'python3.5'
let g:pymode_folding = 0
let g:pymode_lint = 0
let g:pymode_lint_write = 0
let g:pymode_lint_checker = ""
" let g:pymode_lint_ignore = "C0301,R0921,R0201,E501,C901"
let g:pymode_rope = 0

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers=['jscs']
let g:syntastic_html_checkers=['']

let g:tsuquyomi_disable_quickfix = 1
let g:syntastic_typescript_checkers = ['tsuquyomi']

" let g:syntastic_typescript_tsc_fname = ''
" let g:syntastic_typescript_checkers = ['tsc', 'tslint']

let g:syntastic_python_python_exec = 'python3.5'

function! JscsFix()
    "Save current cursor position"
    let l:winview = winsaveview()
    "Pipe the current buffer (%) through the jscs -x command"
    % ! jscs -x
    "Restore cursor position - this is needed as piping the file"
    "through jscs jumps the cursor to the top"
    call winrestview(l:winview)
endfunction
command JscsFix :call JscsFix()

filetype plugin indent on


" set spell spelllang=en_us
set tabpagemax=1000
set t_Co=256

" This way we don't get an annoying warning when setting up vundle.
try
  colorscheme ir_black
catch
endtry

set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
set expandtab

syntax on
set number
set autoread
set backspace=2

" Basic tab completion.
imap <Tab> <C-P>

" Let's us save with \w.
" \ is the default leader key.
nmap <leader>w :w!<cr>

" Fast editing of the .vimrc
map <leader>e :tabedit! ~/.vimrc<CR>

" Clear trailing whitespace with \s and save the file.
map <leader>s :%s/\s\+$//e<CR>:w!<CR>

map <leader>t :CommandT<CR>

" Open a custom Commad-T instace with \T
map <leader>T :CommandT<Space>~/Sites/

" double percentage sign in command mode is expanded
" to directory of current file - http://vimcasts.org/e/14
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>F :CommandT %%<cr>

map <leader>o :tabedit<Space>

" Open files in the same directory quickly with \O
" See http://vimdoc.sourceforge.net/htmldoc/cmdline.html#filename-modifiers
map <leader>O :tabedit %%

" Open files vertically quickly with \v.
map <leader>v :vsplit<Space>

" Better tab functionality.
map <leader>[ :tabprev<CR>
map <leader>] :tabnext<CR>
map <leader>- :tabfirst<CR>
map <leader>= :tablast<CR>

" Toggle paste mode wiht \p
set pastetoggle=<leader>p

" Toggle line numbers with \n
nmap <leader>n :set invnumber<CR>

" Run tests
nmap <leader>r :!node tests/mocha.js --bail --preserve<CR>

" When vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc

" Ignore case while searching.
set ignorecase
set smartcase
set incsearch

" Turn backup off, since most stuff is in SVN, git anyway...
set nobackup
set nowb
set noswapfile

map <space> /
map <c-space> ?

set wildignore+=*.o,*.obj,_book,.git,.hg/**,*.pyc,*.png,*.gif,*.jpg,*.jpeg,*.egg-info/**,*.mo,files/**,media/**
" let g:CommandTAcceptSelectionTabMap='<CR>'

" Set \b to :CommandTMRU
:nnoremap <silent> <leader>b :CommandTMRU<CR>

let g:CommandTMaxCachedDirectories=0
let g:CommandTTraverseSCM='pwd'
let g:CommandTWildIgnore=&wildignore . ",**/node_modules/*,**/bower_components/*"
let g:CommandTMaxFiles=20000

hi ColorColumn ctermbg=235
hi TabLine ctermbg=0
hi TabLineFill ctermfg=0
hi TabLineSel ctermfg=blue

set colorcolumn=81,82

" TODO: does this still work?
" ANSWER: not in vim 8.
" if filereadable(glob("$SITE_NAME/.vimrc"))
"   source $PWD/$SITE_NAME/.vimrc
" endif

function! Meow()
    let method = getline(search("\\sdef\\s", "bn"))
    let method = substitute(method, "^\\s\\+def\\s\\+", "", "g")
    let method = substitute(method, "(.\\+$", "", "g")

    let class = getline(search("^\\S", "bn"))
    let class = substitute(class, "^class\\s\\+", "", "g")
    let class = substitute(class, "(.\\+$", "", "g")

    " Current directory, then last element is the file.
    let file = split(expand('%:h'), "/")[-1]
    let command = "!../../bin/python server/manage.py test apps." . file . ".tests." . class . "." . method .  " --failfast --keepdb"
    echom command
    execute command
endfunction

map <leader>` :call Meow()<CR>
