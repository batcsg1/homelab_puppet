#!/bin/bash
set -euo pipefail

OUTFILE="/etc/prometheus/targets/homelab-nodes.yml"
SIGNED_DIR="/etc/puppet/puppetserver/ca/signed"
TMPFILE="$(mktemp "${OUTFILE}.XXXXXX")"
trap 'rm -f "$TMPFILE"' EXIT

mapfile -t NODES < <(
  find "$SIGNED_DIR" \
    -name '*.puppet.batchelornz.com.pem' \
    ! -name 'maestro.puppet.batchelornz.com.pem' \
    -printf '%f\n' 2>/dev/null \
  | sed 's/\.pem$//' \
  | sort -u
)

if [ ${#NODES[@]} -eq 0 ]; then
  echo "No signed agent certs found; leaving $OUTFILE unchanged" >&2
  exit 0
fi

{
  echo "- targets:"
  for n in "${NODES[@]}"; do
    echo "    - ${n}:9100"
  done
  echo "  labels:"
  echo "    cluster: homelab"
  echo "    role: agent"
} > "$TMPFILE"

chmod 0644 "$TMPFILE"
mv -f "$TMPFILE" "$OUTFILE"
trap - EXIT