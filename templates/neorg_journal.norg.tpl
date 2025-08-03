;; norg
@document.meta
title: {{_lua:os.date("%y/%m/%d")_}}
description: Journal for {{_lua:os.date("%y/%m/%d")_}}
categories: [
    journal
    {{_lua:vim.fn.input("Categories: ")_}}
]
created: {{_lua:os.date("%y/%m/%dT%H:%M:%S")_}}
updated: {{_lua:os.date("%y/%m/%dT%H:%M:%S")_}}
@end

* Tasks from last working day {:$/journal/{{_prev_working_date_}}:# Leftovers}


* Journal for {{_lua:os.date("%y/%m/%d")_}}


* Leftovers


* Tomorrow {:$/journal/{{_next_working_date_}}:}
