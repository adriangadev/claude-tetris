#!/usr/bin/env bash
# Fetch current weather for a location (or auto-detected via IP if none given).
# Usage: weather.sh [location] [format]
#   location: city name, "Latitude,Longitude", airport code, or empty for IP-based auto-detect
#   format:   "line" (default, one-line summary) | "full" (multi-line report) | "png" (saves image)
set -euo pipefail

LOCATION="${1:-}"
FORMAT="${2:-line}"
ENCODED_LOCATION=$(printf '%s' "$LOCATION" | sed 's/ /%20/g')

case "$FORMAT" in
  line)
    curl -fsS "wttr.in/${ENCODED_LOCATION}?format=%l:+%C+%t+(feels+%f),+humidity+%h,+wind+%w\n"
    ;;
  full)
    curl -fsS "wttr.in/${ENCODED_LOCATION}?0"
    ;;
  png)
    OUT="/tmp/weather_$(date +%s).png"
    curl -fsS "wttr.in/${ENCODED_LOCATION}.png?0" -o "$OUT"
    echo "Saved to $OUT"
    ;;
  *)
    echo "Unknown format: $FORMAT (use line|full|png)" >&2
    exit 1
    ;;
esac
