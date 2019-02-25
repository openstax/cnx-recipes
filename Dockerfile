##
## Create an image that can be used to play with
## cnx-recipes commands.
##
## To create the image:
##    docker build -t openstax/cnx-recipes:latest .
##
## To start the container:
##    docker run --mount type=bind,source=$(pwd),target=/src -it openstax/cnx-recipes:latest /bin/bash
## where the cnx-recipes repo has been cloned into the
## current working directory.
##
## To run the code:
##    ./scripts/test
## See:
##    https://github.com/openstax/cnx-recipes
## for details.
##

FROM openstax/ci-image:latest as build-os-dependencies
WORKDIR /code

RUN apt-get update
RUN apt-get install \
    libxml2-utils \
    xsltproc \
    unzip           # required by fetch-html

# Install python first (since it changes infrequently)
COPY .python-version ./
RUN pyenv install "$(< .python-version)"

# Install node (since it changes less frequently than code)
COPY .node-version ./
RUN nodenv install "$(< .node-version)"

# Install yarn for the specific version of node we are using
RUN nodenv local "$(< .node-version)"
RUN nodenv exec npm install --global yarn

FROM build-os-dependencies as build-dependencies

# Install dependencies
COPY \
    requirements.txt \
    package.json \
    yarn.lock \
    ./

COPY \
    ./script/bootstrap \
    ./script/setup \
    ./script/_bootstrap.sh \
    ./script/_setup.sh \
    ./script/

RUN ./script/setup

FROM build-dependencies as code

# Install code
COPY . ./
