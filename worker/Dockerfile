FROM python:3.9-slim

LABEL org.opencontainers.image.authors="Nikola MILOVANOVIC"

WORKDIR /workerapp

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=9000

RUN useradd -m workeruser
USER workeruser

CMD ["flask", "run"]
