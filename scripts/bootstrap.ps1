<#
.SYNOPSIS
    PulseBoard Bootstrap Script for Windows PowerShell
.DESCRIPTION
    Automates setup of Python 3.14, virtual environment, project dependencies,
    and development tools for PulseBoard.
#>

# ------------------------------------------------------
# 🚀 Configuration
# ------------------------------------------------------
$PythonExe = "python3.14"
$VenvDir = ".venv"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Resolve-Path "$ScriptDir\.."

Write-Host ""
Write-Host "🧩 Starting PulseBoard environment setup..."
Write-Host "--------------------------------------------"
Write-Host "📁 Script directory: $ScriptDir"
Write-Host "📂 Project root: $ProjectRoot"

# ------------------------------------------------------
# 🧠 Check Python 3.14 availability
# ------------------------------------------------------
$pythonFound = $false
try {
    $pythonVersion = & $PythonExe --version 2>$null
    Write-Host "✅ Found $PythonExe: $pythonVersion"
    $pythonFound = $true
} catch {
    Write-Warning "$PythonExe not found."
}

if (-not $pythonFound) {
    Write-Host "🚀 Attempting to install Python 3.14 via winget..."
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        try {
            winget install --id Python.Python.3.14 -e --source winget -h
        } catch {
            Write-Warning "⚠️ Winget installation failed. Please install Python 3.14 manually."
            exit 1
        }
    } else {
        Write-Warning "⚠️ Winget not found. Please install Python 3.14 manually from https://www.python.org/downloads/windows/"
        exit 1
    }

    # Verify installation
    try {
        $pythonVersion = & $PythonExe --version 2>$null
        Write-Host "✅ Successfully installed $PythonExe: $pythonVersion"
    } catch {
        Write-Warning "❌ Python 3.14 installation failed or not in PATH."
        exit 1
    }
}

# ------------------------------------------------------
# 🧰 Create virtual environment
# ------------------------------------------------------
Set-Location $ProjectRoot
if (-Not (Test-Path $VenvDir)) {
    Write-Host "📦 Creating virtual environment at $ProjectRoot\$VenvDir ..."
    & $PythonExe -m venv $VenvDir
    Write-Host "✅ Virtual environment created."
} else {
    Write-Host "🔁 Virtual environment already exists."
}

# ------------------------------------------------------
# 🟢 Activate virtual environment
# ------------------------------------------------------
$VenvActivate = Join-Path $VenvDir "Scripts\Activate.ps1"
if (Test-Path $VenvActivate) {
    Write-Host "🐍 Activating virtual environment..."
    & $VenvActivate
} else {
    Write-Warning "⚠️ Virtual environment activation script not found!"
    exit 1
}

Write-Host "📁 Using Python: $(python --version)"
Write-Host "📂 Virtual env path: $(Get-Command python).Source"

# ------------------------------------------------------
# 🧱 Upgrade pip and install build tools
# ------------------------------------------------------
Write-Host "⬆️ Upgrading pip, setuptools, wheel, build, and twine..."
python -m pip install --upgrade pip setuptools wheel build twine

# ------------------------------------------------------
# 📦 Install project dependencies
# ------------------------------------------------------
if (Test-Path "$ProjectRoot\requirements.txt") {
    Write-Host "📦 Installing production dependencies from requirements.txt..."
    pip install -r "$ProjectRoot\requirements.txt"
} elseif (Test-Path "$ProjectRoot\pyproject.toml") {
    Write-Host "📦 Installing production dependencies from pyproject.toml..."
    pip install "$ProjectRoot"
} else {
    Write-Warning "⚠️ No requirements.txt or pyproject.toml found — skipping dependency installation."
}

# ------------------------------------------------------
# 🧰 Install optional dev dependencies
# ------------------------------------------------------
if (Test-Path "$ProjectRoot\pyproject.toml") {
    Write-Host "🧪 Installing development dependencies..."
    try {
        pip install -e .[dev]
    } catch {
        Write-Warning "⚠️ Dev dependencies installation failed or already satisfied."
    }
}

# ------------------------------------------------------
# 🧾 Load .env variables
# ------------------------------------------------------
$EnvFile = "$ProjectRoot\.env"
if (Test-Path $EnvFile) {
    Write-Host "📝 Loading environment variables from .env..."
    Get-Content $EnvFile | ForEach-Object {
        if ($_ -match "^\s*([^#][^=]+)=(.+)$") {
            $name = $matches[1].Trim()
            $value = $matches[2].Trim()
            [System.Environment]::SetEnvironmentVariable($name, $value)
        }
    }
}

# ------------------------------------------------------
# 🔍 Verify core packages
# ------------------------------------------------------
Write-Host "🔍 Verifying critical packages..."
python -c "import bokeh, pandas, numpy, fastapi, uvicorn; print('✅ All core packages loaded successfully.')"

# ------------------------------------------------------
# ✅ Summary & Next Steps
# ------------------------------------------------------
Write-Host ""
Write-Host "🎉 PulseBoard setup complete!"
Write-Host ""
Write-Host "👉 To activate the environment later:"
Write-Host "   $VenvDir\Scripts\Activate.ps1"
Write-Host ""
Write-Host "👉 Start development server:"
Write-Host "   uvicorn pulseboard.main:app --reload"
Write-Host ""
Write-Host "👉 Run tests:"
Write-Host "   pytest -v --asyncio-mode=auto"
Write-Host ""
Write-Host "👉 Generate coverage report:"
Write-Host "   pytest --cov=src/pulseboard --cov-report=html"
Write-Host ""
