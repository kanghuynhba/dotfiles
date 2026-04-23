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
function! MkdirQuiet()
    let dir = expand('<afile>:p:h')
    " Skip remote files (scp, sftp, ftp, fugitive)
    if dir =~# '^\(scp\|sftp\|ftp\|fugitive\)://' | return | endif
    if dir != '.' && !isdirectory(dir)
        call mkdir(dir, 'p', 0700)
    endif
endfunction

augroup AutoMkdir
    autocmd!
    autocmd BufWritePre,FileWritePre * call MkdirQuiet()
augroup END

" ============================================================================
"  Global LSP (for Neovim, if using built-in LSP) – optional
" ============================================================================
" nnoremap <leader>ca :lua vim.lsp.buf.code_action()<cr>
" nnoremap <leader>cr :lua vim.lsp.buf.rename()<cr>

" ============================================================================
"  Debian/System defaults (optional)
" ============================================================================
if filereadable('/etc/debian_version')
    runtime! debian.vim
endif
if filereadable("/etc/vim/vimrc.local")
    source /etc/vim/vimrc.local
endif
