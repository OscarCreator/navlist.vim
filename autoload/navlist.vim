
function navlist#toggle() abort

   let s:file = expand("%")

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
    " TODO highlight line, and de-highlight when left
    "autocmd BufLeave <buffer> silent echom "left"

    " TODO check if old buffer id is not visible 
    " then remove that and open a new buffer.
    " removed for backward compatibility
    "autocmd WinClosed <buffer> call navlist#onclose()
   augroup END

   call navlist#store(s:file)
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
        if exists("b:list")
            let s:index = s:line_num - 1
            " check out off bounds
            if len(b:list) > s:index
                let s:position = b:list[s:line_num - 1]
            endif
            let id = bufwinid(b:parent_bufnr)
            " TODO use old cursor position to dermine column
            call win_execute(id, ['call setpos(".", [0, s:position, 1, 1])', 'normal zz', 'redraw'])
        endif
    endif
endfunction

function navlist#store(file) abort
    " TODO show in checkhealth, that this variable is missing
    if !exists("g:navlist_cmd")
        echom "Missing g:navlist_cmd is not set"
        return
    endif

    let s:cmd = join([g:navlist_cmd, " -- ", a:file], "")
    let res = split(system(s:cmd), "\n")

    let b:list = []
    for line in res
        let line = split(line, ':')
        call add(b:list, line[0])

        call append(line('$') - 1, line[1])
    endfor
    " delete last empty line
    d
    setlocal readonly
    
endfunction

function navlist#onclose() abort
    execute "bdelete " .. s:nv_bufnr
    " reset list_display
    let b:list_display = 'off'
endfunction
