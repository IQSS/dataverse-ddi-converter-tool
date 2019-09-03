FROM python:3.7-alpine

RUN mkdir -p /usr/src/app && mkdir /usr/src/temp
WORKDIR /usr/src/app

COPY requirements.txt /usr/src/app/

RUN apk add curl && \
    apk add --no-cache --virtual .build-deps gcc libc-dev libxslt-dev && \
    apk add --no-cache libxslt && \
    pip3 install -r requirements.txt && \
    pip3 install --no-cache-dir lxml connexion[swagger-ui] flask-debugtoolbar flask_cors lxml xmltodict pyDataverse && \
    apk del .build-deps

COPY . /usr/src/app

COPY config.py /usr/src/app/swagger_server

EXPOSE 8520

ENTRYPOINT ["python3"]

#CMD ["-f", "/dev/null"]
CMD ["-m", "swagger_server"]