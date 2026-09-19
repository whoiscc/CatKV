# Nested Codex sandbox support

Upstream: https://github.com/moby/profiles/blob/245180c51918481c0525424b3ee025d2b435d46c/seccomp/default.json

Upstream SHA-256: `785b2429264afba4d594320337cb17f144f3c7d51585f9805eef72e28f4f9334`

License: `seccomp.LICENSE` (Apache-2.0).

This profile retains the upstream default-deny syscall policy and adds an allow rule for `clone`, `unshare`, `setns`, `mount`, `umount2`, `pivot_root`. These calls permit bubblewrap to construct the nested user and mount namespaces used by Codex. Kernel capability checks still apply; the container is not privileged and has no host namespace or Docker socket mount. The upstream clone3 ENOSYS fallback and unrelated denied syscalls are retained.
