#!/usr/bin/env bash
set -euo pipefail

# Trigger a Fedora COPR rebuild via the project's custom webhook URL.
#
# Required env:
#   COPR_WEBHOOK_URL  Full custom webhook URL from COPR
#                     Settings → Integrations, typically:
#                     https://copr.fedorainfracloud.org/webhooks/custom/<ID>/<UUID>/satty/
#
# The COPR package must have auto-rebuild / webhook-rebuild enabled.

if [[ -z "${COPR_WEBHOOK_URL:-}" ]]; then
  cat <<'EOF' >&2
COPR_WEBHOOK_URL is not set.

1. In COPR (mineiro/satty), open the satty package and enable Auto-rebuild.
2. Open project Settings → Integrations and copy the Custom webhook URL
   for package "satty" (or append /satty/ to the project custom webhook).
3. Store that URL as the GitHub Actions secret COPR_WEBHOOK_URL.
4. Set the repository variable COPR_TRIGGER_ENABLED=true.
EOF
  exit 1
fi

echo "Triggering COPR rebuild via custom webhook..."
# Do not print the URL; it embeds a secret UUID.
curl --fail-with-body --silent --show-error --retry 3 --retry-all-errors \
  -X POST \
  -H "Content-Type: text/plain" \
  --data "satty-rpms ${GITHUB_SHA:-local} ${GITHUB_REF_NAME:-manual}" \
  "${COPR_WEBHOOK_URL}"

echo
echo "COPR rebuild submitted. Monitor: https://copr.fedorainfracloud.org/coprs/mineiro/satty/builds/"
