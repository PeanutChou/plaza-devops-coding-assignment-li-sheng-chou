FROM python:3.10.4-slim

RUN apt-get update

ADD . /app

RUN pip install -r /app/requirements.txt

WORKDIR /app
CMD ["uvicorn","src.app:app","--reload"]