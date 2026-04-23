" ============================================================================
"  Theme Management (Dark / Light with persistence)
" ============================================================================

let s:bg_cache = expand('~/.vim_mode')

function! SetDark()
    set background=dark
    augroup CustomDarkOverrides
        autocmd!
        autocmd ColorScheme monokaicharcoal 
            \ hi Normal guibg=#000000 ctermbg=0 |
            \ hi NonText guibg=#000000 ctermbg=0 |
            \ hi LineNr guibg=#000000 ctermbg=0 |
            \ hi SignColumn guibg=#000000 ctermbg=0 |
            \ hi CursorLine guibg=#1c1c1c ctermbg=234 |
            \ hi CursorLineNr guibg=#1c1c1c guifg=#f8f8f2
    augroup END
    try
        colorscheme monokaicharcoal
    catch
        colorscheme default
    endtry
    let g:cpp_operator_highlight = 1
    let g:cpp_constant_highlight = 1
    highlight MatchParen ctermfg=Red ctermbg=Black guifg=Red guibg=#000000
    highlight StatusLine cterm=bold ctermfg=250 ctermbg=237
    highlight StatusLineNC cterm=NONE ctermfg=240 ctermbg=236
    highlight SpellBad cterm=underline
    let g:lightline = {'colorscheme': 'wombat'}
    call writefile(['dark'], s:bg_cache)
endfunction

function! SetLight()
    set background=light
    try
        colorscheme github
    catch
        colorscheme morning
    endtry
    let g:lightline = {'colorscheme': 'one'}
    call writefile(['light'], s:bg_cache)
endfunction

command! Dark call SetDark() | echo "Switched to Dark Mode"
command! Light call SetLight() | echo "Switched to Light Mode"

if filereadable(s:bg_cache)
    let s:mode = readfile(s:bg_cache)[0]
    if s:mode == "light"
        call SetLight()
    else
        call SetDark()
    endif
else
    call SetDark()
endif
