# Docker Exercises

This folder gathers the Docker exercises from the bootcamp.

| Folder | Exercise | Main concepts |
| --- | --- | --- |
| [exercise-1](./exercise-1) | Dockerfile + Compose ("Hello Container") | Dockerfile, image build, Compose basics |
| [exercise-2](./exercise-2) | Compose with API + Database | Multi-service Compose, networking, environment variables |
| [exercise-3](./exercise-3) | Best practices + multiple environments (dev/prod) | Image hardening, Compose files per environment |
| [exercise-extra](./exercise-extra) | Full application (API, PostgreSQL, pgAdmin) | Full stack, persistent volumes, service orchestration |

## Prerequisites

- Docker
- Docker Compose v2

## General notes

- Run one exercise at a time to avoid port conflicts.
- Ports used: `3000`, `3001` (prod in exercise-3) and `8080` (pgAdmin).
- Where an exercise has environment variables, create the file first: `cp .env.example .env`.
- From exercise-3 onwards, images are scanned with Trivy. Details are in each exercise's README.
