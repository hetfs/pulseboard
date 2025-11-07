# ⚡ Setup commands

## 🧩 Local development

Start the FastAPI app with automatic reload:

```bash
uvicorn pulseboard.main:app --reload
````

## 🚀 Production

Run with Gunicorn using Uvicorn workers for optimal performance:

```bash
gunicorn pulseboard.main:app -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:8000
```

---

## 🧪 Running tests

### 🧠 Standard test run

Run all asynchronous tests with detailed output:

```bash
pytest -v --asyncio-mode=auto
```

### 🤖 CI-Friendly Mode

Run tests quietly for continuous integration workflows:

```bash
pytest -q --disable-warnings
```
