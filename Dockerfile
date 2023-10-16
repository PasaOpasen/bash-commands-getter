
# syntax=docker/dockerfile:1

FROM alpine 

RUN apk update && apk add python3 nodejs npm

WORKDIR /srv 

RUN npm install --save bash-parser

COPY ./parse_bash.js /srv/parse_bash.js

COPY ./main.py /srv/main.py

COPY ./data /srv/data
