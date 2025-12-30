# ==========================================
# STAGE 1: BUILDER
# ==========================================
# Use a specific version, not 'latest'. 'slim' is smaller but has glibc.
FROM python:3.11-slim-bookworm as builder

WORKDIR /build

# Install system dependencies if needed (none for this simple app, but good practice to show)
# RUN apt-get update && apt-get install -y gcc

# Install python dependencies into a local directory
COPY src/requirements.txt .
RUN pip install --no-cache-dir --target=/build/deps -r requirements.txt

# ==========================================
# STAGE 2: RUNNER (FINAL IMAGE)
# ==========================================
# Start fresh to keep image small
FROM python:3.11-slim-bookworm

# Standardize path
WORKDIR /app

# Create a non-root user (Security Best Practice)
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Copy installed dependencies from builder stage
# We put this first because it changes rarely (Caching)
COPY --from=builder /build/deps /usr/local/lib/python3.11/site-packages/
# Also need to ensure binaries are in path if any
ENV PATH="/usr/local/lib/python3.11/site-packages/bin:${PATH}"

# Copy application code
# This changes most often, so it goes last
COPY src/ .

# Set ownership to non-root user
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose the port (Documentation only, technically)
EXPOSE 5000

# Environment Defaults (Safe defaults)
ENV PORT=5000
ENV LOG_LEVEL=INFO
ENV PYTHONUNBUFFERED=1

# Healthcheck (Docker Native)
HEALTHCHECK --interval=30s --timeout=3s \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')" || exit 1

# Command to run the application
# We use 'python -m app' or direct script.
# Exec form ["cmd", "arg"] is required for signal handling (SIGTERM)
CMD ["python", "app.py"]
