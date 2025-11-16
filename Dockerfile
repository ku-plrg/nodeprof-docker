# syntax=docker/dockerfile:1

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    APP_HOME=/works/nodeprof

RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    ca-certificates \
    curl \
    git \
    build-essential \
    pkg-config \
    gnupg \
    dirmngr \
    && rm -rf /var/lib/apt/lists/*

RUN add-apt-repository -y ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       python3.11 \
       python3.11-dev \
       python3.11-venv \
    && rm -rf /var/lib/apt/lists/*

COPY . .
RUN chmod +x docker/build.sh
RUN ./docker/build.sh

RUN touch $HOME/.mx/jdk_cache
RUN printf "0\n" | /works/mx/select_jdk.py -p /works/nodeprof.js

ENV JAVA_HOME="$(cat /opt/java_home)"
ENV PATH="$JAVA_HOME/bin:${PATH}"
ENV PATH="/works/mx:${PATH}"

WORKDIR /works/nodeprof.js

# do npm install to cache node modules, intended to exit with code 1 (no input file)
RUN mx jalangi; \
    test $? -eq 1

VOLUME ["/works/nodeprof.js/input"]

WORKDIR /works/nodeprof.js/input

ENTRYPOINT ["/works/mx/mx"]
CMD ["--help"]
