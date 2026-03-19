# Frontend-only Label Studio image (Caddy)

## Build

From repo root:

```bash
docker build -f Dockerfile.frontend-caddy -t labelstudio-frontend-caddy .
```

## Run

HTTP only (no frontend TLS cert):

```bash
docker run --rm -p 8080:8080 \
  -e LS_BACKEND=https://labelstudio.ic.cloud.ru \
  -e LS_BACKEND_ORIGIN=https://labelstudio.ic.cloud.ru \
  -e LS_FRONTEND_ORIGIN=https://arch.liphi.co \
  -e LS_BACKEND_CA_CERT=/etc/caddy/certs/internal-ca.crt \
  -v /path/to/internal-ca.crt:/etc/caddy/certs/internal-ca.crt:ro \
  -e CADDY_PORT=8080 \
  labelstudio-frontend-caddy
```

HTTPS (self-signed cert mounted into container):

```bash
docker run --rm -p 8443:8080 \
  -e LS_BACKEND=https://labelstudio.ic.cloud.ru \
  -e LS_BACKEND_ORIGIN=https://labelstudio.ic.cloud.ru \
  -e LS_FRONTEND_ORIGIN=https://arch.liphi.co \
  -e LS_BACKEND_CA_CERT=/etc/caddy/certs/internal-ca.crt \
  -e CADDY_TLS_CERT_FILE=/etc/caddy/certs/10.0.10.199.crt \
  -e CADDY_TLS_KEY_FILE=/etc/caddy/certs/10.0.10.199.key \
  -v /home/liphi/data/Programming/MLInternship/Certs/10.0.10.199.crt:/etc/caddy/certs/10.0.10.199.crt:ro \
  -v /home/liphi/data/Programming/MLInternship/Certs/10.0.10.199.key:/etc/caddy/certs/10.0.10.199.key:ro \
  -v /path/to/internal-ca.crt:/etc/caddy/certs/internal-ca.crt:ro \
  -e CADDY_PORT=8080 \
  labelstudio-frontend-caddy
```

## Notes

- `LS_BACKEND` must include scheme, e.g. `https://os.liphi.co`.
- `LS_BACKEND_ORIGIN` should be the backend origin used for CSRF headers (usually same as `LS_BACKEND`).
- `LS_FRONTEND_ORIGIN` is optional. If set, HTML/Location origin rewrites use this exact value (recommended behind external HTTPS proxies, e.g. `https://arch.liphi.co`).
- `LS_BACKEND_CA_CERT` is optional. If set, Caddy injects `tls_trusted_ca_certs` for upstream TLS validation.
- `CADDY_TLS_CERT_FILE` and `CADDY_TLS_KEY_FILE` are optional; if both are set, Caddy enables HTTPS with that cert/key.
- If either TLS env var is missing, Caddy skips the `tls` directive and serves plain HTTP.
