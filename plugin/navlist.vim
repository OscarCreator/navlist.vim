
if exists('g:loaded_navlist')
    finish
endif
let g:loaded_navlist = 1

command! NList :call navlist#toggle()

