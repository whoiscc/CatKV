FROM node:24-bookworm-slim AS node
FROM rust:1.98.1-slim-bookworm

ARG CODEX_VERSION=0.155.0-alpha.9.2
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential clang clang-format lldb lld pkg-config libssl-dev \
    ca-certificates curl git openssh-server sudo tini bubblewrap \
    ripgrep jq python3 rsync procps iproute2 iputils-ping netcat-openbsd \
    strace file less unzip bash-completion \
    && rm -rf /var/lib/apt/lists/*
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
    && ln -s /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx \
    && npm install -g "@openai/codex@${CODEX_VERSION}" \
    && npm cache clean --force \
    && rustup component add rustfmt clippy rust-src rust-analyzer

RUN groupadd --gid 1000 dev && useradd --uid 1000 --gid dev --create-home --shell /bin/bash dev \
    && printf 'dev ALL=(ALL) NOPASSWD:ALL\n' > /etc/sudoers.d/dev \
    && chmod 0440 /etc/sudoers.d/dev \
    && mkdir -p /run/sshd /var/lib/catkv-ssh /home/dev/.ssh \
       /home/dev/.codex /usr/local/cargo/registry /usr/local/cargo/git \
    && chown -R dev:dev /home/dev /usr/local/cargo /usr/local/rustup

COPY sshd_config /etc/ssh/sshd_config
COPY entrypoint.sh /usr/local/bin/catkv-entrypoint
COPY profile.sh /etc/profile.d/catkv.sh
RUN chmod 0755 /usr/local/bin/catkv-entrypoint \
    && printf '\n. /etc/profile.d/catkv.sh\n' >> /home/dev/.bashrc

WORKDIR /workspaces/CatKV
EXPOSE 22
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/catkv-entrypoint"]
CMD ["/usr/sbin/sshd", "-D", "-e"]
