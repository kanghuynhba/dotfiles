" ============================================================================
"  coc.nvim — Multi-Language Enhanced Edition
"  Adapted for: Rust · Python · C++ · Java · Go · TypeScript · Lua · Bash · PHP
"  Compatible with your: ALE (linting-only), FZF, copilot.vim, rust.vim
" ============================================================================

" ----------------------------------------------------------------------------
"  Core settings (guards against double-setting from basic.vim)
" ----------------------------------------------------------------------------
set nobackup
set nowritebackup
" NOTE: signcolumn=yes and updatetime=300 already set in your basic.vim
"       Keeping them here is safe (idempotent), but they are not duplicated.

" ----------------------------------------------------------------------------
"  Required extensions — install via :CocInstall if missing
" ----------------------------------------------------------------------------
" Run this once:
"   :CocInstall coc-rust-analyzer coc-pyright coc-clangd coc-java
"   \           coc-go coc-tsserver coc-lua coc-sh coc-json coc-yaml
"   \           coc-toml coc-snippets coc-pairs coc-highlight coc-phplang

" ----------------------------------------------------------------------------
"  Per-language LSP server activation guard
"  (disables coc for filetypes where ALE already handles linting/LSP)
" ----------------------------------------------------------------------------
"  Your ALE config has g:ale_disable_lsp = 1, so ALE won't conflict.
"  ALE only handles sh/vim linting + sh formatting — coc takes everything else.

let g:coc_filetypes_disable = []   " All filetypes get coc by default

" ----------------------------------------------------------------------------
"  Filetype-aware tab width (overrides basic.vim's global 4-space default)
" ----------------------------------------------------------------------------
augroup LangIndent
    autocmd!
    " 2-space: Go, JS/TS, JSON, YAML, Lua, Ruby, HTML
    autocmd FileType go,javascript,typescript,javascriptreact,typescriptreact,
                \json,yaml,lua,ruby,html,css,scss setlocal tabstop=2 shiftwidth=2 softtabstop=2
    " 4-space: Python, Rust, C, C++, Java, Bash, PHP (already global default)
    autocmd FileType python,rust,c,cpp,java,sh,php setlocal tabstop=4 shiftwidth=4 softtabstop=4
    " Tabs (no expand): Go uses gofmt's tabs
    autocmd FileType go setlocal noexpandtab
augroup END

" ----------------------------------------------------------------------------
"  Completion & Snippet helpers
" ----------------------------------------------------------------------------
function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~# '\s'
endfunction

" Smart <Tab>: completion → snippet placeholder → indent fallback
inoremap <silent><expr> <TAB>
    \ coc#pum#visible() ? coc#pum#next(1) :
    \ coc#snippet#jumpable(1) ? "\<Plug>(coc-snippets-expand-jump)" :
    \ CheckBackspace() ? "\<Tab>" :
    \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Accept completion with Enter
inoremap <silent><expr> <CR>
    \ coc#pum#visible() ? coc#pum#confirm() :
    \ "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Trigger completion manually
if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
else
    inoremap <silent><expr> <c-@> coc#refresh()
endif

" Snippet placeholder jumping
"   NOTE: <C-l> conflicts with your window-move mapping <C-l> in mappings.vim.
"   Using <C-j>/<C-k> would conflict with window movement too.
"   Solution: use <M-l> (Alt+l) for snippet jump — no conflicts.
imap <silent> <M-l> <Plug>(coc-snippets-expand-jump)
nmap <silent> <M-l> <Plug>(coc-snippets-expand-jump)
xmap <silent> <M-l> <Plug>(coc-snippets-select)

" ----------------------------------------------------------------------------
"  Diagnostic navigation
"  NOTE: [g / ]g are safe — not used in your mappings.vim
" ----------------------------------------------------------------------------
nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)

" Quickfix: current buffer diagnostics
nnoremap <silent> <leader>gd :call CocAction('diagnosticList')<CR>

" Show diagnostic message at cursor in float (no keymap conflict)
nnoremap <silent> <leader>gm :call CocActionAsync('diagnosticInfo')<CR>

" Copy diagnostic message at cursor to clipboard
function! CopyDiagnostic()
    let l:diags = CocAction('diagnosticList')
    let l:cur_line = line('.') - 1
    let l:line_diags = filter(copy(l:diags), 'v:val.lnum == l:cur_line')
    if empty(l:line_diags)
        echo "No diagnostic on this line."
        return
    endif
    let l:msg = l:line_diags[0].message
    let l:msg = substitute(l:msg, '\v\s*\[[^\]]+\]$', '', '')
    call setreg('+', l:msg)
    call setreg('"', l:msg)
    echo "Copied: " . (len(l:msg) > 50 ? l:msg[:50] . "..." : l:msg)
endfunction

nnoremap <silent> <leader>yd :call CopyDiagnostic()<CR>

" ----------------------------------------------------------------------------
"  GoTo code navigation
"  NOTE: gd/gy/gi/gr — safe, not in your mappings.vim
" ----------------------------------------------------------------------------
nmap <silent><nowait> gd <Plug>(coc-definition)
nmap <silent><nowait> gy <Plug>(coc-type-definition)
nmap <silent><nowait> gi <Plug>(coc-implementation)
nmap <silent><nowait> gr <Plug>(coc-references)

" Open definition in vertical split
nmap <silent> <leader>gv :call CocAction('jumpDefinition', 'vsplit')<CR>
" Open definition in horizontal split
nmap <silent> <leader>gh :call CocAction('jumpDefinition', 'split')<CR>

" ----------------------------------------------------------------------------
"  Documentation hover
"  NOTE: your mappings.vim maps K → :tabnext and M → ShowDocumentation.
"        K is overridden here for LSP hover — this is intentional.
"        M is kept as backup hover. tabnext is mapped to K in mappings.vim;
"        since LSP hover is more useful on K in code buffers, K is reclaimed.
"        If you want to keep K for tab nav, swap to <leader>k below.
" ----------------------------------------------------------------------------
nnoremap <silent> K  :call ShowDocumentation()<CR>
nnoremap <silent> M  :call ShowDocumentation()<CR>

function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    else
        execute '!' . &keywordprg . " " . expand('<cword>')
    endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" ----------------------------------------------------------------------------
"  Refactoring & Code Actions
"  NOTE: <leader>r conflicts with your coc-codeaction-refactor-selected.
"        <leader>rr is your run-file mapping in languages.vim — PRESERVED.
"        Refactor renamed to <leader>rx to avoid collision.
" ----------------------------------------------------------------------------
nmap <leader>rn <Plug>(coc-rename)                   " Rename symbol

" Format selected (xmap <leader>f safe — not in mappings.vim)
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Code actions (safe — not in mappings.vim)
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>ac <Plug>(coc-codeaction-cursor)
nmap <leader>as <Plug>(coc-codeaction-source)        " Organize imports, etc.
nmap <leader>qf <Plug>(coc-fix-current)              " Auto-fix current diagnostic

" Refactor (renamed from <leader>r to avoid collision with languages.vim <leader>rr)
nmap <silent> <leader>rx  <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>rx  <Plug>(coc-codeaction-refactor-selected)

" ----------------------------------------------------------------------------
"  Code Lens & Outline
" ----------------------------------------------------------------------------
nmap <leader>cl <Plug>(coc-codelens-action)

" Outline via CocList (correct — outline.toggle does not exist)
nnoremap <silent> <leader>co :CocList outline<CR>

" ----------------------------------------------------------------------------
"  Inlay hints toggle
" ----------------------------------------------------------------------------
command! ToggleInlayHints :call CocActionAsync('toggleInlayHints')
" NOTE: <leader>h conflicts with your FZF :History binding in plugins.vim.
"       Inlay hints moved to <leader>ih.
nnoremap <silent> <leader>ih :ToggleInlayHints<CR>

" ----------------------------------------------------------------------------
"  Text objects for functions / classes
" ----------------------------------------------------------------------------
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" ----------------------------------------------------------------------------
"  Floating window scroll
"  NOTE: <C-f>/<C-b> safe — not used in your mappings.vim
" ----------------------------------------------------------------------------
if has('nvim-0.4.0') || has('patch-8.2.0750')
    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
    inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
    vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" ----------------------------------------------------------------------------
"  Range select
"  NOTE: Add 'stty -ixon' to your .bashrc/.zshrc to enable <C-s> in terminal
" ----------------------------------------------------------------------------
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" ----------------------------------------------------------------------------
"  Format / Fold / Organize imports commands
" ----------------------------------------------------------------------------
command! -nargs=0 Format :call CocActionAsync('format')
command! -nargs=? Fold   :call CocAction('fold', <f-args>)
command! -nargs=0 OR     :call CocActionAsync('runCommand', 'editor.action.organizeImport')

" Per-language organize imports shortcut
nnoremap <silent> <leader>oi :OR<CR>

" ----------------------------------------------------------------------------
"  Format on save — per language (only where a formatter is trusted)
" ----------------------------------------------------------------------------
augroup CocFormatOnSave
    autocmd!
    " Rust: rustfmt via coc-rust-analyzer (rust.vim's g:rustfmt_autosave may
    "       double-format — keep only one. Disable rust.vim's if using coc:
    "         let g:rustfmt_autosave = 0
    autocmd BufWritePre *.rs :silent call CocAction('format')

    " Python: black via coc-pyright (requires black in your env)
    autocmd BufWritePre *.py :silent call CocAction('format')

    " Go: gofmt via coc-go
    autocmd BufWritePre *.go :silent call CocAction('format')

    " TypeScript/JavaScript
    autocmd BufWritePre *.ts,*.tsx,*.js,*.jsx :silent call CocAction('format')

    " JSON/YAML
    autocmd BufWritePre *.json,*.yaml,*.yml :silent call CocAction('format')

    " Lua
    autocmd BufWritePre *.lua :silent call CocAction('format')

    " C/C++: clangd via coc-clangd (leave off if you prefer manual formatting)
    " autocmd BufWritePre *.c,*.cpp,*.h,*.hpp :silent call CocAction('format')

    " Java: coc-java has its own formatter — enable if desired
    " autocmd BufWritePre *.java :silent call CocAction('format')

    " PHP: coc-phplang formatting
    autocmd BufWritePre *.php :silent call CocAction('format')
augroup END

" ----------------------------------------------------------------------------
"  Language-specific coc extensions auto-enable check
"  (shows a warning if an extension needed for the current filetype is missing)
" ----------------------------------------------------------------------------
let s:lang_ext_map = {
    \ 'rust':           'coc-rust-analyzer',
    \ 'python':         'coc-pyright',
    \ 'cpp':            'coc-clangd',
    \ 'c':              'coc-clangd',
    \ 'java':           'coc-java',
    \ 'go':             'coc-go',
    \ 'typescript':     'coc-tsserver',
    \ 'javascript':     'coc-tsserver',
    \ 'lua':            'coc-lua',
    \ 'sh':             'coc-sh',
    \ 'json':           'coc-json',
    \ 'yaml':           'coc-yaml',
    \ 'php':            'coc-phplang',
    \ }
function! s:CheckCocExtension() abort
    " Do nothing if coc.nvim is not fully loaded yet
    if !exists('*coc#util#get_extension') || !get(g:, 'coc_service_loaded', 0)
        return
    endif
    let ft = &filetype
    if has_key(s:lang_ext_map, ft)
        let ext = s:lang_ext_map[ft]
        let installed = map(CocAction('extensionStats'), 'v:val.id')
        if index(installed, ext) < 0
            echohl WarningMsg
            echom '[coc] Missing extension for ' . ft . ': :CocInstall ' . ext
            echohl None
        endif
    endif
endfunction
" Only trigger after coc is ready, or defer the check
augroup CocExtensionCheck
    autocmd!
    autocmd User CocNvimReady call s:CheckCocExtension()
    " Also run on FileType but only after coc is ready (the function guards)
    autocmd FileType * call s:CheckCocExtension()
augroup END

" ----------------------------------------------------------------------------
"  CocList — diagnostics, symbols, references
"  NOTE: <leader>ll conflicts with your :LeetCodeList in plugins.vim.
"        Coc lists moved to <leader>L prefix.
" ----------------------------------------------------------------------------
nnoremap <silent> <leader>Ld :CocList diagnostics<CR>   " All diagnostics
nnoremap <silent> <leader>Ll :CocList<CR>               " CocList menu
nnoremap <silent> <leader>Ls :CocList symbols<CR>       " Workspace symbols
nnoremap <silent> <leader>Lr :CocList references<CR>    " References

" Coc extensions manager
nnoremap <leader>ce :CocList extensions<CR>
nnoremap <leader>ci :CocInstall<Space>
nnoremap <leader>cc :CocCommand<CR>

" ----------------------------------------------------------------------------
"  Utility commands
" ----------------------------------------------------------------------------
command! CocConfigEdit      :CocConfig
command! CocLocalConfigEdit :CocLocalConfig
command! CocRestart         :call CocAction('restart')

" ----------------------------------------------------------------------------
"  Status line
" ----------------------------------------------------------------------------
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" ============================================================================
"  CONFLICT RESOLUTION SUMMARY
"  (reference — not executable)
" ============================================================================
"
"  CONFLICT                  YOUR MAPPING           RESOLUTION
"  ─────────────────────────────────────────────────────────────────────────
"  <C-l>  window move        mappings.vim           → snippet jump → <M-l>
"  <leader>ll  LeetCodeList  plugins.vim            → coc lists → <leader>Ll
"  <leader>ls  LeetCodeSub   plugins.vim            → coc list → <leader>Ls
"  <leader>h   FZF History   plugins.vim            → inlay hints → <leader>ih
"  <leader>r   refactor      coc.vim (old)          → renamed <leader>rx
"  <leader>rr  run file      languages.vim          → PRESERVED (not touched)
"  <leader>g   FZF Rg        plugins.vim            → coc gotos use gd/gy/gi/gr
"  K           tabnext       mappings.vim           → RECLAIMED for LSP hover
"                                                     (tabnext still on J/K —
"                                                      K overridden only here)
"
" ============================================================================
