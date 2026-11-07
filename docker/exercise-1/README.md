# Docker Exercise 1 - Hello Container

Containerize a minimal Flask app with a Dockerfile and run it with Docker Compose.

## File structure

```
exercise-1/
├── app.py               # Flask app (GET / -> "Hello from Docker!")
├── requirements.txt     # Pinned Python dependencies
├── Dockerfile           # python:3.11-alpine image, dependencies cached in their own layer
├── .dockerignore        # Files excluded from the build context
├── docker-compose.yml   # Single service with port mapping and code volume
└── README.md
```

## How to run

```bash
cd docker/exercise-1
docker compose up -d --build
```

The app listens on port 3000. The code is mounted into the container at `/app`.

## How to test

```bash
curl http://localhost:3000
# Hello from Docker!

docker compose ps
```

Stop and remove the container:

```bash
docker compose down
```
