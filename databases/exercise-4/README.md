# Exercise 4: Non-relational database (advanced queries)

Add comments to a post, query inside arrays and nested documents, and run the same collection in independent dev and prod environments.

## Files

| File | Purpose |
| --- | --- |
| `exercise-4.js` | `updateOne()` adding `comentarios`, and the `find()` queries. |
| `Dockerfile.dev` | Dev image: `mongo:9.0.4` with `MONGO_INITDB_DATABASE=orion_db`. |
| `Dockerfile.prod` | Prod image: same base, plus the init script copied in and a healthcheck. |
| `docker-compose.dev.yml` | Dev environment on port 27018. Mounts local files. |
| `docker-compose.prod.yml` | Prod environment on port 27019. No volumes. |
| `../.dockerignore` | Build context filter for both images (the context is `databases/`). |

## How it works

- **Same collection as exercise 3.** Both environments reuse [`../exercise-3/exercise-3.js`](../exercise-3/exercise-3.js) as the init script in `/docker-entrypoint-initdb.d/`, with `MONGO_INITDB_DATABASE=orion_db`. On the first start, each environment gets the `posts` collection with the same 2 documents, and no data is duplicated.
  - **Dev** bind-mounts the script as read-only, so it can be edited without rebuilding.
  - **Prod** copies the script into the image with a single `COPY`, so it needs no mounts.
- **Build context.** Both compose files build with `context: ..` (the `databases/` folder) so the Dockerfiles can reach `exercise-3/exercise-3.js`. `databases/.dockerignore` ignores everything except that file.
- **Independent environments.** Each compose file has its own project name (`exercise-4-dev`, `exercise-4-prod`), container, network, image and port. The main `db_mongo` stays on 27017, dev on 27018 and prod on 27019, with no conflicts.
- **Image.** The base is `mongo:9.0.4`, pinned to the same version that `mongo:latest` resolved to when the environment was created. The official image has no alpine or slim variant (about 1.5 GB on disk), so the prod image adds only one small layer (the init script) and installs nothing else.

## How to run

Start the main environment first (see [databases/README.md](../README.md)). Run these commands from this folder.

### Main environment (`db_mongo`)

```bash
docker exec -i orion_mongo_db mongosh "mongodb://orion_admin:orion_admin_pass@localhost:27017/orion_db?authSource=admin" --quiet --file /dev/stdin < ../exercise-3/exercise-3.js
docker exec -i orion_mongo_db mongosh "mongodb://orion_admin:orion_admin_pass@localhost:27017/orion_db?authSource=admin" --quiet --file /dev/stdin < exercise-4.js
```

### Dev (port 27018)

```bash
docker compose -f docker-compose.dev.yml up -d --build --wait
docker exec -i orion_mongo_dev mongosh "mongodb://orion_admin:orion_admin_pass@localhost:27017/orion_db?authSource=admin" --quiet --file /dev/stdin < exercise-4.js
docker compose -f docker-compose.dev.yml down -v
```

### Prod (port 27019)

```bash
docker compose -f docker-compose.prod.yml up --wait
docker exec -i orion_mongo_prod mongosh "mongodb://orion_admin:orion_admin_pass@localhost:27017/orion_db?authSource=admin" --quiet --file /dev/stdin < exercise-4.js
docker compose -f docker-compose.prod.yml down -v
```

`docker compose -f docker-compose.prod.yml up` in the foreground also works: the init script runs, the container becomes healthy and the logs keep streaming until it is stopped. `--wait` returns as soon as the container is healthy, which gives a short output.

### Prod and volumes

`docker-compose.prod.yml` does not declare any volume or mount. The official mongo image, however, declares `VOLUME /data/db` and `VOLUME /data/configdb`, so Docker creates anonymous volumes for them anyway. Use `down -v` to remove them when stopping prod.

## Results

`exercise-4.js` runs the statements below. Prints 01 to 04 run each one on its own in the main environment, after `exercise-3.js`.

### 1. updateOne

Adds `comentarios`, an array of documents, to the post "Introdução ao MongoDB".

![updateOne](01-update-one.png)

### 2. find() inside an array

Only the posts with the tag `nosql`.

![find by tag](02-find-tag-nosql.png)

### 3. find() by author

Only the posts whose author is "Carlos Lima".

![find by author](03-find-by-author.png)

### 4. find() inside nested documents

Posts with a comment by "Ana Souza", querying `comentarios.autor`.

![find by comment author](04-find-nested-comments.png)

### Dev environment

`exercise-4.js` on `orion_mongo_dev`, started from scratch. The `posts` collection comes from the init script.

![queries in dev](05-dev-queries.png)

### Prod environment

`exercise-4.js` on `orion_mongo_prod`, started from scratch.

![queries in prod](06-prod-queries.png)

### Prod compose up

`docker compose -f docker-compose.prod.yml up --wait` waits for the container to be healthy.

![prod compose up](07-prod-compose-up.png)
