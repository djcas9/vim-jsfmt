# vim-jsfmt

vim-jsfmt is a vim plugin for the formatiting tool [`jsfmt`](https://github.com/rdio/jsfmt). vim-jsfmt is based on the 
go-fmt vimscript that ships with the [`vim-go`](https://github.com/fatih/vim-go) plugin.

## Installation

** Note: You have to have jsfmt install for this to work. `npm install -g jsfmt` >= version 0.5.3

[Download zip file](https://github.com/mephux/vim-jsfmt/archive/master.zip):

To install using [Vundle](https://github.com/gmarik/Vundle.vim):

    " add this line to your .vimrc file
    Plugin 'mephux/vim-jsfmt'

To install using [pathogen.vim](https://github.com/tpope/vim-pathogen):

    cd ~/.vim/bundle
    git clone https://github.com/mephux/vim-jsfmt.git

To checkout the source from repository:

    cd ~/.vim/bundle
    git clone https://github.com/mephux/vim-jsfmt.git

# Settings

By default vim-jsfmt shows errors for the jsfmt command, to disable it:

```vim
let g:js_fmt_fail_silently = 1
```

Enable auto fmt on save:

```vim
let g:js_fmt_autosave = 1
```

Set the command to use for formating.

```vim
let g:js_fmt_command = "jsfmt"
```

Configure jsfmt cli options.

```vim
let g:js_fmt_options = '--no-format'
```

## Self-Promotion

Like vim-jsfmt.vim? Follow the repository on
[GitHub](https://github.com/mephux/vim-jsfmt) and if
you would like to stalk me, follow [mephux](http://dweb.io/) on
[Twitter](http://twitter.com/mephux) and
[GitHub](https://github.com/mephux).
