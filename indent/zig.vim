" indent/zig.vim

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

if (!has("cindent") || !has("eval"))
    finish
endif

setlocal cindent

" L0 -> 0 indent for jump labels (i.e. case statement in c).
" j1 -> indenting for "javascript object declarations"
" J1 -> see j1
" w1 -> starting a new line with `(` at the same indent as `(`
" m1 -> if `)` starts a line, match its indent with the first char of its
"       matching `(` line
" (s -> use one indent, when starting a new line after a trailing `(`
setlocal cinoptions=L0,m1,(s,j1,J1,l1

" cinkeys: controls what keys trigger indent formatting
" 0{ -> {
" 0} -> }
" 0) -> )
" 0] -> ]
" !^F -> make CTRL-F (^F) reindent the current line when typed
" o -> when <CR> or `o` is used
" O -> when the `O` command is used
setlocal cinkeys=0{,0},0),0],!^F,o,O

setlocal indentexpr=GetZigIndent(v:lnum)

let b:undo_indent = "setlocal cindent< cinkeys< cinoptions< indentexpr<"

function! GetZigIndent(lnum)
    let curretLineNum = a:lnum
    let currentLine = getline(a:lnum)

    " cindent doesn't handle multi-line strings properly, so force no indent
    if currentLine =~ '^\s*\\\\.*'
        return -1
    endif

    let prevLineNum = prevnonblank(a:lnum-1)
    let prevLine = getline(prevLineNum)

    return cindent(a:lnum)
endfunction
