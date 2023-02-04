
if exists('g:loaded_navlist')
    finish
endif
let g:loaded_navlist = 1

let g:navlist_cmd = ""

command NList :call navlist#toggle()

