# Git Flow Exercise

This exercise demonstrates Git Flow with a fake sentiment analyzer written in plain Python.
It cleans text and classifies it as positive, negative or neutral using simple word lists.

## Structure

```
gitflow/
├── README.md
└── src/
    ├── preprocessing.py   # clean_text
    └── classifier.py      # classify
```

## Usage

Run from the `gitflow/` folder:

```bash
cd gitflow
python3 -c "
from src.preprocessing import clean_text
from src.classifier import classify

text = clean_text('I love this, it is great!')
print(classify(text))
"
```

Expected output: `positive`
