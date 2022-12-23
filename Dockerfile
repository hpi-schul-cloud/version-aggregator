FROM python:3.11-alpine

WORKDIR /usr/src/app
COPY app.py app.py

ENTRYPOINT ["python3", "app.py"]