# Dockerfile for BJ-WGS Sentieon processes (local execution)
#
# This image does NOT bundle Sentieon. At runtime the local Sentieon
# installation is bind-mounted in via containerOptions in conf/local.config.
#
# Build:
#   docker build -t sentieon-base:local .
#
# The Sentieon binaries will be mounted at /opt/sentieon_local at runtime.
# Your license file (or server address) is passed via --sentieon_license.

FROM ubuntu:24.04

LABEL maintainer="BioSkryb Genomics" \
      description="Base runtime image for Sentieon processes (local Sentieon mount)"

ENV DEBIAN_FRONTEND=noninteractive

# ── System runtime libraries required by Sentieon ──────────────────────────
RUN apt-get update && apt-get install -y --no-install-recommends \
    # core C/C++ runtime
    libc6 \
    libgomp1 \
    libstdc++6 \
    # compression / I/O
    zlib1g \
    libbz2-1.0 \
    liblzma5 \
    libncurses6 \
    # networking (license server communication)
    libssl3 \
    ca-certificates \
    curl \
    # Java – required by Sentieon driver for certain algorithms
    openjdk-17-jre-headless \
    # Python 3 – required by DNAscope model inference
    python3 \
    python3-pip \
    # General utilities used inside Nextflow process scripts
    bash \
    gawk \
    procps \
    && rm -rf /var/lib/apt/lists/*

# ── Python packages required by Sentieon DNAscope ──────────────────────────
# torch and related packages are large; install CPU-only wheels to keep the
# image size manageable. GPU users should add the appropriate CUDA wheels.
RUN pip3 install --no-cache-dir --break-system-packages \
    torch==2.2.2+cpu \
    --index-url https://download.pytorch.org/whl/cpu

# ── Locale ─────────────────────────────────────────────────────────────────
RUN apt-get update && apt-get install -y --no-install-recommends locales \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*
ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# ── Java heap tuning ────────────────────────────────────────────────────────
ENV JAVA_TOOL_OPTIONS="-Xmx4g"

# Sentieon will be available at /opt/sentieon_local/bin at runtime (mounted).
# Add it to PATH so scripts can call `sentieon` directly; the per-process
# override via SENTIEON_BIN also handles this, but having it here is a
# convenient fallback.
ENV PATH="/opt/sentieon_local/bin:${PATH}"

WORKDIR /tmp
