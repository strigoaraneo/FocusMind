#!/usr/bin/env bash
# --------------------------------------------------------------
# This script is executed as PID 1 inside the container.
# It expands the $PORT environment variable that Render injects.
# --------------------------------------------------------------

# If $PORT is not set (running locally) fall back to 8000
PORT=${PORT:-8000}

# Run uvicorn – the exec replaces the shell so Docker sees uvicorn as PID 1
exec uvicorn api.api:app --host 0.0.0.0 --port "$PORT"