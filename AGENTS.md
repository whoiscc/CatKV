# CatKV

## Development environment

- Clone the repository into a Linux filesystem (native Linux or WSL2).
  The dev container mounts that checkout at `/workspaces/CatKV`.
- Run builds and development commands inside the dev container as `dev`.
- Rust is pinned by `rust-toolchain.toml`. Do not install project toolchains on Windows.
- Read `docs/design-context.md` for the latest architecture boundaries and which choices remain proposals.
- Prefer straightforward implementation over abstractions for hypothetical future needs.
- Build the storage engine from scratch; do not substitute RocksDB or a ready-made replication protocol.
- Keep data, credentials, generated artifacts, and local SSH configuration out of Git.
- For implemented Rust changes, run `cargo fmt --all -- --check`,
  `cargo clippy --workspace --all-targets -- -D warnings`, and relevant `cargo test` targets.
- For storage changes, test recovery, corruption detection, compaction, and durability failure paths as applicable.
- The current repository is environment scaffolding only. Do not claim that replication, sharding,
  a public service, or even the local storage engine already exists.
