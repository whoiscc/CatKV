# 开发环境

## 前提与首次配置

需要支持 Linux 容器的 Docker 和 Docker Compose。源码应克隆到 Linux 文件系统；
Windows 用户可使用 WSL2，自行选择发行版和克隆目录。以下宿主机命令均在仓库根目录执行。

启动前，将开发者自己的 SSH 公钥写入本机配置文件：

```bash
mkdir -p .devcontainer/local
# 将下面的示例路径替换为自己的公钥文件路径。
cp ~/.ssh/id_ed25519.pub .devcontainer/local/authorized_keys
bash scripts/dev up
```

若尚无 SSH 密钥，请先在客户端创建。`.devcontainer/local/` 已被 Git 和镜像构建上下文忽略；
私钥始终保留在客户端，不进入容器或仓库。

## 目录与持久化

当前克隆目录映射到开发容器的 `/workspaces/CatKV`，两者是同一份文件。
容器重建不会复制或删除源码，不要求宿主机使用固定目录或 WSL 发行版名称。

Rust 编译输出、Cargo 下载缓存、容器用户的 Codex 配置与登录状态、SSH 服务端密钥使用各自的 Docker 命名卷。
保留这些卷可在重建后继续使用。删除卷会删除对应内容，命名卷不能代替备份。
源码应使用 Git，并定期推送到自己的远程仓库。

## 启动、停止与检查

在宿主机仓库根目录运行：

```bash
bash scripts/dev up
bash scripts/dev status
bash scripts/dev check
bash scripts/dev shell
bash scripts/dev stop
```

`up` 构建镜像并等待 SSH 服务健康。只停止容器不会删除代码和命名卷。
使用期间需保持 Docker 运行；使用 WSL2 时也需保持对应发行版运行。
容器配置了 `unless-stopped`；手动停止后再次使用 `up`。

## SSH 与编辑器连接

SSH 端口默认仅发布在宿主机的 `127.0.0.1:2222`，只允许 `dev` 公钥登录。
客户端应使用与 `.devcontainer/local/authorized_keys` 对应的私钥，例如：

```bash
ssh -p 2222 -i ~/.ssh/id_ed25519 dev@127.0.0.1
```

首次连接时核对并保存容器的 SSH 主机公钥。SSH 别名和密钥路径在客户端自行配置，
支持 SSH 的编辑器可通过同一连接打开 `/workspaces/CatKV`。
也可从宿主机打开仓库，在 VS Code 中使用 Dev Containers 的 Reopen in Container。
此配置使用同一个 Compose 服务、同一个用户及同一份源码，关闭 VS Code 不会停止开发容器。

Codex CLI 的登录由每位开发者自行完成；登录状态保存在容器专用命名卷中。
不要把登录缓存、访问令牌或本机 SSH 配置提交到仓库。

## Rust 与项目现状

Rust 版本由 `rust-toolchain.toml` 固定，容器镜像在 `.devcontainer/Dockerfile` 中配置对应版本，
并提供 rustfmt、Clippy、rust-analyzer、rust-src、Clang、LLDB 和 OpenSSL 开发库。
Node.js 用于 Codex CLI 和后续可选的辅助工具，不要求项目采用 JavaScript。
Node.js 和 Codex CLI 版本见 `.devcontainer/Dockerfile`。

目前 `catkv-storage` 是无依赖、可构建的空库骨架。`cargo test` 当前没有业务测试；
`scripts/check-environment` 检查挂载、权限、文件锁、同步、重命名及目录同步的运行能力，
不构成断电持久化或分布式正确性的证明。

## 嵌套沙箱

Docker 默认 seccomp 规则会阻止 bubblewrap 创建 Codex 内部沙箱。
Compose 因此使用 `.devcontainer/seccomp.json`：以 Docker 官方默认策略为基础，
补充 clone、unshare、setns、mount、umount2、pivot_root 六个系统调用，保留其他默认限制。
来源、上游固定提交和许可证见 `.devcontainer/seccomp.md`。
容器没有启用 privileged，也没有挂载 Docker socket；Codex 自身的 Linux 沙箱保持可用。
