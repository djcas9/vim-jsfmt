if !exists("g:js_fmt_commands")
    let g:js_fmt_commands = 1
endif

if !exists("g:js_fmt_command")
  let g:js_fmt_command = "jsfmt"
endif

if !exists('g:js_fmt_autosave')
    let g:js_fmt_autosave = 1
endif

if !exists('g:js_fmt_fail_silently')
    let g:js_fmt_fail_silently = 0
endif

if !exists('g:js_fmt_options')
    let g:js_fmt_options = ''
endif

if g:js_fmt_autosave
    autocmd BufWritePre <buffer> :JSFmt
endif

if g:js_fmt_commands
    command! -buffer JSFmt call s:JSFormat()
endif

let s:got_fmt_error = 0

"  modified and improved version, doesn't undo changes and break undo history
"  - fatih 2014
function! s:JSFormat()
    let l:curw=winsaveview()
    let l:tmpname=tempname()
    call writefile(getline(1,'$'), l:tmpname)

    let command = g:js_fmt_command . ' ' . g:js_fmt_options
    let out = system(command . " " . l:tmpname)

    echomsg v:shell_error

    "if there is no error on the temp file, gofmt our original file
    if v:shell_error == 0
        try | silent undojoin | catch | endtry
        silent execute "%!" . command

        " only clear quickfix if it was previously set, this prevents closing
        " other quickfixs
        if s:got_fmt_error 
            let s:got_fmt_error = 0
            call setqflist([])
            cwindow
        endif
    elseif g:js_fmt_fail_silently == 0 
        echomsg "IN ERROR"
        "otherwise get the errors and put them to quickfix window
        let errors = []
        " stdin { [Error: Line 3: Unexpected token ILLEGAL] index: 31,
        " lineNumber: 3, column: 11 }
        for line in split(out, '\n')
            let tokens = matchlist(line, '^\(.\{-}\):\(\d\+\):\(\d\+\)\s*\(.*\)')
            if !empty(tokens)
                call add(errors, {"filename": @%,
                                 \"lnum":     tokens[2],
                                 \"col":      tokens[3],
                                 \"text":     tokens[4]})
            endif
        endfor
        if empty(errors)
            % | " Couldn't detect gofmt error format, output errors
        endif
        if !empty(errors)
            call setqflist(errors, 'r')
            echohl Error | echomsg "jsfmt returned error" | echohl None
        endif
        let s:got_fmt_error = 1
        cwindow
    endif

    call delete(l:tmpname)
    call winrestview(l:curw)
endfunction

let b:did_ftplugin_js_fmt = 1

" vim:ts=4:sw=4:et
