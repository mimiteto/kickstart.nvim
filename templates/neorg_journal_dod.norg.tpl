;; norg
@document.meta
title: {{_lua:os.date("%y/%m/%d")_}}
description: Journal for {{_lua:os.date("%y/%m/%d")_}}
categories: [
    journal
    dod
]
created: {{_lua:os.date("%y/%m/%dT%H:%M:%S")_}}
updated: {{_lua:os.date("%y/%m/%dT%H:%M:%S")_}}
@end

* Shortcuts:
** Notifications
*** Github issues - {https://github.tools.sap/notifications}
*** VO - {https://portal.victorops.com/ui/sap-ti-ce/incidents}
** Live
*** Dashboard - {https://dashboard.garden.live.k8s.ondemand.com/namespace/_all/shoots}
*** Issues filter - {https://github.tools.sap/kubernetes-live/issues-live/issues?q=is%3aissue+is%3aopen+-label%3astatus%2fowner-action++-label%3astatus%2fauthor-action+-label%3astatus%2fexternal-action}
** Canary
*** Dashboard - {https://dashboard.garden.canary.k8s.ondemand.com/namespace/_all/shoots}
*** Issues filter - {https://github.tools.sap/kubernetes-canary/issues-canary/issues?q=is%3aissue+is%3aopen+-label%3astatus%2fowner-action++-label%3astatus%2fauthor-action+-label%3astatus%2fexternal-action}

* Tasks from last working day {:$/journal/{{_prev_working_date_}}:# Leftovers}


* Journal for {{_lua:os.date("%y/%m/%d")_}}


* Leftovers


* Tomorrow {:$/journal/{{_next_working_date_}}}
