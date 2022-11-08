FROM python:3.10-alpine

WORKDIR /usr/src/app
COPY app.py app.py

ENTRYPOINT ["python3", "app.py"]