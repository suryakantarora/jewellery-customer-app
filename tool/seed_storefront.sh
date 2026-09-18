#!/usr/bin/env bash
# Publishes the bundled demo branding and content to a backend, so an app run
# with DATA_MODE=api looks like the demo while its catalogue, prices, accounts
# and orders are real. Image refs stay `asset://…`, which the app resolves from
# its own bundle; swap them for storage keys (upload with category=storefront)
# when the shop has its own artwork.
#
#   tool/seed_storefront.sh [base-url] [tenant-key] [company-id]
#
# Needs curl and jq. Signs in as a staff user with STOREFRONT_MANAGE:
# ADMIN_USER / ADMIN_PASSWORD (default: the local bootstrap administrator).
# company-id is only needed for a super administrator on a platform with more
# than one company.
set -euo pipefail

BASE="${1:-http://localhost:8081}"
TENANT_KEY="${2:-fino}"
COMPANY_ID="${3:-}"
ADMIN_USER="${ADMIN_USER:-admin}"
ADMIN_PASSWORD="${ADMIN_PASSWORD:-Admin@2026}"
DEMO="$(cd "$(dirname "$0")/../assets/demo" && pwd)"
API="$BASE/api/v1"

TOKEN="$(curl -fsS "$API/auth/login" -H 'Content-Type: application/json' \
  -d "$(jq -n --arg u "$ADMIN_USER" --arg p "$ADMIN_PASSWORD" '{username: $u, password: $p}')" \
  | jq -r '.data.accessToken')"
[ -n "$TOKEN" ] && [ "$TOKEN" != "null" ] || { echo "Sign-in failed" >&2; exit 1; }

QUERY=""
[ -z "$COMPANY_ID" ] || QUERY="?companyId=$COMPANY_ID"

put() { # path, json
  curl -fsS -X PUT "$API/storefront-admin/$1" -H "Authorization: Bearer $TOKEN" \
    -H 'Content-Type: application/json' -d "$2" >/dev/null
  echo "  ok  $1"
}

echo "Tenant '$TENANT_KEY' → $BASE"
put "tenant" "$(jq --arg key "$TENANT_KEY" --arg company "$COMPANY_ID" \
  '{tenantKey: $key, config: del(.key), active: true}
   + (if $company == "" then {} else {companyId: $company} end)' "$DEMO/tenant.json")"

for kind in policies stores offers brands trending stories about; do
  put "content/$kind$QUERY" "$(jq ".${kind}" "$DEMO/content.json")"
done
put "content/banners$QUERY" "$(jq '.banners' "$DEMO/catalogue.json")"
# Category artwork and translations, keyed by category code. Only codes the
# ERP also has are used; create categories with matching codes to pick them up.
put "content/categories$QUERY" "$(jq '[.categories[] | {key: .id, value: del(.id, .productCount)}] | from_entries' "$DEMO/catalogue.json")"

echo "Done. Run the app with:"
echo "  flutter run --flavor dev --dart-define=DATA_MODE=api --dart-define=API_BASE_URL=$BASE --dart-define=TENANT_KEY=$TENANT_KEY"
