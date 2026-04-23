" ============================================================================
"  CursorLine: only in active window
" ============================================================================

augroup CursorLineOnlyInActiveWindow
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
augroup END

" ============================================================================
"  Auto-create parent directories on write
" ============================================================================

augroup AutoMkdir
    autocmd!
    autocmd BufWritePre,FileWritePre * silent! call mkdir(expand('<afile>:p:h'), 'p')
augroup END

" ============================================================================
"  Global LSP (for Neovim, if using built-in LSP) – optional
" ============================================================================
" nnoremap <leader>ca :lua vim.lsp.buf.code_action()<cr>
" nnoremap <leader>cr :lua vim.lsp.buf.rename()<cr>

" ============================================================================
"  Debian/System defaults (optional)
" ============================================================================
runtime! debian.vim
if filereadable("/etc/vim/vimrc.local")
    source /etc/vim/vimrc.local
endif
