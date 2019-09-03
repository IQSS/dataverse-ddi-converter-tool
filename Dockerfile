FROM python:3.7-alpine

RUN mkdir -p /usr/src/app && mkdir /usr/src/temp
WORKDIR /usr/src/app
ENV FLASK_ENV=development

COPY requirements.txt /usr/src/app/

RUN apk add curl && \
    apk add --no-cache --virtual .build-deps gcc libc-dev libxslt-dev && \
    apk add --no-cache libxslt && \
    pip3 install -r requirements.txt && \
    pip3 install --no-cache-dir lxml connexion[swagger-ui] flask-debugtoolbar flask_cors lxml xmltodict pyDataverse && \
    apk del .build-deps

COPY . /usr/src/app

COPY config.py /usr/src/app/dct_server

EXPOSE 8520

ENTRYPOINT ["python3"]

CMD ["-m", "dct_server"]