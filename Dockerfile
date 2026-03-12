FROM ghcr.io/astral-sh/uv:python3.14-trixie-slim AS builder
ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy


#ENV UV_PYTHON_PREFERENCE=only-managed
#RUN uv python install 3.14

WORKDIR /app
#RUN --mount=type=cache,target=/root/.cache/uv \
#    --mount=type=bind,source=uv.lock,target=uv.lock \
#    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
#    uv sync --frozen --no-install-project --no-dev --no-editable
COPY . /app
RUN uv sync --frozen --no-install-project --no-dev --no-editable
#RUN --mount=type=cache,target=/root/.cache/uv,Z \
#    uv sync --frozen --no-dev --no-editable

RUN uv sync --frozen --no-dev --no-editable

#FROM registry.opencode.de/open-code/oci/debian:13-minimal
#FROM registry.opencode.de/open-code/oci/python3:3.13-minimal
FROM docker.io/python:3.14-slim

#FROM gcr.io/distroless/cc
#COPY --from=builder --chown=python:python /python /python

WORKDIR /app
# Copy the application from the builder
COPY --from=builder /app/.venv /app/.venv

# Place executables in the environment at the front of the path
ENV PATH="/app/.venv/bin:$PATH"

CMD ["/app/.venv/bin/hello"]
