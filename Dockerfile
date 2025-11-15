# syntax=docker/dockerfile:1

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    APP_HOME=/opt/nodeprof

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

WORKDIR ${APP_HOME}
COPY . .
RUN chmod +x docker/build.sh

RUN ./docker/build.sh

WORKDIR /works
VOLUME ["/works/input"]

# ENV PATH="${APP_HOME}/bin:${PATH}" \
#     CLI_BIN="${APP_HOME}/bin/nodeprof"

ENTRYPOINT ["/works/mx"]
CMD ["--help"]
