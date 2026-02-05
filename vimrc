" system runtime files -- /usr/share/vim/vim<version>.
"
" Vim will load $VIMRUNTIME/defaults.vim if the user does not have a vimrc.
" This happens after /etc/vim/vimrc(.local) are loaded, so it will override
" any settings in these files.
"
" If you don't want that to happen, uncomment the below line to prevent
" defaults.vim from being loaded.
" let g:skip_defaults_vim = 1
"
" If you would rather _use_ default.vim's settings, but have the system or
" user vimrc override its settings, then uncomment the line below.
" source $VIMRUNTIME/defaults.vim

" All Debian-specific settings are defined in $VIMRUNTIME/debian.vim and
" sourced by the call to :runtime you can find below.  If you wish to change
" any of those settings, you should do it in this file or
" /etc/vim/vimrc.local, since debian.vim will be overwritten everytime an
" upgrade of the vim packages is performed. It is recommended to make changes
" after sourcing debian.vim so your settings take precedence.

runtime! debian.vim

if has("syntax")
  syntax on
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
"
set nocompatible " not vi compatible

"------------------
" Syntax and indent
"------------------
set showmatch " show matching braces when text indicator is over them

" --- Theme Management ---
let s:bg_cache = expand('~/.vim_mode')

function! SetDark()
    set background=dark
    try 
        colorscheme monokaicharcoal
    catch
        colorscheme default
    endtry

    " Your custom highlights for Monokai
    let g:cpp_operator_highlight = 1
    let g:cpp_constant_highlight = 1
    highlight SignColumn ctermbg=235
    highlight MatchParen ctermfg=Red ctermbg=Black guifg=Red guibg=Black
    highlight StatusLine cterm=bold ctermfg=250 ctermbg=237
    highlight StatusLineNC cterm=NONE ctermfg=240 ctermbg=236
    highlight SpellBad cterm=underline
    highlight CursorLineNr cterm=NONE
    
    " Lightline theme for dark mode
    let g:lightline = {'colorscheme': 'wombat'}
    
    " Save preference
    call writefile(['dark'], s:bg_cache)
endfunction

function! SetLight()
    set background=light
    try
        colorscheme github
    catch
        colorscheme default " Fallback if github theme is missing
    endtry
    
    " Lightline theme for light mode (optional, 'one' or 'papercolor' usually look good)
    let g:lightline = {'colorscheme': 'one'} 

    " Save preference
    call writefile(['light'], s:bg_cache)
endfunction

" --- Commands ---
command! Dark call SetDark() | echo "Switched to Dark Mode"
command! Light call SetLight() | echo "Switched to Light Mode"

" --- Startup Logic ---
" Read the cache file to decide which one to load on startup
if filereadable(s:bg_cache)
    let s:mode = readfile(s:bg_cache)[0]
    if s:mode == "light"
        call SetLight()
    else
        call SetDark()
    endif
else
    " Default to Dark if no history exists
    call SetDark()
endif" highlight current line, but only in active window

augroup  CursorLineOnlyInActiveWindow
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
    autocmd BufWritePre,FileWritePre * silent! call mkdir(expand('<afile>:p:h'), 'p')
augroup END

" vim can autodetect this based on $TERM (e.g. 'xterm-256color')
" but it can be set to force 256 colors
set t_Co=256

syntax enable
filetype plugin indent on " enable file type detection
set autoindent

let &t_SI = "\e[6 q"   " Insert mode: vertical bar
let &t_EI = "\e[2 q"   " Normal mode: block
let &t_SR = "\e[4 q"   " Replace mode: underline

set nofoldenable " disable folding by default
" use 4 spaces instead of tabs during formatting 
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" markdown
let g:markdown_fenced_languages = [
    \ 'asm',
    \ 'bash=sh',
    \ 'c',
    \ 'cpp',
    \ 'coffee',
    \ 'erb=eruby',
    \ 'javascript',
    \ 'json',
    \ 'perl',
    \ 'python',
    \ 'ruby',
    \ 'yaml',
    \ 'go',
    \ 'racket',
    \ 'haskell',
    \ 'rust',
\]
let g:markdown_syntax_conceal = 0
let g:markdown_folding = 1

" rust.vim
let g:rustfmt_autosave = 1
let g:syntastic_rust_checkers = ['cargo']

"--------------------
" Misc configurations
"--------------------

let mapleader = " "   " Use spacebar as leader key (very common)

" unbind keys
map <C-a> <Nop>
map <C-x> <Nop>
nmap Q <Nop>

" disable audible bell
set noerrorbells visualbell t_vb=

" open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

"---------------------
" Plugin configuration
"---------------------

" java-syntax.vim
highlight link javaIdentifier NONE
highlight link javaDelimiter NONE

" copilot.vim
let g:copilot_filetypes = {
    \ '*' : v:true,
    \ 'cpp' : v:false,
    \ 'java' : v:false,
    \ 'rust' : v:false,
    \ 'markdown' : v:false,
    \ }

" ctrlp
nnoremap ; :CtrlPBuffer<CR>
let g:ctrlp_switch_buffer = 0
let g:ctrlp_show_hidden = 1

" leetcode.vim
nnoremap <leader>ll :LeetCodeList<cr>
nnoremap <leader>lt :LeetCodeTest<cr>
nnoremap <leader>ls :LeetCodeSubmit<cr>
nnoremap <leader>li :LeetCodeSignIn<cr>
let g:leetcode_browser='brave'
let g:leetcode_solution_filetype='rust'

" ale
set signcolumn=yes
let g:ale_virtualtext_cursor = 'current'
" " Disable whitespace warnings
let g:ale_warn_about_trailing_whitespace = 0
let g:ale_set_highlights=0
let g:ale_disable_lsp = 1
let g:ale_linters = {
\   'java': ['mvn','checkstyle', 'cspell', 'eclipselsp', 'javac', 'javalsp', 'pmd'],
\   'rust': ['cargo', 'rls', 'clippy', 'cspell'], 
\}

"  y d p P   --  Quick copy paste into system clipboard
nmap <Leader>y "+y
nmap <Leader>d "+d
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p

" Uncomment the following to have Vim jump to the last position when
" reopening a file
"au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
"filetype plugin indent on

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set autowrite		" Automatically save before commands like :next and :make

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif
" Comments in Vimscript start with a `"`.

" If you open this file in Vim, it'll be syntax highlighted for you.

" Vim is based on Vi. Setting `nocompatible` switches from the default
" Vi-compatibility mode and enables useful Vim functionality. This
" configuration option turns out not to be necessary for the file named
" '~/.vimrc', because Vim automatically enters nocompatible mode if that file
" is present. But we're including it here just in case this config file is
" loaded some other way (e.g. saved as `foo`, and then Vim started with
" `vim -u foo`).
set nocompatible

" Turn on syntax highlighting.
syntax on

" Disable the default Vim startup message.
set shortmess+=I

" Show line numbers.
set number

" This enables relative line numbering mode. With both number and
" relativenumber enabled, the current line shows the true line number, while
" all other lines (above and below) are numbered relative to the current line.
" This is useful because you can tell, at a glance, what count is needed to
" jump up or down to a particular line, by {count}k to go up or {count}j to go
" down.
set relativenumber

" Always show the status line at the bottom, even if you only have one window open.
set laststatus=2

" The backspace key has slightly unintuitive behavior by default. For example,
" by default, you can't backspace before the insertion point set with 'i'.
" This configuration makes backspace behave more reasonably, in that you can
" backspace over anything.
set backspace=indent,eol,start

" By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
" shown in any window) that has unsaved changes. This is to prevent you from "
" forgetting about unsaved changes and then quitting e.g. via `:qa!`. We find
" hidden buffers helpful enough to disable this protection. See `:help hidden`
" for more information on this.
set hidden

" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
set ignorecase

set smartcase

" Enable searching as you type, rather than waiting till you press enter.
set incsearch

" Unbind some useless/annoying default key bindings.
nmap Q <Nop> " 'Q' in normal mode enters Ex mode. You almost never want this.

" Disable audible bell because it's annoying.
set noerrorbells visualbell t_vb=

" Enable mouse support. You should avoid relying on this too much, but it can
" sometimes be convenient.
set mouse+=a

" Try to prevent bad habits like using the arrow keys for movement. This is
" not the only possible bad habit. For example, holding down the h/j/k/l keys
" for movement, rather than using more efficient movement commands, is also a
" bad habit. The former is enforceable through a .vimrc, while we don't know
" how to prevent the latter.
" Do this in normal mode...
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Down>  :echoe "Use j"<CR>
" ...and in insert mode
"
" https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.vim

" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" utf-8 byte sequence
set encoding=utf-8
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent><nowait> gd <Plug>(coc-definition)
nmap <silent><nowait> gy <Plug>(coc-type-definition)
nmap <silent><nowait> gi <Plug>(coc-implementation)
nmap <silent><nowait> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" =============================================================================
" Language Specific Mappings (Run, Build, Test)
" =============================================================================

augroup LangRunner
    autocmd!

    " --- RUST ---
    autocmd FileType rust nnoremap <buffer> <leader>rr :RustRun<cr>
    autocmd FileType rust nnoremap <buffer> <leader>rt :RustTest<cr>
    autocmd FileType rust nnoremap <buffer> <leader>rta :RustTest!<cr>
    autocmd FileType rust nnoremap <buffer> <leader>bb :cargo build<cr>

    " --- PYTHON ---
    " Python usually doesn't need a 'build' step, so we map bb to check syntax
    autocmd FileType python nnoremap <buffer> <leader>rr :w <bar> !python3 %<cr>
    autocmd FileType python nnoremap <buffer> <leader>rt :w <bar> !pytest %<cr>

    " --- C++ ---
    " Build (bb) compiles; Run (rr) compiles and executes
    autocmd FileType cpp nnoremap <buffer> <leader>bb :w <bar> !g++ -O3 % -o %:r<cr>
    autocmd FileType cpp nnoremap <buffer> <leader>rr :w <bar> !g++ -O3 % -o %:r && ./%:r<cr>

    " --- JAVA ---
    " Build (bb) compiles; Run (rr) runs the class file
    autocmd FileType java nnoremap <buffer> <leader>bb :w <bar> !javac %<cr>
    autocmd FileType java nnoremap <buffer> <leader>rr :w <bar> !javac % && java %:r<cr>

augroup END

" --- GLOBAL LSP (Works across all languages if you have an LSP client) ---
nnoremap <leader>ca :lua vim.lsp.buf.code_action()<cr>
nnoremap <leader>cr :lua vim.lsp.buf.rename()<cr>
