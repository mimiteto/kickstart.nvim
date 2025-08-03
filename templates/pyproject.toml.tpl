;; toml
[build-system]
requires = ["setuptools>=61.0", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "{{_lua:vim.fn.input("Package name: ")_}}"
version = "0.1.0"
description = "_lua:vim.fn.input("Description: ")_"
readme = "README.md"
requires-python = ">=3.12"
authors = [
    {name = "Dimitar Ivanov", email = "mimiteto@gmail.com"}
]
keywords = [_lua:vim.fn.input("KWs, comma separated strings: ")_]
classifiers = [
    "Development Status :: 3 - Alpha",
    "Intended Audience :: Developers",
    "License :: OSI Approved :: MIT License",
    "Programming Language :: Python :: 3.12",
]

dependencies = [
    "pyyaml>=6.0.2",
    "pydantic"
]

[project.optional-dependencies]
dev = [
    "pytest",
    "pytest-mock",
    "pytest-subtests",
    "pytest-cov",
    "flake8",
    "black",
    "mypy",
    "coverage",
    "isort",
    "pylint"
]

[project.scripts]
{{_cursor_}} = "package:funcname"

[tool.setuptools]
package-dir = {"" = "src"}

[tool.setuptools.packages.find]
where = ["src"]

# Equivalent to old setup.cfg sections
[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "-v"

[tool.mypy]
check_untyped_defs = true
