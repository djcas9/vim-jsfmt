if !exists("g:js_fmt_commands")
    let g:js_fmt_commands = 1
endif

if !exists("g:js_fmt_command")
  let g:js_fmt_command = "jsfmt"
endif

if !exists('g:js_fmt_autosave')
    let g:js_fmt_autosave = 0
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

function! s:JSFormat()
    let l:curw=winsaveview()
    let l:tmpname=tempname()
    call writefile(getline(1,'$'), l:tmpname)

    let command = g:js_fmt_command . ' ' . g:js_fmt_options
    let out = system(command . " " . l:tmpname)

    let errors = []

    let tokens = matchlist(out, '{ [Error: Line \(\d\+\): \(.\+\)\] index: \(\d\+\), lineNumber: \(\d\+\), column: \(\d\+\) }')

    if !empty(tokens)
      call add(errors, {"filename": @%,
            \"lnum":     tokens[1],
            \"col":      tokens[5],
            \"text":     tokens[2]})
    endif

    if empty(errors)
      " NO ERROR
      try | silent undojoin | catch | endtry
      silent execute "%!" . command
      $delete
      " only clear quickfix if it was previously set, this prevents closing
      " other quickfixs
      if s:got_fmt_error 
        let s:got_fmt_error = 0
        call setqflist([])
        cwindow
      endif
    endif

    if !empty(errors)
      call setqflist(errors, 'r')
      echohl Error | echomsg "jsfmt returned error" | echohl None
    endif

    let s:got_fmt_error = 1
    cwindow

    call delete(l:tmpname)
    call winrestview(l:curw)
  endfunction

let b:did_ftplugin_js_fmt = 1

" vim:ts=4:sw=4:et
