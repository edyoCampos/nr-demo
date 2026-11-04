import string


def clean_text(text):
    return text.lower().translate(str.maketrans("", "", string.punctuation))
