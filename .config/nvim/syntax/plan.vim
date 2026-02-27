if exists("b:current_syntax")
  finish
endif

" ----- Keywords -----
syntax match planDirective /^@\w\+/
syntax match planDate /@Date(\d\{4}-\d\{2}-\d\{2})/
syntax match planProject /@Project([^)]*)/
syntax match planDateFmt /@Datefmt([^)]*)/
syntax match planExplain /@explain([^)]*)/

" ----- Task markers -----
syntax match planDone   /^\s*\+\s.*$/
syntax match planTodo   /^\s*-\s.*$/
syntax match planIgnore /^\s*~\s.*$/
syntax match planStart  /^\s*!\s.*$/

" ----- Blocks -----
syntax region planBlock start="{" end="}" contains=ALL keepend

" ----- Inline code -----
syntax region planCode start="`" end="`"

" ----- Comments (optional) -----
syntax match planComment /^\s*#.*/

" ----- Highlight links -----
highlight default link planDirective Keyword
highlight default link planDate Special
highlight default link planProject Identifier
highlight default link planDateFmt Identifier
highlight default link planExplain Identifier

highlight default link planDone   DiffAdd
highlight default link planTodo   DiffDelete
highlight default link planIgnore Comment
highlight default link planStart  WarningMsg

highlight default link planBlock  Statement
highlight default link planCode   String
highlight default link planComment Comment

let b:current_syntax = "plan"
