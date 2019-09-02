##
## Create an image that can be used to play with
## cnx-recipes commands.
##
## To create the image:
##    docker build -t openstax/cnx-recipes:latest .
##
## To start the container:
##    docker run --mount type=bind,source=$(pwd),target=/code -it openstax/cnx-recipes:latest /bin/bash
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
    shellcheck

# Install docker
RUN apt-get install -y curl && \
    curl -sSL https://get.docker.com | sh

# Install docker-compose
ENV DOCKER_COMPOSE_VERSION=1.24.0
RUN curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose
RUN apt-get purge -y curl

# Install python first (since it changes infrequently)
COPY .python-version ./
RUN pyenv install --skip-existing "$(< .python-version)"

# Install node (since it changes less frequently than code)
COPY .node-version ./
RUN nodenv install --skip-existing "$(< .node-version)"

# Install yarn for the specific version of node we are using
RUN nodenv local "$(< .node-version)"
# https://stackoverflow.com/questions/46111738/how-to-install-global-module-in-docker
#
# When you run npm as root (this is the default user in Docker build) and
# install a global package, for security reasons, npm installs and executes
# binaries as user nobody, who doesn't have any permissions. This is for
# security reasons.
#
# Get around this by adding the --unsafe-perm flag
RUN nodenv exec npm install --global --unsafe-perm yarn

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

# Post-install builds the styles/output/_web-styles.json
# which is not needed for being in a docker container.
ENV SKIP_MY_POSTINSTALL=true

RUN ./script/setup

FROM build-dependencies as code

# Install code
COPY . ./
