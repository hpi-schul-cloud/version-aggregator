FROM ghcr.io/astral-sh/uv:python3.14-trixie-slim AS builder
ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy

WORKDIR /app
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-install-project --no-dev --no-editable

COPY app.py /app
RUN uv sync --frozen --no-dev --no-editable

# Runtime stage
FROM docker.io/python:3.14-slim

WORKDIR /app

# Copy the virtual environment and application code
COPY --from=builder /app/.venv /app/.venv
COPY --from=builder /app/app.py /app/app.py

# Place executables in the environment at the front of the path
ENV PATH="/app/.venv/bin:$PATH"

# Expose the port the app runs on
EXPOSE 8080

CMD ["python", "/app/app.py"]
