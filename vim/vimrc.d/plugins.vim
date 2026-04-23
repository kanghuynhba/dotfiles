" ============================================================================
"  Plugin Configuration
" ============================================================================

" ---- lightline (status line) - already set in theme ----
" Additional config can go here

" ---- ALE (Asynchronous Lint Engine) ----
let g:ale_virtualtext_cursor = 'current'
let g:ale_disable_lsp = 1

    " \ 'python': ['flake8'],
    " \ 'javascript': ['eslint'],
    " \ 'typescript': ['eslint'],
    " \ 'json': ['jsonlint'],
let g:ale_linters = {
    \ 'sh': ['shellcheck'],
    \ 'vim': ['vint'],
    \}

    " \ 'python': ['black', 'isort'],
    " \ 'javascript': ['prettier'],
    " \ 'typescript': ['prettier'],
    " \ 'json': ['jq'],
let g:ale_fixers = {
    \ 'sh': ['shfmt'],
    \}
let g:ale_fix_on_save = 1

" ---- FZF ----
set rtp+=~/Config/dotfiles/zsh/plugins/fzf   " Adjust path if needed
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.7, 'border': 'rounded' } }
let $FZF_DEFAULT_OPTS = '--bind="ctrl-d:preview-page-down,ctrl-u:preview-page-up" --preview "bat --style=numbers --color=always --line-range :500 {}"'
let $FZF_DEFAULT_OPTS .= ' --color=border:#fd971f,bg:#0a0006,bg+:#22191e,hl:#a6e22e,hl+:#f92672'
nnoremap <C-p> :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>h :History<CR>
nnoremap <leader>g :Rg<Space>
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--info=inline']}), <bang>0)
let g:fzf_action = {
    \ 'enter': 'tabedit',
    \ 'ctrl-x': 'split',
    \ 'ctrl-v': 'vsplit' }

" ---- ctrlp (alternative buffer picker) ----
nnoremap ; :CtrlPBuffer<CR>
let g:ctrlp_switch_buffer = 0
let g:ctrlp_show_hidden = 1

" ---- copilot.vim ----
let g:copilot_filetypes = {
    \ '*' : v:true,
    \ 'cpp' : v:false,
    \ 'java' : v:false,
    \ 'rust' : v:false,
    \ 'markdown' : v:false,
    \ }

" ---- leetcode.vim ----
nnoremap <leader>ll :LeetCodeList<cr>
nnoremap <leader>lt :LeetCodeTest<cr>
nnoremap <leader>ls :LeetCodeSubmit<cr>
nnoremap <leader>li :LeetCodeSignIn<cr>
let g:leetcode_browser='brave'

" ---- rust.vim ----
let g:rustfmt_autosave = 1

" ---- markdown ----
let g:markdown_fenced_languages = [
    \ 'asm', 'bash=sh', 'c', 'cpp', 'coffee', 'erb=eruby', 'javascript',
    \ 'json', 'perl', 'python', 'ruby', 'yaml', 'go', 'racket', 'haskell', 'rust'
\]
let g:markdown_syntax_conceal = 0
let g:markdown_folding = 1

" ---- Jupytext (Python notebooks) ----
let g:jupytext_fmt = 'py:percent'
highlight JupyterCellSeparator guifg=#50fa7b gui=bold
match JupyterCellSeparator /^# %%.*/

" ---- Java syntax ----
highlight link javaIdentifier NONE
highlight link javaDelimiter NONE
