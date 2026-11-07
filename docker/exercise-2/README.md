# Docker Exercise 2 - API + Database

Run a Flask API and a PostgreSQL database with Docker Compose, persisting data in a named volume.

## File structure

```
exercise-2/
├── app.py               # Flask API (POST/GET /messages) backed by PostgreSQL
├── requirements.txt     # Pinned Python dependencies
├── Dockerfile           # python:3.11-alpine image, dependencies cached in their own layer
├── .dockerignore        # Files excluded from the build context
├── docker-compose.yml   # api + db services, named volume db_data
├── .env.example         # Example environment variables (copy to .env)
└── README.md
```

## How to run

```bash
cd docker/exercise-2
cp .env.example .env
docker compose up -d --build
```

Edit `.env` to change the credentials. The `.env` file is ignored by Git and must never be committed.
The database is only reachable from the API through the Compose network (hostname `db`); no database port is published to the host.

## How to test

```bash
# Create a message
curl -X POST http://localhost:3000/messages \
  -H "Content-Type: application/json" \
  -d '{"text": "hello"}'

# List messages
curl http://localhost:3000/messages
```

Check that the data survives a restart:

```bash
docker compose down        # keeps the db_data volume
docker compose up -d
curl http://localhost:3000/messages   # the message is still there
```

Stop everything (add `-v` only if you want to delete the stored data):

```bash
docker compose down
```
