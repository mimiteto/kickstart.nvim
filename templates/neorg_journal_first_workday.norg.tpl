;; norg
@document.meta
title: {{_lua:os.date("%y/%m/%d")_}}
description: Journal for {{_lua:os.date("%y/%m/%d")_}}
categories: [
    journal
    {{_variable_}}
]
created: {{_lua:os.date("%y/%m/%dT%H:%M:%S")_}}
updated: {{_lua:os.date("%y/%m/%dT%H:%M:%S")_}}
@end

* Tasks from last working day {:$/journal/{{_prev_working_date_}}:# Leftovers}


* Journal for {{_lua:os.date("%y/%m/%d")_}}
** ToDos:
- ( ) "Look at the graphs" event for AWS Route53 quota and rate limits
Canary - {https://gardener-live.accounts.ondemand.com/saml2/idp/sso?sp=iaas-aws-canary} (Acc - 220986883970)
Live - {https://gardener-live.accounts.ondemand.com/saml2/idp/sso?sp=iaas-aws-live} (Acc - 301167567572)
Relevant link -  {https://eu-central-1.console.aws.amazon.com/cloudwatch/home?region=eu-central-1#dashboards/dashboard/gardener-api-dashboard}
~ ( ) {:$/tasks/compliance-reporting.norg:}
- ( ) {https://github.com/gardener/hyperkube}[Check hyperkube]


* Leftovers


* Tomorrow {:$/journal/{{_next_working_date_}}:}
