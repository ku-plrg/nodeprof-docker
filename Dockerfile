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

RUN /works/mx/select_jdk.py -p /works/nodeprof.js

WORKDIR /works/nodeprof.js
VOLUME ["/works/nodeprof.js/input"]

ENTRYPOINT ["/works/mx/mx"]
CMD ["--help"]
