"""Flask API with a health route and message persistence in PostgreSQL."""

import os
from contextlib import closing

import psycopg2
from flask import Flask, jsonify, request

app = Flask(__name__)


def get_connection():
    """Open a new database connection using environment variables."""
    return psycopg2.connect(
        host=os.environ["DB_HOST"],
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASS"],
        dbname=os.environ["DB_NAME"],
    )


def ensure_table(cur):
    """Create the messages table if it does not exist yet."""
    cur.execute(
        "CREATE TABLE IF NOT EXISTS messages ("
        "id SERIAL PRIMARY KEY, "
        "text TEXT NOT NULL, "
        "created_at TIMESTAMP NOT NULL DEFAULT NOW())"
    )


@app.route("/health", methods=["GET"])
def health():
    """Return the service health status."""
    return jsonify({"status": "ok"})


@app.route("/messages", methods=["POST"])
def create_message():
    """Store the message received as JSON {"text": "..."}."""
    payload = request.get_json(silent=True) or {}
    text = payload.get("text")
    if not text:
        return jsonify({"error": "field 'text' is required"}), 400
    with closing(get_connection()) as conn:
        with conn, conn.cursor() as cur:
            ensure_table(cur)
            cur.execute(
                "INSERT INTO messages (text) VALUES (%s) RETURNING id", (text,)
            )
            message_id = cur.fetchone()[0]
    return jsonify({"id": message_id, "text": text}), 201


@app.route("/messages", methods=["GET"])
def list_messages():
    """Return all stored messages."""
    with closing(get_connection()) as conn:
        with conn, conn.cursor() as cur:
            ensure_table(cur)
            cur.execute("SELECT id, text, created_at FROM messages ORDER BY id")
            rows = cur.fetchall()
    return jsonify(
        [
            {"id": row[0], "text": row[1], "created_at": row[2].isoformat()}
            for row in rows
        ]
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000)
