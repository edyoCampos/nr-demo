def classify(text):
    positive = {"good", "great", "happy", "love", "excellent"}
    negative = {"bad", "terrible", "sad", "hate", "awful"}
    words = text.lower().split()
    score = sum(w in positive for w in words) - sum(w in negative for w in words)
    if score > 0:
        return "positive"
    if score < 0:
        return "negative"
    return "neutral"
