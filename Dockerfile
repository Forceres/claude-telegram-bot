FROM oven/bun:1-debian

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    ca-certificates \
    ripgrep \
    bubblewrap \
    socat \
    openssh-client \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install Claude Code as the bun user
USER bun

ENV HOME=/home/bun
ENV PATH="/home/bun/.local/bin:${PATH}"

RUN curl -fsSL https://claude.ai/install.sh | bash

WORKDIR /app

COPY --chown=bun:bun package.json bun.lock ./

RUN bun install --frozen-lockfile

COPY --chown=bun:bun . .

RUN mkdir -p \
    /home/bun/.claude \
    /workspace

WORKDIR /app

ENV CLAUDE_WORKING_DIR=/workspace
ENV ALLOWED_PATHS=/workspace,/home/claude/.claude

CMD ["bun", "run", "start"]
