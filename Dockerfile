# syntax=docker/dockerfile:1

############################################
# Build stage - install toolchain, clone deps, build CLI
############################################
FROM ubuntu:22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive \
    APP_HOME=/opt/nodeprof

RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    ca-certificates \
    curl \
    git \
    build-essential \
    pkg-config \
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
RUN chmod +x docker/build.sh docker/entrypoint.sh scripts/build.sh

ARG REPO_LIST=docker/repos.txt
RUN ./docker/build.sh ${REPO_LIST} ${APP_HOME}/sources scripts/build.sh ${APP_HOME}/bin

############################################
# Runtime stage - lightweight image with CLI entrypoint
############################################
FROM ubuntu:22.04 AS runtime

ENV DEBIAN_FRONTEND=noninteractive \
    APP_HOME=/opt/nodeprof

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.11 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder ${APP_HOME}/bin ${APP_HOME}/bin
COPY --from=builder ${APP_HOME}/docker/entrypoint.sh /usr/local/bin/nodeprof-entrypoint
RUN chmod +x /usr/local/bin/nodeprof-entrypoint

WORKDIR /workspace
VOLUME ["/workspace/input"]
ENV PATH="${APP_HOME}/bin:${PATH}" \
    CLI_BIN="${APP_HOME}/bin/nodeprof"

ENTRYPOINT ["/usr/local/bin/nodeprof-entrypoint"]
CMD ["--help"]
