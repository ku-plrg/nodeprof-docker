# syntax=docker/dockerfile:1

FROM python:3.11-slim

ENV DEBIAN_FRONTEND=noninteractive \
    APP_HOME=/works/nodeprof

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    build-essential \
    pkg-config

COPY . .
RUN chmod +x docker/build.sh
RUN ./docker/build.sh

# remove build dependencies and clean up
RUN apt-get remove -y build-essential pkg-config
RUN apt-get autoremove -y
RUN rm -rf /var/lib/apt/lists/* ; rm -rf /tmp/* /var/tmp/*

RUN touch $HOME/.mx/jdk_cache
RUN printf "0\n" | /works/mx/select_jdk.py -p /works/nodeprof.js

ENV JAVA_HOME="$(cat /opt/java_home)"
ENV PATH="$JAVA_HOME/bin:${PATH}"
ENV PATH="/works/mx:${PATH}"

WORKDIR /works/nodeprof.js
RUN mkdir -p /works/nodeprof.js/input

# do npm install to cache node modules, intended to exit with code 1 (no input file)
RUN mx jalangi; \
    test $? -eq 1

WORKDIR /works/nodeprof.js/input
VOLUME ["/works/nodeprof.js/input"]

ENTRYPOINT ["/works/mx/mx"]
CMD ["--help"]
