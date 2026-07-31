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
scripts/bump-version.sh 0.21.1
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

**Chroots:** fedora-43, fedora-44, fedora-rawhide (x86_64 + aarch64)

## COPR CI trigger

GitHub Actions lints the spec on every PR/push. After a successful lint on `main` (or a manual `workflow_dispatch`), it can POST to the COPR custom webhook so SCM builds start automatically.

One-time setup:

1. In [mineiro/satty](https://copr.fedorainfracloud.org/coprs/mineiro/satty/), open package **satty** → enable **Auto-rebuild**.
2. Open project **Settings → Integrations** and copy the **Custom webhook** URL for package `satty`  
   (`https://copr.fedorainfracloud.org/webhooks/custom/<ID>/<UUID>/satty/`).
3. In this GitHub repo, add secret `COPR_WEBHOOK_URL` with that URL.
4. Add repository variable `COPR_TRIGGER_ENABLED` = `true`.

Until step 4 is set, CI still lints but skips the COPR job.

Manual local trigger (same secret/env):

```bash
export COPR_WEBHOOK_URL='https://copr.fedorainfracloud.org/webhooks/custom/.../satty/'
./scripts/trigger-copr.sh
```
