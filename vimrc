" Source all files in vimrc.d/
for f in split(glob('~/.vim/vimrc.d/*.vim'), '\n')
    execute 'source' f
endfor

" Also source system files if needed
runtime! debian.vim
if filereadable("/etc/vim/vimrc.local")
    source /etc/vim/vimrc.local
endif
