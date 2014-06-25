# vim-jsfmt

vim-jsfmt is a vim plugin for the formatiting tool [`jsfmt`](https://github.com/rdio/jsfmt). vim-jsfmt is based on the 
go-fmt vimscript that ships with the [`vim-go`](https://github.com/fatih/vim-go) plugin.

# Settings

By default vim-jsfmt shows errors for the jsfmt command, to disable it:

```vim
let g:js_fmt_fail_silently = 1
```

Disable auto fmt on save:

```vim
let g:js_fmt_autosave = 0
```

Set the command to use for formating.

```vim
let g:js_fmt_command = "jsfmt"
```

Configure jsfmt cli options.

```vim
let g:js_fmt_options = '--no-format'
```
