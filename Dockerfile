FROM oven/bun:1-debian

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    ca-certificates \
    ripgrep \
    bubblewrap \
    socat \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://claude.ai/install.sh | bash

ENV PATH="/root/.local/bin:/root/.claude/bin:${PATH}"

WORKDIR /app

COPY package.json bun.lock ./

RUN bun install --frozen-lockfile

COPY . .

RUN mkdir -p /workspace /root/.claude

ENV CLAUDE_WORKING_DIR=/workspace \
    ALLOWED_PATHS=/workspace

CMD ["bun", "run", "start"]
