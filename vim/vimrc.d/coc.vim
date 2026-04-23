" ============================================================================
"  coc.nvim (Conquer of Completion) - Enhanced Configuration
" ============================================================================

" --- Global settings ---
set nobackup
set nowritebackup
set signcolumn=yes
set updatetime=300

" --- Install these extensions automatically (if missing) ---
" List each item on its own line, no trailing comments inside the list.
let g:coc_global_extensions = [
    \ 'coc-json',
    \ 'coc-tsserver',
    \ 'coc-pyright',
    \ 'coc-java',
    \ 'coc-rust-analyzer',
    \ 'coc-clangd',
    \ 'coc-markdownlint',
    \ 'coc-html',
    \ 'coc-css',
    \ 'coc-snippets',
    \ 'coc-emmet',
    \ 'coc-prettier',
    \ 'coc-eslint',
    \ 'coc-git',
    \ 'coc-explorer',
    \ 'coc-marketplace',
    \ ]

" --- LSP Server Settings ---
let g:coc_user_config = {
    \ 'languageserver': {},
    \ 'suggest.noselect': v:false,
    \ 'suggest.autoTrigger': 'always',
    \ 'suggest.completionItemKindLabels': v:true,
    \ 'diagnostic.displayByAle': v:false,
    \ 'diagnostic.errorSign': '✖',
    \ 'diagnostic.warningSign': '⚠',
    \ 'diagnostic.infoSign': 'ℹ',
    \ 'diagnostic.hintSign': '➤',
    \ 'diagnostic.virtualText': v:true,
    \ 'diagnostic.virtualTextPrefix': ' ',
    \ 'diagnostic.checkCurrentLine': v:true,
    \ 'coc.preferences.formatOnSaveFiletypes': ['javascript', 'typescript', 'json', 'python', 'rust', 'java', 'c', 'cpp'],
    \ 'coc.preferences.jumpCommand': 'tab drop',
    \ 'snippets.ultisnips.directories': ['~/.vim/UltiSnips'],
    \ 'rust-analyzer.cargo.loadOutDirsFromCheck': v:true,
    \ 'rust-analyzer.procMacro.enable': v:true,
    \ 'python.analysis.autoImportCompletions': v:true,
    \ 'python.analysis.typeCheckingMode': 'basic',
    \ 'java.jdt.ls.vmargs': ['-noverify', '-Xmx1G']
    \ }

" --- Completion (Tab / Shift-Tab) ---
inoremap <silent><expr> <TAB>
    \ coc#pum#visible() ? coc#pum#next(1) :
    \ CheckBackspace() ? "\<Tab>" :
    \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~# '\s'
endfunction

" Accept completion with Enter
inoremap <silent><expr> <CR>
    \ coc#pum#visible() ? coc#pum#confirm() :
    \ "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Trigger completion with Ctrl+Space
if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
else
    inoremap <silent><expr> <c-@> coc#refresh()
endif

" --- Snippets (use <C-l> to jump to next placeholder) ---
let g:coc_snippet_next = '<c-l>'
let g:coc_snippet_prev = '<c-h>'

" --- Diagnostics navigation ---
nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)
nnoremap <leader>gl :call CocAction('diagnosticList')<CR>

" --- GoTo navigation ---
nmap <silent><nowait> gd <Plug>(coc-definition)
nmap <silent><nowait> gy <Plug>(coc-type-definition)
nmap <silent><nowait> gi <Plug>(coc-implementation)
nmap <silent><nowait> gr <Plug>(coc-references)

" --- Documentation (hover) ---
nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    else
        execute '!' . &keywordprg . " " . expand('<cword>')
    endif
endfunction

" --- Highlight symbol under cursor ---
autocmd CursorHold * silent call CocActionAsync('highlight')

" --- Rename symbol ---
nmap <leader>rn <Plug>(coc-rename)

" --- Formatting ---
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
nnoremap <leader>F :call CocAction('format')<CR>

" --- Code Actions ---
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>ac <Plug>(coc-codeaction-cursor)
nmap <leader>as <Plug>(coc-codeaction-source)
nmap <leader>qf <Plug>(coc-fix-current)

" --- Refactor ---
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" --- Code Lens ---
nmap <leader>cl <Plug>(coc-codelens-action)

" --- Inlay Hints (toggle) ---
nnoremap <silent> <leader>i :call CocAction('toggleInlayHints')<CR>

" --- Text objects for functions/classes ---
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" --- Scroll float windows ---
if has('nvim-0.4.0') || has('patch-8.2.0750')
    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
    inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
    vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" --- Selection ranges (Ctrl-s) ---
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" --- Useful CocList commands ---
nnoremap <leader>co :CocList<CR>
nnoremap <leader>cl :CocList commands<CR>
nnoremap <leader>cs :CocList services<CR>
nnoremap <leader>ce :CocList extensions<CR>
nnoremap <leader>cr :CocList res<CR>
nnoremap <leader>cw :CocList words<CR>
nnoremap <leader>csy :CocList -I symbols<CR>
nnoremap <leader>cd :CocList diagnostics<CR>

" --- Open coc-explorer (file tree) ---
nnoremap <leader>e :CocCommand explorer<CR>

" --- Status line integration ---
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" --- Commands ---
command! -nargs=0 Format :call CocActionAsync('format')
command! -nargs=? Fold :call CocAction('fold', <f-args>)
command! -nargs=0 OR   :call CocActionAsync('runCommand', 'editor.action.organizeImport')

" --- Optional: Auto-install extensions on first run ---
function! s:check_coc_extensions() abort
    if exists('g:coc_global_extensions') && !exists('g:coc_extensions_checked')
        for ext in g:coc_global_extensions
            if !empty(globpath(&rtp, 'autoload/coc/'.ext.'.vim'))
                continue
            endif
            call coc#util#install_extension(ext)
        endfor
        let g:coc_extensions_checked = 1
    endif
endfunction
augroup CocExtensionsAutoInstall
    autocmd!
    autocmd VimEnter * call s:check_coc_extensions()
augroup END











































































































































































































