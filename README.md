# navlist.vim
Shows a filtered list of item for a vim buffer.

![navlist_demo](https://user-images.githubusercontent.com/53407525/216776258-1da050f0-7594-48b7-bfec-94cb01167757.gif)

## Installation

Using [packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use('OscarCreator/navlist.vim')
```

## Usage

navlist.vim uses the global variable `g:navlist_cmd` which have to return a list of line numbers and text seperated with `:`.

### Example

This example will show a list of all vimscript function names in the current buffer.

Using vimscript:
```viml
let g:navlist_cmd = "grep -oPhn 'function \\K[^()]+'"
```

Using lua:
```lua
vim.api.nvim_set_var("navlist_cmd", "grep -oPhn 'function \\K[^()]+'")
```

Output:
```
3:navlist#toggle
57:navlist#moved
75:navlist#store
93:navlist#onclose
```



