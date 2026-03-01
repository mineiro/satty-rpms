#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
spec="${repo_root}/satty.spec"

if [[ ! -f "${spec}" ]]; then
  echo "Spec file not found: ${spec}"
  exit 1
fi

if ! command -v rpmspec >/dev/null 2>&1; then
  echo "rpmspec not found; install rpm-build"
  exit 1
fi

echo "Parsing spec file..."
rpmspec -P "${spec}" >/dev/null
echo "OK  satty.spec"

if command -v rpmlint >/dev/null 2>&1; then
  echo
  echo "Running rpmlint..."
  rpmlint "${spec}"
else
  echo
  echo "rpmlint not installed; skipping lint phase"
fi
