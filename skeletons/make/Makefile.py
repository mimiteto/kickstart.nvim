PYTHON := python3
VENV_DIR := .venv
VENV_BIN := $(VENV_DIR)/bin
APP := ${dirname}
PROJECT_DIR := src/$(APP)

help:
	@echo "Available commands:"
	@echo "  make install             - Install dependencies in a virtual environment"
	@echo "  make dev-install         - Install package in development mode"
	@echo "  make clean               - Remove build artifacts and cache files"
	@echo "  make test                - Run tests"
	@echo "  make lint                - Run linting checks"
	@echo "  make format              - Format code using black and isort"
	@echo "  make build               - Build distribution packages"
	@echo "  make run-k8s-file        - Run the package about k8s versions"
	@echo "  make run-gh-releases     - Run the package about GitHub releases"
	@echo "  make run-k8s-resources   - Run the package about k8s resources"

$(VENV_DIR):
	$(PYTHON) -m venv $(VENV_DIR)
	$(VENV_BIN)/pip install --upgrade pip setuptools wheel

install: $(VENV_DIR)
	$(VENV_BIN)/pip install -e ".[dev]"

dev-install: install

clean:
	rm -rf build/
	rm -rf dist/
	rm -rf src/*.egg-info/
	rm -rf .pytest_cache/
	rm -rf .coverage
	rm -rf htmlcov/
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	find . -type f -name "*.pyo" -delete
	find . -type f -name "*.pyd" -delete

test:
	$(VENV_BIN)/pytest tests/ -v --cov=$(APP)

lint:
	$(VENV_BIN)/flake8 src/$(APP) tests
	$(VENV_BIN)/mypy src/$(APP)
	$(VENV_BIN)/pylint src/$(APP)

format:
	$(VENV_BIN)/black src/$(APP) tests
	$(VENV_BIN)/isort src/$(APP) tests

build: clean
	$(VENV_BIN)/python -m build
