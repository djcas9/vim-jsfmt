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
