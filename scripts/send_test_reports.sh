#!/usr/bin/env bash
# Posts every report in data/sample_bug_reports.json to the n8n webhook, one at a time.
#
#   WEBHOOK_URL=http://localhost:5678/webhook/bug-report ./scripts/send_test_reports.sh
#
# Use /webhook-test/bug-report while the workflow is open in the editor and
# listening, or /webhook/bug-report once the workflow is active. Needs curl and jq.
set -euo pipefail

WEBHOOK_URL="${WEBHOOK_URL:-http://localhost:5678/webhook/bug-report}"
FILE="$(dirname "$0")/../data/sample_bug_reports.json"

count=$(jq length "$FILE")
for i in $(seq 0 $((count - 1))); do
  payload=$(jq -c ".[$i]" "$FILE")
  echo "Sending: $(echo "$payload" | jq -r .title)"
  curl -sS -X POST "$WEBHOOK_URL" -H "Content-Type: application/json" -d "$payload"
  echo
  sleep 10   # give the local model room between requests
done
