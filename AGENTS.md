# CatKV

CatKV is a from-scratch distributed key-value store project intended for public operation,
real-world load testing, high availability, and horizontal scaling.

## Start here

- Read `docs/design-context.md` for goals, constraints, architecture decisions, proposals,
  open questions, and implementation status. Keep proposals, decisions, and implemented behavior distinct.
- `Cargo.toml` defines the Rust workspace.
- See `docs/development.md` for container startup, environment checks, and editor connections.

## Implementation principles

- Prefer straightforward implementation over abstractions for hypothetical future needs.

## Development and validation

- Run builds and development commands inside the Linux dev container as `dev`,
  using the Rust toolchain pinned in `rust-toolchain.toml`.
- Keep data, credentials, generated artifacts, and local SSH configuration out of Git.
- For implemented Rust changes, run `cargo fmt --all -- --check`,
  `cargo clippy --workspace --all-targets -- -D warnings`, and relevant `cargo test` targets.
