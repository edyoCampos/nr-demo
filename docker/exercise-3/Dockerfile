FROM python:3.11-alpine AS base

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt


FROM base AS dev

ENV FLASK_APP=app.py

COPY . .

EXPOSE 3000

CMD ["flask", "run", "--reload", "--host", "0.0.0.0", "--port", "3000"]


FROM base AS prod

RUN addgroup -S app && adduser -S -G app app

COPY --chown=app:app . .

USER app

EXPOSE 3000

CMD ["gunicorn", "--bind", "0.0.0.0:3000", "app:app"]
