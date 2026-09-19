#!/usr/bin/env bash
set -euo pipefail
mkdir -p /run/sshd /home/dev/.ssh /home/dev/.codex \
  /usr/local/cargo/registry /usr/local/cargo/git /workspaces/CatKV/target
if [[ ! -s /run/catkv-authorized-keys ]]; then
  echo 'Missing SSH public key: prepare .devcontainer/local/authorized_keys first.' >&2
  exit 1
fi
install -o dev -g dev -m 0600 /run/catkv-authorized-keys /home/dev/.ssh/authorized_keys
chown dev:dev /home/dev/.ssh /home/dev/.codex \
  /usr/local/cargo/registry /usr/local/cargo/git /workspaces/CatKV/target
chmod 0700 /home/dev/.ssh /home/dev/.codex
if [[ ! -f /var/lib/catkv-ssh/ssh_host_ed25519_key ]]; then
  ssh-keygen -q -t ed25519 -N '' -f /var/lib/catkv-ssh/ssh_host_ed25519_key
fi
chmod 0700 /var/lib/catkv-ssh
exec "$@"
