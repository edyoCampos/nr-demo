# Docker Exercise Extra - Full Application

Run a Flask API, a PostgreSQL database and pgAdmin together with Docker Compose, using a healthcheck, a named network and named volumes.

## File structure

```
exercise-extra/
├── api/
│   ├── src/
│   │   └── app.py           # Flask API (GET /health, POST/GET /messages)
│   ├── requirements.txt     # Pinned Python dependencies
│   ├── Dockerfile           # python:3.11-alpine image, dependencies cached in their own layer
│   └── .dockerignore        # Excludes files from the build context (./api)
├── pgadmin/
│   └── servers.json         # Pre-configured pgAdmin server pointing to the db service
├── docker-compose.yml       # api, db and pgadmin on the app-network network
├── .env.example             # Example environment variables (copy to .env)
└── README.md
```

## Services

| Service | Image | Host port | Notes |
|---|---|---|---|
| `api` | built from `./api` | 3000 | Runs with `--reload`; `./api/src` is mounted for development |
| `db` | `postgres:17.11-alpine` | none | Only reachable inside `app-network`; has a healthcheck (`pg_isready`) |
| `pgadmin` | `dpage/pgadmin4:9.19.0` | 8080 | Web UI for the database |

`api` and `pgadmin` wait for `db` to be healthy before they start. All three services use the `app-network` network. Data lives in the named volumes `db_data` and `pgadmin_data`.

## How to run

```bash
cd docker/exercise-extra
cp .env.example .env
docker compose up -d --build
```

> The values in `.env.example` are examples only. Change the passwords in your `.env` before using this setup anywhere other than your own machine. The `.env` file is ignored by Git and must never be committed.

## How to test

```bash
docker compose ps                  # db should be "healthy"

curl http://localhost:3000/health
# {"status":"ok"}

curl -X POST http://localhost:3000/messages \
  -H "Content-Type: application/json" \
  -d '{"text": "hello"}'
curl http://localhost:3000/messages

curl -I http://localhost:8080      # pgAdmin answers

docker network ls                  # app-network
docker volume ls                   # exercise-extra_db_data, exercise-extra_pgadmin_data
```

## Accessing pgAdmin

1. Open http://localhost:8080.
2. Log in with `PGADMIN_DEFAULT_EMAIL` and `PGADMIN_DEFAULT_PASSWORD` from your `.env`.
3. The server `app-db` is already configured. Open it and enter the database password (`POSTGRES_PASSWORD` from your `.env`) on the first connection.
4. Browse to `app_db` > Schemas > public > Tables > `messages`.

### Keeping servers.json and .env in sync

`pgadmin/servers.json` is mounted read-only into the pgAdmin container and registers the server with `Host` set to `db`. Its `Username` must match `POSTGRES_USER` in your `.env`, and its `MaintenanceDB` must match `POSTGRES_DB`. If you change either value in `.env`, change it in `servers.json` too, otherwise pgAdmin cannot connect to the database. The file does not store a password.

## Security scan

The api image was scanned with [Trivy](https://github.com/aquasecurity/trivy) `aquasec/trivy:0.76.2`, severities CRITICAL and HIGH.

| Image | Critical | High |
|---|---|---|
| `python:3.11-alpine` (before) | 0 | 2 |
| api image (after) | 0 | 0 |

The two findings in the base image came from copies vendored inside `setuptools` 79.0.1 (`jaraco.context` CVE-2026-23949 and `wheel` CVE-2026-24049). The Dockerfile now upgrades to `setuptools==84.2.1`, which ships fixed versions.

To reproduce:

```bash
docker compose build api
docker save exercise-extra-api:latest -o /tmp/exercise-extra-api.tar
docker run --rm -v /tmp/exercise-extra-api.tar:/image.tar:ro \
  aquasec/trivy:0.76.2 image --input /image.tar --severity CRITICAL,HIGH
rm /tmp/exercise-extra-api.tar
```

## Stop

```bash
docker compose down        # keeps the named volumes
docker compose down -v     # also deletes the stored data
```
