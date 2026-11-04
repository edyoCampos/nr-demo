# nr-demo

A fake sentiment analyzer written in plain Python.
It cleans text and classifies it as positive, negative or neutral using simple word lists.

## Branch model

- `main`: initial state of the repository
- `develop`: integration branch for finished features
- `stage`: pre-release validation
- `production`: released code
- `feature/*`: new features, branched from and merged back into `develop`
- `hotfix/*`: urgent fixes for `production`

## Commit convention

Commits follow Conventional Commits: `type: short message`.

- `feat`: a new feature
- `fix`: a bug fix
- `docs`: documentation only changes
- `refactor`: code change that neither fixes a bug nor adds a feature
- `chore`: maintenance and tooling
