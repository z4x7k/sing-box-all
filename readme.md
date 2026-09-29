# SagerNet Sing-box All Tags

A custom statically-linked build of [SagerNet sing-box](https://github.com/SagerNet/sing-box/) with all tags enabled.

## Compatibility

Both `linux/amd64` and `linux/arm64` are supported.

| Platform | Release asset |
| --- | --- |
| `linux/amd64` | `sing-box-amd64` |
| `linux/arm64` | `sing-box-arm64` |

Both architectures are built on AMD64 GitHub runners using Go cross-compilation
and a target-specific Clang/musl toolchain for CGO. Builds verify the binary's
architecture and static linking; ARM64 executables are smoke-tested with QEMU.

## Usage

Download the latest executable for your architecture.

For AMD64:

```sh
curl -sSfL https://github.com/z4x7k/sing-box-all/releases/latest/download/sing-box-amd64 -o sing-box && chmod +x ./sing-box
```

For ARM64:

```sh
curl -sSfL https://github.com/z4x7k/sing-box-all/releases/latest/download/sing-box-arm64 -o sing-box && chmod +x ./sing-box
```

Verify it's working using `./sing-box version` command.
