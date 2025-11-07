# ⚡ Pulseboard

**Pulseboard** is a **real-time distributed system monitoring dashboard** built with **Bokeh**, **FastAPI**, and **WebSockets**.
It visualizes live system metrics—CPU, memory, network, and disk—across multiple machines.
Designed for developers, DevOps engineers, and data teams, it provides instant insights into system performance.

---

## 🚀 Features

* **Live system metrics** powered by Bokeh and WebSockets
* **FastAPI backend** with streaming endpoints
* **Interactive dashboards** with real-time updates
* **Multi-server monitoring** support *(agents coming soon)*
* **Extensible plugin architecture** for custom metrics and alerts
* **Cross-platform compatibility** across Linux, macOS, and Windows
* **Production-ready** layout with CI/CD and Docker support

---

## 📦 Installation (PyPI-ready)

Once published to [PyPI](https://pypi.org/), you’ll be able to install Pulseboard directly:

```bash
pip install pulseboard
```

To run the dashboard after installation:

```bash
pulseboard run
```

If you’re installing from source for development:

```bash
git clone git@github.com:hetfs/pulseboard.git
cd pulseboard
pip install -e ".[dev]"
```

This installs all development and testing dependencies.

---

## ⚙️ Setup

### 1. Clone the repository

```bash
git clone git@github.com:hetfs/pulseboard.git
cd pulseboard
```

### 2. Run the setup script

The setup script creates a virtual environment, installs dependencies, and launches the dashboard.

```bash
chmod +x setup.sh
./setup.sh
```

It automatically performs:

* Python 3.14 environment validation
* Virtual environment creation (`.venv/`)
* Dependency installation from `requirements.txt`
* Starts the dashboard at [http://localhost:5006](http://localhost:5006)

---

### 3. Manual setup (alternative)

You can also configure Pulseboard manually:

```bash
python3.14 -m venv .venv
source .venv/bin/activate    # Linux/macOS
# or
.venv\Scripts\activate       # Windows

pip install -r requirements.txt
python app/main.py
```

---

## 🌍 Distributed Mode *(coming soon)*

The upcoming **distributed mode** allows Pulseboard to monitor multiple remote systems securely.
You’ll be able to:

* Deploy lightweight agents on remote machines
* Stream metrics to a central Pulseboard instance via WebSockets or REST
* Compare distributed workloads in real time

Stay tuned for upcoming releases.

---

## 🧪 Testing

Run all test suites:

```bash
pytest tests/
```

This verifies the functionality of metric collection, streaming, and visualization modules.

---

## 🧭 Roadmap

* [ ] WebSocket-based distributed monitoring agents
* [ ] Authentication and role-based access
* [ ] Custom alerts and logging
* [ ] Docker and Docker Compose deployment
* [ ] CI/CD integration (GitHub Actions, GitLab CI)
* [ ] Prometheus and Grafana exporters
* [ ] GPU and AI workload monitoring

---

## 🧑‍💻 Contributing

Contributions are welcome!

To get started:

```bash
git checkout -b feature/your-feature
git commit -m "Add your feature"
git push origin feature/your-feature
```

Then open a **Pull Request** on GitHub.

Before submitting:

* Ensure `black` or `ruff` passes
* Run all `pytest` suites successfully

---

## 📜 License

**MIT License** © 2025 — *hetfs / Pulseboard*
