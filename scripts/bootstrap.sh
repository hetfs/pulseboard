#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------
# 🚀 PulseBoard Bootstrap Script
# ------------------------------------------------------
# Runs from any directory (e.g., ./scripts/bootstrap.sh)
# Automatically installs Python 3.14 if missing,
# sets up virtual environment in project root,
# installs dependencies and optional dev tools,
# ready for development or CI pipelines.
# ------------------------------------------------------

PYTHON_BIN="python3.14"
VENV_DIR=".venv"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo ""
echo "🧩 Starting PulseBoard environment setup..."
echo "--------------------------------------------"
echo "📁 Script directory: ${SCRIPT_DIR}"
echo "📂 Project root: ${PROJECT_ROOT}"

# ------------------------------------------------------
# 🧠 Check and Install Python 3.14
# ------------------------------------------------------
if ! command -v "${PYTHON_BIN}" &>/dev/null; then
        echo "⚠️  ${PYTHON_BIN} not found on your system."
        echo "🚀 Attempting to install Python 3.14..."

        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                if command -v apt &>/dev/null; then
                        sudo apt update -y && sudo apt install -y python3.14 python3.14-venv python3.14-dev
                elif command -v dnf &>/dev/null; then
                        sudo dnf install -y python3.14 python3.14-venv python3.14-devel
                elif command -v pacman &>/dev/null; then
                        sudo pacman -Sy --noconfirm python3.14
                else
                        echo "❌ Unsupported Linux package manager. Please install Python 3.14 manually."
                        echo "👉 https://www.python.org/downloads/"
                        exit 1
                fi
        elif [[ "$OSTYPE" == "darwin"* ]]; then
                if command -v brew &>/dev/null; then
                        brew install python@3.14
                else
                        echo "❌ Homebrew not found. Please install it or download Python 3.14 manually."
                        echo "👉 https://www.python.org/downloads/macos/"
                        exit 1
                fi
        else
                echo "❌ Unsupported platform: ${OSTYPE}"
                echo "👉 Please install Python 3.14 manually from https://www.python.org/downloads/"
                exit 1
        fi

        if ! command -v "${PYTHON_BIN}" &>/dev/null; then
                echo "❌ Installation failed or Python 3.14 not available in PATH."
                exit 1
        fi

        echo "✅ ${PYTHON_BIN} successfully installed!"
else
        echo "✅ Found ${PYTHON_BIN}: $(${PYTHON_BIN} --version)"
fi

# ------------------------------------------------------
# 🧰 Create and Activate Virtual Environment
# ------------------------------------------------------
echo ""
cd "${PROJECT_ROOT}"

echo "📦 Setting up virtual environment in ${PROJECT_ROOT}/${VENV_DIR} ..."
if [[ ! -d "${VENV_DIR}" ]]; then
        "${PYTHON_BIN}" -m venv "${VENV_DIR}"
        echo "✅ Virtual environment created."
else
        echo "🔁 Virtual environment already exists."
fi

# shellcheck disable=SC1091
source "${VENV_DIR}/bin/activate"

echo "🐍 Using Python: $(python --version)"
echo "📁 Virtual env: $(which python)"

# ------------------------------------------------------
# 🧱 Upgrade pip and essential build tools
# ------------------------------------------------------
echo ""
echo "⬆️ Upgrading pip, setuptools, and wheel..."
pip install --upgrade pip setuptools wheel build twine

# ------------------------------------------------------
# 📦 Install dependencies
# ------------------------------------------------------
echo ""
echo "📦 Installing production dependencies..."
if [[ -f "${PROJECT_ROOT}/requirements.txt" ]]; then
        pip install -r "${PROJECT_ROOT}/requirements.txt"
elif [[ -f "${PROJECT_ROOT}/pyproject.toml" ]]; then
        pip install "${PROJECT_ROOT}"
else
        echo "⚠️  No requirements.txt or pyproject.toml found in ${PROJECT_ROOT} — skipping."
fi

# ------------------------------------------------------
# 🧰 Install optional development dependencies
# ------------------------------------------------------
if [[ -f "${PROJECT_ROOT}/pyproject.toml" ]]; then
        echo "🧪 Installing development dependencies..."
        pip install -e .[dev] || echo "⚠️ Dev dependencies installation failed or already satisfied."
fi

# ------------------------------------------------------
# 🧾 Load environment variables (if .env exists)
# ------------------------------------------------------
if [[ -f "${PROJECT_ROOT}/.env" ]]; then
        echo "📝 Loading environment variables from .env..."
        export $(grep -v '^#' .env | xargs)
fi

# ------------------------------------------------------
# 🔍 Verify core packages
# ------------------------------------------------------
echo ""
echo "🔍 Verifying critical packages..."
python -c "import bokeh, pandas, numpy, fastapi, uvicorn; print('✅ All core packages loaded successfully.')"

# ------------------------------------------------------
# ✅ Summary
# ------------------------------------------------------
echo ""
echo "🎉 PulseBoard setup complete!"
echo ""
echo "👉 To activate the environment later:"
echo "   source ${PROJECT_ROOT}/${VENV_DIR}/bin/activate"
echo ""
echo "👉 Start development server:"
echo "   uvicorn pulseboard.main:app --reload"
echo ""
echo "👉 Run tests:"
echo "   pytest -v --asyncio-mode=auto"
echo ""
echo "👉 Generate coverage report:"
echo "   pytest --cov=src/pulseboard --cov-report=html"
echo ""
exit 0
