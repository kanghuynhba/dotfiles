" ============================================================================
"  Language-Specific Mappings (Run/Build/Test)
" ============================================================================

augroup LangRunner
    autocmd!

    " Rust
    autocmd FileType rust nnoremap <buffer> <leader>rr :w <bar> !cargo run<cr>
    autocmd FileType rust nnoremap <buffer> <leader>rt :w <bar> !cargo test<cr>
    autocmd FileType rust nnoremap <buffer> <leader>rta :w <bar> !cargo test -- --nocapture<cr>
    autocmd FileType rust nnoremap <buffer> <leader>bb :w <bar> !cargo build<cr>

    " Python
    autocmd FileType python nnoremap <buffer> <leader>rr :w <bar> !python3 %<cr>
    autocmd FileType python nnoremap <buffer> <leader>rt :w <bar> !pytest %<cr>

    " Go
    autocmd FileType go nnoremap <buffer> <leader>rr :w <bar> !go run %<cr>
    autocmd FileType go nnoremap <buffer> <leader>rt :w <bar> !go test ./...<cr>
    autocmd FileType go nnoremap <buffer> <leader>bb :w <bar> !go build ./...<cr>

    " TypeScript / TSX
    autocmd FileType typescript,typescriptreact nnoremap <buffer> <leader>rr :w <bar> !npx ts-node %<cr>
    autocmd FileType typescript,typescriptreact nnoremap <buffer> <leader>bb :w <bar> !npx tsc --noEmit<cr>

    " C++ (adjust compiler path as needed)
    autocmd FileType cpp nnoremap <buffer> <leader>bb :w <bar> !g++ -O2 -std=c++17 % -o %:r<cr>
    autocmd FileType cpp nnoremap <buffer> <leader>rr :w <bar> !g++ -O2 -std=c++17 % -o %:r && ./%:r<cr>

    " Java
    autocmd FileType java nnoremap <buffer> <leader>bb :w <bar> !javac %<cr>
    autocmd FileType java nnoremap <buffer> <leader>rr :w <bar> !javac % && java %:r<cr>

augroup END
