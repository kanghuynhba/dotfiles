" ============================================================================
"  Language-Specific Mappings (Run/Build/Test)
" ============================================================================

augroup LangRunner
    autocmd!

    " Rust
    autocmd FileType rust nnoremap <buffer> <leader>rr :vert RustRun<cr>
    autocmd FileType rust nnoremap <buffer> <leader>rt :vert RustTest<cr>
    autocmd FileType rust nnoremap <buffer> <leader>rta :vert RustTest!<cr>
    autocmd FileType rust nnoremap <buffer> <leader>bb :vert cargo build<cr>

    " Python
    autocmd FileType python nnoremap <buffer> <leader>rr :w <bar> !python3 %<cr>
    autocmd FileType python nnoremap <buffer> <leader>rt :w <bar> !pytest %<cr>

    " C++ (adjust compiler path as needed)
    autocmd FileType cpp nnoremap <buffer> <leader>bb :w <bar> !g++-15 -O3 % -o %:r<cr>
    autocmd FileType cpp nnoremap <buffer> <leader>rr :w <bar> !g++-15 -O3 % -o %:r && ./%:r<cr>

    " Java
    autocmd FileType java nnoremap <buffer> <leader>bb :w <bar> !javac %<cr>
    autocmd FileType java nnoremap <buffer> <leader>rr :w <bar> !javac % && java %:r<cr>

augroup END
