local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s('k-kustom', {
    t {
      'apiVersion: kustomize.config.k8s.io/v1beta1',
      'kind: Kustomization',
      '',
      'resources:',
      '  - ',
    },
    i(1, 'deployment.yaml'),
    t {
      '',
      '',
      'images:',
      '  - name: ',
    },
    i(2, 'my-image'),
    t {
      '',
      '    newTag: ',
    },
    i(3, 'latest'),
    t {
      '',
      '',
      'patches:',
      '  - path: ',
    },
    i(4, 'patch.yaml'),
    t { '', '' },
  }),
  s('f-kustom', {
    t {
      'apiVersion: kustomize.toolkit.fluxcd.io/v1',
      'kind: Kustomization',
      'metadata:',
      '  name: ',
    },
    i(1, 'my-app'),
    t {
      '  namespace: ',
    },
    i(2, 'default'),
    t {
      'spec:',
      '  interval: ',
    },
    i(3, '1m'),
    t {
      '  path: ',
    },
    i(4, './deploy'),
    t {
      '  prune: ',
    },
    i(5, 'true'),
    t {
      '  sourceRef:',
      '    kind: GitRepository',
      '    name: ',
    },
    i(6, 'my-repo'),
    t { '', '' },
  }),
  s('f-helm', {
    t {
      'apiVersion: helm.toolkit.fluxcd.io/v2',
      'kind: HelmRelease',
      'metadata:',
      '  name: ',
    },
    i(1, 'my-chart'),
    t {
      '  namespace: ',
    },
    i(2, 'default'),
    t {
      'spec:',
      '  interval: ',
    },
    i(3, '1m'),
    t {
      '  chart:',
      '    spec:',
      '      chart: ',
    },
    i(4, 'chart-name'),
    t {
      '      version: ',
    },
    i(5, '1.0.0'),
    t {
      '      sourceRef:',
      '        kind: HelmRepository',
      '        name: ',
    },
    i(6, 'my-helmrepo'),
    t {
      '  values:',
      '    ',
    },
    i(7, '# your values here'),
    t { '', '' },
  }),
  s('f-git', {
    t {
      'apiVersion: source.toolkit.fluxcd.io/v1',
      'kind: GitRepository',
      'metadata:',
      '  name: ',
    },
    i(1, 'my-repo'),
    t {
      '  namespace: ',
    },
    i(2, 'default'),
    t {
      'spec:',
      '  interval: ',
    },
    i(3, '1m'),
    t {
      '  url: ',
    },
    i(4, 'https://github.com/example/repo'),
    t {
      '  ref:',
      '    branch: ',
    },
    i(5, 'main'),
    t { '', '' },
  }),
}
