POSITIVE_WORDS = {"good", "great", "happy", "love", "excellent"}
NEGATIVE_WORDS = {"bad", "terrible", "sad", "hate", "awful"}


def classify(text):
    words = text.lower().split()
    score = sum(w in POSITIVE_WORDS for w in words) - sum(w in NEGATIVE_WORDS for w in words)
    if score > 0:
        return "positive"
    if score < 0:
        return "negative"
    return "neutral"
