# Docker Exercise 3 - Best Practices + Multiple Environments

Build one image with a multi-stage Dockerfile and run it as two independent environments (dev and prod) with Docker Compose.

## File structure

```
exercise-3/
├── app.py                    # Flask API (POST/GET /messages) backed by PostgreSQL
├── requirements.txt          # Pinned Python dependencies (includes gunicorn)
├── Dockerfile                # Multi-stage: base, dev and prod targets
├── .dockerignore             # Files excluded from the build context
├── docker-compose.dev.yml    # Dev environment (project exercise-3-dev)
├── docker-compose.prod.yml   # Prod environment (project exercise-3-prod)
├── .env.example              # Example environment variables (copy to .env)
└── README.md
```

## Environments

| | dev | prod |
|---|---|---|
| Compose file | `docker-compose.dev.yml` | `docker-compose.prod.yml` |
| Project name | `exercise-3-dev` | `exercise-3-prod` |
| Dockerfile target | `dev` | `prod` |
| Server | `flask run --reload` | `gunicorn` |
| Code | mounted from the host (live reload) | copied into the image |
| User | root | non-root user `app` |
| Host port | 3000 | 3001 |
| Database volume | `db_dev_data` | `db_prod_data` |
| Image size | 117MB | 117MB |

Both images are built from the same base stage and the same installed dependencies, so their size is the same (117MB). The prod optimization is in its content and configuration: a non-root user, gunicorn instead of the Flask development server, no code volume, no reload, and only `app.py` and `requirements.txt` copied into the image.

### Why prod uses port 3001

The container always listens on port 3000. Dev publishes it on host port 3000 and prod publishes it on host port 3001, so both environments can run at the same time without a port conflict. Different project names and different named volumes keep their containers, networks and data fully separate.

## How to run

```bash
cd docker/exercise-3
cp .env.example .env

# dev
docker compose -f docker-compose.dev.yml up -d --build

# prod
docker compose -f docker-compose.prod.yml up -d --build
```

## How to test

```bash
# dev
curl http://localhost:3000/messages

# prod
curl http://localhost:3001/messages
docker compose -f docker-compose.prod.yml exec api whoami   # app (non-root)
```

Live reload (dev): edit `app.py` and the change is applied without rebuilding the image.

Stop an environment (add `-v` only if you want to delete its data):

```bash
docker compose -f docker-compose.dev.yml down
docker compose -f docker-compose.prod.yml down
```

## Security scan

The prod image was scanned with [Trivy](https://github.com/aquasecurity/trivy) `aquasec/trivy:0.76.2`, severities CRITICAL and HIGH.

| Image | Critical | High |
|---|---|---|
| `python:3.11-alpine` (before) | 0 | 2 |
| prod image (after) | 0 | 0 |

The two findings came from copies vendored inside `setuptools` 79.0.1 (`jaraco.context` CVE-2026-23949 and `wheel` CVE-2026-24049). The base stage now upgrades to `setuptools==84.2.1`, which ships fixed versions.

To reproduce:

```bash
docker compose -f docker-compose.prod.yml build
docker save exercise-3-prod-api:latest -o /tmp/exercise-3-prod.tar
docker run --rm -v /tmp/exercise-3-prod.tar:/image.tar:ro \
  aquasec/trivy:0.76.2 image --input /image.tar --severity CRITICAL,HIGH
rm /tmp/exercise-3-prod.tar
```
