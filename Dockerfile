FROM docker.io/python:3.13-alpine

WORKDIR /usr/src/app
COPY app.py app.py

ENTRYPOINT ["python3", "app.py"]