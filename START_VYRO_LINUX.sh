#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
command -v python3 >/dev/null || { echo "Python 3 is required."; exit 1; }
command -v node >/dev/null || { echo "Node.js 20+ is required."; exit 1; }
command -v ffmpeg >/dev/null || echo "WARNING: FFmpeg not found; video processing will not work until installed."

PYTHON=python3
PYTHON_MINOR="$($PYTHON -c 'import sys; print(sys.version_info.minor)')"
VENV="$ROOT/server/.venv"
if [[ -x "$ROOT/server/.venv314/bin/python" ]]; then
  VENV="$ROOT/server/.venv314"
fi
if (( PYTHON_MINOR > 14 )); then
  command -v python3.14 >/dev/null || { echo "Python 3.11–3.14 is required for Faster-Whisper dependencies."; exit 1; }
  PYTHON=python3.14
  VENV="$ROOT/server/.venv314"
fi

if [[ ! -d "$VENV" ]]; then
  "$PYTHON" -m venv "$VENV"
fi
"$VENV/bin/python" -m pip install --upgrade pip
"$VENV/bin/python" -m pip install -r "$ROOT/server/requirements.txt"
(cd "$ROOT/web" && npm install --include=optional)

( cd "$ROOT/server" && "$VENV/bin/python" -m uvicorn main:app --host 127.0.0.1 --port 8123 ) &
BACKEND_PID=$!
( cd "$ROOT/web" && npm run dev -- --host 127.0.0.1 ) &
FRONTEND_PID=$!
cleanup() { kill "$BACKEND_PID" "$FRONTEND_PID" 2>/dev/null || true; }
trap cleanup EXIT INT TERM
sleep 3
printf '\nVYRO frontend: http://localhost:5173\nBackend health: http://127.0.0.1:8123/api/health\n'
wait
