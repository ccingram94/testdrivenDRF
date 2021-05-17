# pull official base image
FROM python:3.9.1-slim-buster

# set working directory
WORKDIR /usr/src/app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV DEBUG 0
ENV SECRET_KEY foo
ENV DJANGO_ALLOWED_HOSTS localhost 127.0.0.1 [::1]

# install system dependencies
RUN apt-get update \
  && apt-get -y install gcc postgresql \
  && apt-get clean

# add and install requirements
RUN pip install --upgrade pip
COPY ./requirements.txt .
RUN pip install -r requirements.txt

# add app
COPY . .

# add and run as non-root user
RUN adduser --disabled-password myuser
USER myuser

# run gunicorn
CMD gunicorn drf_project.wsgi:application --bind 0.0.0.0:$PORT