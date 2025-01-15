filetype plugin on

augroup TextSettings
    autocmd!

    autocmd FileType markdown,rst,text set wrap linebreak
augroup END

" Copy the relative path + row number to the clipboard
function! CopyRelativePath(linenumber)
    if a:linenumber
        echom 'Copied relative path to clipboard (with line number)'
        let @+ = @% . ':' . line('.')
    else
        echom 'Copied relative path to clipboard'
        let @+ = @%
    endif
endfunction
