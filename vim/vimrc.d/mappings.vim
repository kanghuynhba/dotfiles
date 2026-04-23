" ============================================================================
"  Leader Key and Mappings
" ============================================================================

let mapleader = " "           " Space as leader

" Disable arrow keys (bad habit prevention)
nnoremap <Left>  <Nop>
nnoremap <Right> <Nop>
nnoremap <Up>    <Nop>
nnoremap <Down>  <Nop>

" Unbind useless defaults
map <C-a> <Nop>
map <C-x> <Nop>
nmap Q <Nop>

" Quick window movement (Ctrl + hjkl)
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Tab navigation (J/K to switch tabs, tt new, tx close)
nnoremap J :tabprev<CR>
nnoremap K :tabnext<CR>
nnoremap tt :tabnew<CR>
nnoremap tx :tabclose<CR>

" Tab management functions (close left/right/others)
function! CloseTabsToLeft()
    let l:count = tabpagenr() - 1
    while l:count > 0
        exec '1tabclose'
        let l:count = l:count - 1
    endwhile
endfunction

function! CloseTabsToRight()
    let l:current = tabpagenr()
    let l:last = tabpagenr('$')
    let l:count = l:last - l:current
    while l:count > 0
        exec l:last . 'tabclose'
        let l:count = l:count - 1
    endwhile
endfunction

nnoremap <leader>tl :call CloseTabsToLeft()<CR>
nnoremap <leader>tr :call CloseTabsToRight()<CR>
nnoremap <leader>to :tabonly<CR>

" System clipboard integration (yank/paste with leader)
nmap <Leader>y "+y
nmap <Leader>d "+d
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
