# nr-demo

A fake sentiment analyzer written in plain Python.
It cleans text and classifies it as positive, negative or neutral using simple word lists.

## Branch model

- `main`: production, the only source of truth for released code
- `develop`: integration branch for finished features
- `feature/*`: new features, branched from `develop` and merged back into `develop`
- `hotfix/*`: urgent fixes, branched from `main` and merged back into both `main` and `develop`

## Commit convention

Commits follow Conventional Commits: `type: short message`.

- `feat`: a new feature
- `fix`: a bug fix
- `docs`: documentation only changes
- `refactor`: code change that neither fixes a bug nor adds a feature
- `chore`: maintenance and tooling

## Usage

```python
from src.preprocessing import clean_text
from src.classifier import classify

text = clean_text("I love this, it is great!")
print(classify(text))  # positive
```
