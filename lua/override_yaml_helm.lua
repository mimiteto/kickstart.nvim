local utils = {}

-- Function to check if the file is part of a Helm chart
function is_helm_file(path)
  local check = vim.fs.find("Chart.yaml", { path = vim.fs.dirname(path), upward = true })
  return not vim.tbl_isempty(check)
end

-- Function to determine the filetype for YAML files
function utils.yaml_filetype(path, bufname)
  return is_helm_file(path) and "helm.yaml" or "yaml"
end

-- Function to determine the filetype for template files
function utils.tmpl_filetype(path, bufname)
  return is_helm_file(path) and "helm.tmpl" or "template"
end

-- Function to determine the filetype for tpl files
function utils.tpl_filetype(path, bufname)
  return is_helm_file(path) and "helm.tmpl" or "smarty"
end

-- Add custom filetype detection
vim.filetype.add({
  extension = {
    yaml = utils.yaml_filetype,
    yml = utils.yaml_filetype,
    tmpl = utils.tmpl_filetype,
    tpl = utils.tpl_filetype
  },
  filename = {
    ["Chart.yaml"] = "yaml",
    ["Chart.lock"] = "yaml",
  }
})
