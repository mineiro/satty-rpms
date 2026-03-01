# satty-rpms

Fedora COPR packaging for [Satty](https://github.com/Satty-org/Satty) — a modern screenshot annotation tool for Linux.

**COPR repo:** [mineiro/satty](https://copr.fedorainfracloud.org/coprs/mineiro/satty/)

## Install

```bash
sudo dnf copr enable mineiro/satty
sudo dnf install satty
```

## Local build

Prerequisites: `rpm-build rpmdevtools cargo rpmlint`

```bash
# Lint the spec file
make check-specs

# Build SRPM (downloads sources + vendors Rust crates)
make srpm

# Test build with mock
mock -r fedora-rawhide-x86_64 dist/srpm/satty-*.src.rpm
```

## Bump version

```bash
scripts/bump-version.sh 0.21.0
```

Then verify Source URLs and patches, and commit.

## COPR SCM configuration

| Field         | Value                                      |
|---------------|--------------------------------------------|
| Clone URL     | `https://github.com/mineiro/satty-rpms`    |
| Committish    | `main`                                     |
| Subdirectory  | *(empty)*                                  |
| Spec file     | `satty.spec`                               |
| Source type   | SCM                                        |
| SRPM method   | `make_srpm`                                |

**Chroots:** fedora-42, fedora-43, fedora-44, fedora-rawhide (x86_64 + aarch64)
