# CatKV

一个面向公开运行、公众压测、高可用和水平扩容的分布式键值存储项目。
当前仓库只完成开发环境和 Rust workspace 骨架；存储引擎与分布式协议尚未实现。

- [设计背景](docs/design-context.md)
- [开发环境与首次配置](docs/development.md)

## 日常使用

需要支持 Linux 容器的 Docker 和 Docker Compose。Windows 用户可在 WSL2 中操作。
首次使用请按开发环境文档配置本机 SSH 公钥，然后在仓库根目录运行：

```bash
bash scripts/dev up
bash scripts/dev shell
```

容器内：

```bash
cd /workspaces/CatKV
cargo fmt --all -- --check
cargo clippy --workspace --all-targets -- -D warnings
cargo test --workspace
```

容器以 `dev` 用户开发，源码统一挂载到 `/workspaces/CatKV`。
宿主机的克隆目录、WSL 发行版名称和 SSH 客户端配置由开发者自行选择。
