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
  s('k-role', {
    t {
      'apiVersion: rbac.authorization.k8s.io/v1',
      'kind: Role',
      'metadata:',
      '  namespace: ',
    },
    i(1, 'default'),
    t {
      '',
      '  name: ',
    },
    i(2, 'my-role'),
    t {
      '',
      'rules:',
      '- apiGroups: ["',
    },
    i(3, '"'),
    t {
      '"]',
      '',
      '  resources: ["',
    },
    i(4, 'pods'),
    t {
      '"]',
      '  verbs: ["',
    },
    i(5, 'get'),
    t {
      '", "',
    },
    i(6, 'list'),
    t {
      '"]',
    },
    t { '', '' },
  }),
  s('k-clusterrole', {
    t {
      'apiVersion: rbac.authorization.k8s.io/v1',
      'kind: ClusterRole',
      'metadata:',
      '  name: ',
    },
    i(1, 'my-clusterrole'),
    t {
      'rules:',
      '- apiGroups: ["',
    },
    i(2, '"'),
    t {
      '  resources: ["',
    },
    i(3, 'nodes'),
    t {
      '"]',
      '  verbs: ["',
    },
    i(4, 'get'),
    t {
      '", "',
    },
    i(5, 'list'),
    t {
      '"]',
    },
    t { '', '' },
  }),
  s('k-rolebinding', {
    t {
      'apiVersion: rbac.authorization.k8s.io/v1',
      'kind: RoleBinding',
      'metadata:',
      '  namespace: ',
    },
    i(1, 'default'),
    t {
      '  name: ',
    },
    i(2, 'my-rolebinding'),
    t {
      'subjects:',
      '- kind: ',
    },
    i(3, 'User'),
    t {
      '  name: ',
    },
    i(4, 'jane'),
    t {
      '  apiGroup: rbac.authorization.k8s.io',
      'roleRef:',
      '  kind: Role',
      '  name: ',
    },
    i(5, 'my-role'),
    t {
      '  apiGroup: rbac.authorization.k8s.io',
    },
    t { '', '' },
  }),
  s('k-clusterrolebinding', {
    t {
      'apiVersion: rbac.authorization.k8s.io/v1',
      'kind: ClusterRoleBinding',
      'metadata:',
      '  name: ',
    },
    i(1, 'my-clusterrolebinding'),
    t {
      'subjects:',
      '- kind: ',
    },
    i(2, 'User'),
    t {
      '  name: ',
    },
    i(3, 'jane'),
    t {
      '  apiGroup: rbac.authorization.k8s.io',
      'roleRef:',
      '  kind: ClusterRole',
      '  name: ',
    },
    i(4, 'my-clusterrole'),
    t {
      '  apiGroup: rbac.authorization.k8s.io',
    },
    t { '', '' },
  }),
}
