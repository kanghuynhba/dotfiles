" ============================================================================
"  Basic Settings
" ============================================================================

set nocompatible              " Not vi compatible (must be first)
filetype plugin indent on     " Enable file type detection and indentation
syntax enable                    " Syntax highlighting (syntax on resets; enable preserves overrides)

set encoding=utf-8
set t_Co=256                  " Force 256 colors (if needed)
set termguicolors             " For true color support in terminals

" Appearance
set number                    " Absolute line numbers
set relativenumber            " Relative line numbers (current line absolute)
set showcmd                   " Show partial command in status line
set showmatch                 " Show matching brackets
set laststatus=2              " Always show status line
set signcolumn=yes            " Keep sign column steady
set mouse+=a                  " Enable mouse support

" Behavior
set hidden                    " Allow hiding modified buffers
set backspace=indent,eol,start " Backspace over everything
set autoindent
set noerrorbells visualbell t_vb=  " Disable beeps
set updatetime=300            " Faster completion and diagnostics
set shortmess+=I              " Disable startup message

" Search
set ignorecase                " Case insensitive search
set smartcase                 " ... unless uppercase used
set incsearch                 " Search as you type

" Tabs & Indentation (4 spaces)
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set foldmethod=expr              " Enable folding (necessary for :Fold, zc/zo)
set foldlevelstart=99           " Open all folds by default, allow manual folding

" Cursor shape (iTerm2 / modern terminals)
let &t_SI = "\e[6 q"          " Insert mode: vertical bar
let &t_EI = "\e[2 q"          " Normal mode: block
let &t_SR = "\e[4 q"          " Replace mode: underline

" Window splitting (more natural)
set splitbelow
set splitright
