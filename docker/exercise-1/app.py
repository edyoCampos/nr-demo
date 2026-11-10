"""Minimal Flask app used in docker exercise 1."""

from flask import Flask

app = Flask(__name__)


@app.route("/")
def hello():
    """Return a greeting message."""
    return "Hello from Docker!"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000)
