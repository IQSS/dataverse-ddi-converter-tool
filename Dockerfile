FROM openjdk:11.0.11

RUN mkdir -p /usr/src/app && mkdir /usr/src/temp
WORKDIR /usr/src/app
ENV FLASK_ENV=development

COPY requirements.txt /usr/src/app/

RUN apt-get update && apt-get install -y curl && \
    apt-get install -y python3 python3-dev python3-pip gcc libc-dev libxslt-dev && \
    apt-get install -y libsaxonb-java libxml2 && \
    pip3 install -r requirements.txt && \
    pip3 install yq jq lxml connexion[swagger-ui] flask-debugtoolbar flask_cors lxml xmltodict pyDataverse 

COPY . /usr/src/app

COPY config.py /usr/src/app/dct_server

EXPOSE 8520

ENTRYPOINT ["python3"]

CMD ["-m", "dct_server"]
