# ⚡ PulseBoard setup duide

This section outlines how to **run**, **test**, and **package** the PulseBoard project using modern Python tools.

---

## 🧩 Local development

Start the FastAPI application with **automatic reload** for live code updates:

```bash
uvicorn pulseboard.main:app --reload
```

This will launch the app locally at [http://127.0.0.1:8000](http://127.0.0.1:8000).

---

## 🚀 Production deployment

Run the app in **production mode** using **Gunicorn** with Uvicorn workers for high performance:

```bash
gunicorn pulseboard.main:app \
  -k uvicorn.workers.UvicornWorker \
  --bind 0.0.0.0:8000
```

---

## 🧪 Testing

### 🧠 Standard Test Run

Run all asynchronous tests with verbose output:

```bash
pytest -v --asyncio-mode=auto
```

### 🤖 CI-Friendly Mode

Run tests quietly for continuous integration environments:

```bash
pytest -q --disable-warnings
```

---

## 🧰 Working with virtual environments and modern tools

Install the project and its dependencies directly from `pyproject.toml`:

```bash
pip install .
```

Or install in **editable mode** for active development:

```bash
pip install -e .
```

Both commands use the configuration from your **pyproject.toml** for dependency management and build metadata.

---

## ⚙️ Typical development workflow

1. **Initialize or update** your `pyproject.toml` file

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
