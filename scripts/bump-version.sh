#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  scripts/bump-version.sh <new-version>

Example:
  scripts/bump-version.sh 0.21.0
EOF
}

if [[ $# -ne 1 ]]; then
  usage
  exit 1
fi

new_version="$1"
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
spec="${repo_root}/satty.spec"

if [[ ! -f "${spec}" ]]; then
  echo "Spec file not found: ${spec}"
  exit 1
fi

old_version="$(awk '/^Version:[[:space:]]+/ {print $2; exit}' "${spec}")"
if [[ -z "${old_version}" ]]; then
  echo "Could not read Version from ${spec}"
  exit 1
fi

sed -i -E "0,/^Version:[[:space:]]+/{s|^Version:[[:space:]]+.*$|Version:        ${new_version}|}" "${spec}"

echo "Updated satty.spec: ${old_version} -> ${new_version}"
echo "Reminder: verify Source URLs, patches, and dependency floors before build."
