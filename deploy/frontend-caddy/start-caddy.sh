#!/bin/sh
set -eu

if [ -n "${CADDY_TLS_CERT_FILE:-}" ] && [ -n "${CADDY_TLS_KEY_FILE:-}" ]; then
  export CADDY_TLS_DIRECTIVE="tls ${CADDY_TLS_CERT_FILE} ${CADDY_TLS_KEY_FILE}"
else
  export CADDY_TLS_DIRECTIVE=""
fi

if [ -n "${LS_BACKEND_CA_CERT:-}" ]; then
  export LS_BACKEND_CA_DIRECTIVE="tls_trusted_ca_certs ${LS_BACKEND_CA_CERT}"
else
  export LS_BACKEND_CA_DIRECTIVE=""
fi

if [ -n "${LS_FRONTEND_ORIGIN:-}" ]; then
  export LS_REWRITE_TARGET="${LS_FRONTEND_ORIGIN}"
else
  export LS_REWRITE_TARGET="{scheme}://{hostport}"
fi

exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
