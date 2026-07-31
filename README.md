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

## Auto-rebuild on push

Same approach as [gaffer](https://github.com/mineiro/gaffer): a GitHub repository webhook posts to COPR; no Actions secrets are involved.

One-time setup (both sides required):

1. In [mineiro/satty](https://copr.fedorainfracloud.org/coprs/mineiro/satty/), open package **satty** and enable **Auto-rebuild**  
   (`copr-cli edit-package-scm satty --name satty --webhook-rebuild on` only makes COPR *accept* the request).
2. COPR project **Settings → Integrations**: copy the **GitHub** webhook URL  
   (`https://copr.fedorainfracloud.org/webhooks/github/<ID>/<UUID>/`).
3. In this GitHub repo: **Settings → Webhooks → Add webhook**
   - Payload URL: the URL from step 2
   - Content type: `application/json`
   - Secret: leave empty (COPR authenticates via the UUID in the URL; it does not verify `X-Hub-Signature-256`)
   - Events: **Just the push event** (add *Branch or tag creation* only if you want tag builds)

After that, every push to `main` rebuilds all COPR chroots. If pushes stop producing builds, check the webhook delivery log under GitHub’s webhook settings before suspecting the spec.

GitHub Actions only lints the spec; it does not trigger COPR.
