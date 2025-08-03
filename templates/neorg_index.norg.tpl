;; norg
@document.meta
title: {{_lua:vim.fn.input("Title: ")_}}
description: {{_lua:vim.fn.input("Desc: ")_}}
categories: [
	{{_lua:vim.fn.input("Categories: ")_}}
]
created: {{_lua:os.date("!%Y-%m-%dT%H:%M:%S") .. os.date("%z")_}}
updated: {{_lua:os.date("!%Y-%m-%dT%H:%M:%S") .. os.date("%z")_}}
@end
* {{_dirname_}}

** Items

{{_norg_linkified_dir_content_}}

{{_cursor_}}
