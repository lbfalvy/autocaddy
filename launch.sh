echo "Starting Autocaddy"
# ====== Check variables ======
if [[ -z "$DOMAIN" ]]; then
  echo "ERROR Domain not specified"
  exit 1
fi
PORT="${PORT:-80}"

# ====== Generate config ======
DOTS_ONLY="${DOMAIN//[^.]}."
# Mind the extra dot at the end
# there are one less dots than labels in a domain
LABEL_COUNT=${#DOTS_ONLY}
echo "{
  admin off
}
*.$DOMAIN {
  encode zstd gzip
  reverse_proxy * {http.request.labels.$LABEL_COUNT}:$PORT {
    header_up X-Real-IP {remote}
  }
}" > /tmp/Caddyfile

# ====== Invoke Caddy ======
# Forward SIGTERM
_term() {
  kill -TERM "$CADDY_PROC"
}
trap _term SIGTERM
# Start Caddy in the background
caddy run --config /tmp/Caddyfile --adapter caddyfile &
CADDY_PROC=$!
# Wait for it to finish
wait "$CADDY_PROC"
STATUS=$?

exit $STATU1S
