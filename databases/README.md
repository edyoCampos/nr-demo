# Databases Exercises

This folder gathers the database exercises from the bootcamp: PostgreSQL (relational) and MongoDB (non-relational).

| Folder | Exercise | Main concepts |
| --- | --- | --- |
| [exercise-1](./exercise-1) | Relational database (basic SQL) | `CREATE TABLE`, primary and foreign keys, `INSERT`, `SELECT` |
| [exercise-2](./exercise-2) | Relational database (JOINs and filters) | `INNER JOIN`, `WHERE`, `UPDATE`, `LEFT JOIN` |
| [exercise-3](./exercise-3) | Non-relational database (basic CRUD) | MongoDB collection, flexible schema, `insertOne()`, `find()` |
| [exercise-4](./exercise-4) | Non-relational database (advanced queries) | `updateOne()`, queries in arrays and nested documents, dev/prod environments |

## Prerequisites

- Docker
- Docker Compose v2

## Environment

[`docker-compose.yml`](./docker-compose.yml) is the official file of the bootcamp, kept without changes. It starts both databases:

| Service | Image | Container | Port | Used in |
| --- | --- | --- | --- | --- |
| `db_postgres` | `postgres:16-alpine` | `orion_postgres_db` | 5432 | exercises 1 and 2 |
| `db_mongo` | `mongo:latest` | `orion_mongo_db` | 27017 | exercises 3 and 4 |

Start the environment from this folder:

```bash
cd databases
docker compose up -d
docker compose ps
```

Both services should be `healthy`, and each one answers a connection test:

![Environment up](00-environment-up.png)

Stop the environment with `docker compose down`. The data is kept in named volumes. Use `docker compose down -v` to remove it too.

## Connection data

PostgreSQL (DBeaver, Beekeeper or pgAdmin):

- Host: `localhost`
- Port: `5432`
- Database: `orion_db`
- User: `orion_user`
- Password: `orion_password`

MongoDB, connection string (URI):

```
mongodb://orion_admin:orion_admin_pass@localhost:27017/
```

## General notes

- Run the exercises in order. Exercise 2 uses the tables from exercise 1, and exercise 4 uses the collection from exercise 3.
- Each exercise README has the exact commands, run from the exercise folder, and the results.
- Ports used: `5432` (PostgreSQL), `27017` (main MongoDB), `27018` (dev) and `27019` (prod) in exercise 4.
