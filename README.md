# nr-demo

Bootcamp exercises repository, organized by content.

## Repository contents

| Folder | Content | Details |
| --- | --- | --- |
| [gitflow/](./gitflow) | Git and Git Flow | [gitflow/README.md](./gitflow/README.md) |
| [docker/](./docker) | Docker | [docker/README.md](./docker/README.md) |

## Branch model

- `main`: production, the only source of truth for released code
- `develop`: integration branch for finished features
- `feature/*`: new features, branched from `develop` and merged back into `develop`
- `hotfix/*`: urgent fixes, branched from `main` and merged back into both `main` and `develop`

## Workflow

1. Create one branch per content from `develop`.
2. Open a pull request to `develop`.
3. The mentor reviews and merges the pull request.
4. After approval, `develop` is merged into `main`.

## Commit convention

Commits follow Conventional Commits: `type: short message`.

- `feat`: a new feature
- `fix`: a bug fix
- `docs`: documentation only changes
- `refactor`: code change that neither fixes a bug nor adds a feature
- `chore`: maintenance and tooling
