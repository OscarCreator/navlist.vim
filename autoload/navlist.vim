

function navlist#toggle() abort

   if &ft == "navlist"
       bdelete
       " TODO change too use buffer reference
       let b:list_display = 'off'
       return
   endif

   if !exists("b:list_display")
       let b:list_display = 'off'
   endif

   if b:list_display == 'on'
       let b:list_display = 'off'
       execute "bdelete " .. b:nv_bufnr
       return
   endif

   let s:bufnr = bufnr("%")
   let b:list_display = 'on'

   noswapfile hide vnew
   setlocal buftype=nofile
   setlocal bufhidden=hide
   setlocal filetype=navlist
   file "[Scratch]"
   
   let s:nv_bufnr = bufnr("%")
   let b:parent_bufnr = s:bufnr

   augroup NList
    autocmd!
    autocmd CursorMoved <buffer> call navlist#moved(s:nv_bufnr)
    autocmd BufLeave <buffer> silent echom "left"

    
   augroup END

   if &splitright
       wincmd h
   else
       wincmd l
   endif

   let b:nv_bufnr = s:nv_bufnr
    
endfunction

function navlist#moved(bufnr) abort
    let s:line_num = line('.')
    if !exists("b:prev_line")
        let b:prev_line = -1
    endif

    if s:line_num != b:prev_line
    
        let id = bufwinid(b:parent_bufnr)
        call win_execute(id, ['call setpos(".", [0, s:line_num, 1, 1])', 'redraw'])
    endif
endfunction
