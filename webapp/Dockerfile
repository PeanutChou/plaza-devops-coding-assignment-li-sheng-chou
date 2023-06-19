FROM python:3.10.4-slim

EXPOSE 8000/tcp
RUN apt-get update

WORKDIR /app
ADD . /app

RUN pip install -r /app/requirements.txt