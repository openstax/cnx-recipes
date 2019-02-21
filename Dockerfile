# docker build -t cnx-recipes .
# copied from https://hub.docker.com/r/openstax/selenium-base/dockerfile
FROM openstax/ci-image:latest

RUN apt-get update
RUN apt-get install \
    libxml2-utils \
    xsltproc

COPY \
    .python-version \
    .node-version \
    requirements.txt \
    package.json \
    yarn.lock \
    books.txt \
    ./

COPY ./script/ ./script/

RUN ./script/setup

# For testing
COPY ./styles ./styles
COPY ./recipes ./recipes
COPY ./tests ./tests
COPY ./cnxrecipes ./cnxrecipes
COPY ./js ./js