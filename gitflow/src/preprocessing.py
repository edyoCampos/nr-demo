import string


def clean_text(text):
    """Lowercase the text and remove all punctuation."""
    return text.lower().translate(str.maketrans("", "", string.punctuation))
