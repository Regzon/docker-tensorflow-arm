ARG PYTHON_VERSION_SHORT=3.5
ARG TENSORFLOW_VERSION=1.12.0

# download qemu-user-static for amd64
# to build and run on x86_64 (requires binfmt_misc)
FROM ubuntu as x86_64
RUN set -e; \
    apt-get update; \
    apt-get install -y --no-install-recommends qemu-user-static; \
    rm -rf /var/lib/apt/lists/*

# download openjdk binaries
FROM arm32v7/python:${PYTHON_VERSION_SHORT}-stretch as openjdk
COPY --from=x86_64 /usr/bin/qemu-*-static /usr/bin/

RUN set -e; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        apt-utils \
        build-essential \
        wget \
        zip \
        unzip \
        curl \
        pkg-config \
        rsync \
        libfreetype6-dev \
        libpng-dev \
        libzmq3-dev \
        libhdf5-dev \
        python3-numpy \
        python3-scipy; \
    rm -rf /var/lib/apt/lists/*

COPY *.whl .

ARG PYTHON_VERSION_SHORT
ENV PYTHON_VERSION=$PYTHON_VERSION_SHORT

ARG TENSORFLOW_VERSION
ENV TENSORFLOW_VERSION=$TENSORFLOW_VERSION

RUN bash -c 'pip install tensorflow-${TENSORFLOW_VERSION}-cp${PYTHON_VERSION/./}-none-linux_armv7l.whl'

CMD ["python"]
