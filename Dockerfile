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

FROM python:3.7.10-buster

# No interactive frontend during docker build
ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true

ENV TERM=xterm

# Install pyenv
RUN curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
ENV PATH "/root/.pyenv/bin:$PATH"
RUN eval "$(pyenv init -)"
RUN eval "$(pyenv virtualenv-init -)"

# Install rbenv and nodenv
RUN git clone https://github.com/rbenv/rbenv.git /root/.rbenv && \
    git clone https://github.com/rbenv/ruby-build.git /root/.rbenv/plugins/ruby-build && \
    git clone https://github.com/nodenv/nodenv.git /root/.nodenv && \
    git clone https://github.com/nodenv/node-build.git /root/.nodenv/plugins/node-build && \
    git clone https://github.com/nodenv/nodenv-package-rehash.git /root/.nodenv/plugins/nodenv-package-rehash && \
    git clone https://github.com/nodenv/nodenv-update.git /root/.nodenv/plugins/nodenv-update
ENV PATH /root/.rbenv/shims:/root/.rbenv/bin:/root/.nodenv/shims:/root/.nodenv/bin:$PATH

# Set the working dir
WORKDIR /code

# Install commonly used versions of python and node
RUN pyenv install 3.6.8 # cnx-recipes
RUN cd /root/.nodenv/plugins/node-build && git pull && cd - && nodenv install 10.15.3 # cnx-recipes

# Install dependencies for Chrome
# From https://github.com/GoogleChrome/puppeteer/blob/master/.ci/node8/Dockerfile.linux
RUN apt-get update && \
    apt-get -y install xvfb gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 \
      libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 \
      libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 \
      libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 \
      libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget && \
    rm -rf /var/lib/apt/lists/*

#############################################################################################################    

FROM openstax/ci-image:latest as build-os-dependencies
WORKDIR /code

RUN apt-get update
RUN apt-get install \
    libxml2-utils \
    xsltproc \
    shellcheck

# Setup dart
RUN apt-get install apt-transport-https
RUN sh -c 'wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -' && \
    sh -c 'wget -qO- https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
RUN apt-get update && apt-get install dart

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

# dart pub get doesn't find the pubspec file until after the above line is run
RUN dart pub get
