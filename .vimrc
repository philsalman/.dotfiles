".vimrc
" Author: David Salman <phil@netquity.com>
" Source: 
" This file changes a lot.  I'll try to document pieces of it whenever I have
" a few minutes to kill.
" {{{
" Basic options --------------------------------------------------------- {{{
set encoding=utf-8
set modelines=0
set autoindent
set showmode
set showcmd
set hidden
set visualbell
set ttyfast
set ruler
set backspace=indent,eol,start
set number
set norelativenumber
set laststatus=2
set history=1000
set undofile
set undoreload=10000
set list
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
set lazyredraw
set matchtime=3
set showbreak=↪
set splitbelow
set splitright
set autowrite
set autoread
set shiftround
set title
set linebreak
set colorcolumn=+1
set mouse=a
set nowrap

" Spelling -------------------------------------------------------------- {{{
" There are three dictionaries I use for spellchecking:
"
"   /usr/share/dict/words
"   Basic stuff.
"
"   ~/.vim/custom-dictionary.utf-8.add
"   Custom words (like my name).  This is in my (version-controlled) dotfiles.
"
"   ~/.vim-local-dictionary.utf-8.add
"   More custom wordis.  This is *not* version controlled, so I can stick
"   work stuff in here without leaking internal names and shit.
"
" I also remap zG to add to the local dict (vanilla zG is useless anyway).
set dictionary=/usr/share/dict/words
set spellfile=~/.vim/custom-dictionary.utf-8.add,~/.vim-local-dictionary.utf-8.add
nnoremap zG 2zg

" iTerm2 is currently slow as balls at rendering the nice unicode lines, so
" for
" now I'll just use ASCII pipes.  They're ugly but at least I won't want to
" kill
" myself when trying to move around a file.
set fillchars=diff:⣿,vert:│
set fillchars=diff:⣿,vert:\|

" Don't try to highlight lines longer than 800 characters.
set synmaxcol=800

" Time out on key codes but not mappings.
" Basically this makes terminal Vim work sanely.
set notimeout
set ttimeout
set ttimeoutlen=10

" Make Vim able to edit crontab files again.
set backupskip=/tmp/*,/private/tmp/*"

" Better Completion
set complete=.,w,b,u,t
set completeopt=longest,menuone,preview

" Save when losing focus
au FocusLost * :silent! wall

" Resize splits when the window is resized
au VimResized * :wincmd =

" Leader
let mapleader = ","
let maplocalleader = "\\"

" Cursorline ------------------------------------------------------------ {{{
" Only show cursorline in the current window and in normal mode.
augroup cline
	    au!
	    au WinLeave,InsertEnter * set nocursorline
	    au WinEnter,InsertLeave * set cursorline
augroup END
" }}}
" cpoptions+=J, dammit {{{
" Something occasionally removes this.  If I manage to find it I'm
" going to
" comment out the line and replace all its characters with 'FUCK'.
augroup twospace
	au!
	    au BufRead * :set cpoptions+=J
augroup END
" }}}

" Trailing whitespace --------------------------------------------------- {{{
" Only shown when not in insert mode so I don't go insane.
augroup trailing
	au!
	au InsertEnter * :set listchars-=trail:⌴
	au InsertLeave * :set listchars+=trail:⌴
augroup END

" }}}
" Wildmenu completion --------------------------------------------------- {{{
set wildmenu
set wildmode=list:longest
set wildignore+=.hg,.git,.svn
" Version control
set wildignore+=*.aux,*.out,*.toc
" LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg
" binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest
" compiled object files
set wildignore+=*.spl
" compiled spelling word lists
set wildignore+=*.sw?
" Vim swap files
set wildignore+=*.DS_Store
" OSX bullshit
set wildignore+=*.luac
" Lua byte code
set wildignore+=migrations
" Django migrations
set wildignore+=*.pyc
" Python byte code
set wildignore+=*.orig
" Merge resolution files
" Clojure/Leiningen
set wildignore+=classes
set wildignore+=lib

" }}}
" Line Return ----------------------------------------------------------- {{{
" Make sure Vim returns to the same line when
" you reopen a file. Thanks, Amit
augroup line_return
        au!
        au BufReadPost *:
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END

" }
" Tabs, spaces, wrapping ------------------------------------------------ {{{
set tabstop=8
set shiftwidth=4
set softtabstop=4
set expandtab
set wrap
set textwidth=80
set formatoptions=qrn1
set colorcolumn=+1

" }}}
" Backups --------------------------------------------------------------- {{{
set backup   
" swapfiles
set noswapfile 
" it's 2013 vim
set undodir=~/.vim/tmp/undo//
" backups dir
set backupdir=~/.vim/tmp/backup//
" backups
set directory=~/.vim/tmp/swap//
" swapfiles
" Make those folders automatically if they
" don't already exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir),"p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory),"p")
endif

" }}}
" Highlight VCS conflict markers ---------------------------------------- {{{
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
" }}}
" Color scheme solarized ------------------------------------------------ {{{
syntax on
set t_Co=256
set rtp+=~/.vim/bundle/
set background=dark
colorscheme solarized 

" }}}
" Vim Plug Plugins ------------------------------------------------------ {{{
call plug#begin('~/.vim/plugged')

" File management plugin 
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-git'
Plug 'gregsexton/gitv'

" Group dependencies, vim-snippets depends on ultisnips
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" Syntax checkers
Plug 'scrooloose/syntastic'
Plug 'Valloric/YouCompleteMe'
Plug 'tpope/vim-surround'
Plug 'Raimondi/delimitMate'

" Terminal apperance
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'arecarn/fold-cycle.vim'
Plug 'airblade/vim-gitgutter'

" Languages
Plug 'vim-ruby/vim-ruby'
Plug 'mfukar/robotframework-vim'
Plug 'hdima/python-syntax'
Plug 'pangloss/vim-javascript'
Plug 'nono/jquery.vim'
Plug 'burnettk/vim-angular'
Plug 'moll/vim-node'
Plug 'django.vim'
Plug 'othree/html5.vim'
Plug 'juleswang/css.vim'

" Test Runners
Plug 'jarrodctaylor/vim-python-test-runner'

" Local DB
Plug 'dbext.vim'
Plug 'bryanthankins/vim-aspnetide'

" Add plugins to &runtimepath
call plug#end()
" }}}
" }}}
