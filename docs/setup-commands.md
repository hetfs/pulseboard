# ⚡ PulseBoard Setup Guide

This section outlines how to **run**, **test**, **package**, and **set up the environment** for the PulseBoard project using modern Python tools.

---

## 🐍 Environment Setup

Create a virtual environment using **Python 3.14**:

```bash
python3.14 -m venv .venv
```

Activate the virtual environment:

```bash
# Linux/macOS
source .venv/bin/activate

# Windows (PowerShell)
.venv\Scripts\Activate.ps1
```

Upgrade `pip` and core build tools:

```bash
pip install --upgrade pip setuptools wheel
```

Install production dependencies:

```bash
pip install .
```

Install development dependencies (for testing, linting, type-checking):

```bash
pip install -e .[dev]
```

---

## 🧩 Local Development

Start the FastAPI application with **automatic reload**:

```bash
uvicorn pulseboard.main:app --reload
```

Access the app at [http://127.0.0.1:8000](http://127.0.0.1:8000).

---

## 🚀 Production Deployment

Run the app in **production mode** using **Gunicorn** with Uvicorn workers:

```bash
gunicorn pulseboard.main:app \
  -k uvicorn.workers.UvicornWorker \
  --bind 0.0.0.0:8000
```

---

## 🧪 Testing

### 🧠 Standard Test Run

Run all asynchronous tests with detailed output:

```bash
pytest -v --asyncio-mode=auto
```

### 🤖 CI-Friendly Mode

Run tests quietly for continuous integration pipelines:

```bash
pytest -q --disable-warnings
```

### 📊 Coverage Reporting

Generate a coverage report (terminal + HTML):

```bash
pytest --cov=src/pulseboard --cov-report=term-missing --cov-report=html
```

The HTML report will be available under `htmlcov/`.

---

## 🧰 Working with Virtual Environments and Modern Tools

Install the project and dependencies directly from `pyproject.toml`:

```bash
pip install .
```

Or install in **editable mode** for active development:

```bash
pip install -e .
```

Both commands automatically read your **pyproject.toml** for dependency and build configuration.

---

## ⚙️ Typical Development Workflow

1. **Initialize or update** your `pyproject.toml`.

2. **Build the package** for distribution:

   ```bash
   python -m build
   ```

3. **(Optional) Publish to PyPI**:

   ```bash
   twine upload dist/*
   ```

4. **Run the application locally**:

   ```bash
   uvicorn pulseboard.main:app --reload
   ```

5. **Run tests** and check coverage:

   ```bash
   pytest --cov=src/pulseboard --cov-report=html
   ```
