;; norg
@document.meta
title: {{_variable_}}
description: {{_variable_}}
categories: [
	{{_variable_}}
]
created: {{_lua:os.date("!%Y-%m-%dT%H:%M:%S") .. os.date("%z")_}}
updated: {{_lua:os.date("!%Y-%m-%dT%H:%M:%S") .. os.date("%z")_}}
@end
* {{_dirname_}}

** Items

{{_norg_linkified_dir_content_}}

{{_cursor_}}
