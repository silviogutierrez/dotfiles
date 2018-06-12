set shell=/bin/bash
set clipboard=unnamed
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'w0rp/ale'
Bundle 'wgibbs/vim-irblack'
Bundle 'wincent/Command-T'
Bundle 'plasticboy/vim-markdown'
Bundle 'tpope/vim-fugitive'
Bundle 'pangloss/vim-javascript'
Bundle 'leafgarland/typescript-vim'

call vundle#end()            " required
filetype plugin indent on    " required

let g:ale_sign_column_always = 1
let g:ale_open_list = 1
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1

" For when Neomake is enabled.
" autocmd! BufWritePost * Neomake
" let g:neomake_open_list = 2

" autocmd BufNewFile,BufRead *.ts,*.tsx setlocal filetype=typescript
autocmd BufNewFile,BufRead *.md,*.ts,*.tsx,*.py, setlocal spell
set spellfile=~/Sites/libraries/dotfiles/en.utf-8.add

let g:vim_markdown_folding_disabled=1

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
set relativenumber
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

" function! Bark(errors) abort " {{{2
"     let out = []
"     for e in a:errors
"         " new format
"         let parts = matchlist(e, '\v^(.{-1,}):(\d+): (error|warning|note):( .+)')
"         if len(parts) > 3
"             call add(out, join(parts[1:4], ':'))
"             continue
"         endif
"
"         " old format
"         let parts = matchlist(e, '\v^(.{-1,}), line (\d+): (.+)')
"         if len(parts) > 3
"             call add(out, join(parts[1:3], ':'))
"         endif
"     endfor
"     return out
" endfunction " }}}2
" let g:syntastic_python_mypy_preprocess = 'Bark'
"
" let g:ale_linters = {
" \   'python': ['autopep8', 'flake8'],
" \}
