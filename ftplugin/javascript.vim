if !exists("g:js_fmt_commands")
    let g:js_fmt_commands = 1
endif

if !exists("g:js_fmt_command")
  let g:js_fmt_command = "jsfmt"
endif

if !exists('g:js_fmt_autosave')
    let g:js_fmt_autosave = 0
endif

if !exists('g:js_fmt_version')
    let g:js_fmt_version = "0.5.3"
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

  if (&ft=='json')
    let g:js_fmt_options = '--json'
  endif

  let l:curw=winsaveview()
  let l:tmpname=tempname()

  call writefile(getline(1,'$'), l:tmpname)

  " version test
  let versionCommand = g:js_fmt_command . ' --version' 
  let versionTest = system(versionCommand . " " . l:tmpname)

  if !empty(matchstr(versionTest, 'jsfmt: command not found'))
    echohl Error
    echomsg "jsfmt not found. Please install jsfmt first."
    echomsg "npm install -g jsfmt"
    echohl None
    " !
    return
  endif

  if matchstr(versionTest, '\d.\d.\d') < g:js_fmt_version
    echohl Error
    echomsg "vim-jsfmt required jsfmt version " . g:js_fmt_version . " or greater."
    echomsg "npm install -g jsfmt"
    echomsg "Your current version is: " . versionTest
    echohl None
    " !
    return
  endif

  let command = g:js_fmt_command . ' ' . g:js_fmt_options
  let out = system(command . " " . l:tmpname)

  let errors = []

  " < 0.5.2
  " let patternOld = '{ \[Error: Line \(\d\+\): \(.\+\)\] index: \(\d\+\), lineNumber: \(\d\+\), column: \(\d\+\) }'

  " >= 0.5.2
  let pattern = '{ \[Error: Line \(\d\+\): \(.\+\)\]\n\s\sindex: \(\d\+\),\n\s\slineNumber: \(\d\+\),\n\s\scolumn: \(\d\+\),\n\s\sdescription: \(.\+\) }' 

  let tokens = matchlist(out, pattern)

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

    " only clear quickfix if it was previously set, this prevents closing
    " other quickfixs
    if s:got_fmt_error
      let s:got_fmt_error = 0
      call setqflist([])
      cwindow
    endif
  endif

  if !empty(errors) && !g:js_fmt_fail_silently
    call setqflist(errors, 'r')
    " echohl Error | echomsg "jsfmt returned error" | echohl None

      let s:got_fmt_error = 1
      cwindow
  endif

  call delete(l:tmpname)
  call winrestview(l:curw)

endfunction

let b:did_ftplugin_js_fmt = 1

" vim:ts=4:sw=4:et
