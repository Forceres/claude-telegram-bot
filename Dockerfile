FROM oven/bun:1-debian

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

# Claude Code
RUN curl -fsSL https://claude.ai/install.sh | bash

# Create non-root user
RUN useradd \
    --create-home \
    --shell /bin/bash \
    --uid 1000 \
    claude

ENV HOME=/home/claude
ENV PATH="/home/claude/.local/bin:/root/.local/bin:${PATH}"

WORKDIR /app

COPY package.json bun.lock ./

RUN bun install --frozen-lockfile

COPY . .

RUN mkdir -p /workspace /home/claude/.claude \
    && chown -R claude:claude /app /workspace /home/claude

USER claude

WORKDIR /app

ENV CLAUDE_WORKING_DIR=/workspace
ENV ALLOWED_PATHS=/workspace,/home/claude/.claude

CMD ["bun", "run", "start"]
