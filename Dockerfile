ARG ARG_IMAGE_FROM=docker.io/ubuntu:jammy
############ RELEASE ARTIFACT ############
FROM ${ARG_IMAGE_FROM} AS jetson_release_artifact

ARG JETSON_VERSION_MAJOR=36
ARG JETSON_VERSION_MINOR=4
ARG JETSON_VERSION_PATCH=3
ARG JETSON_VERSION=${JETSON_VERSION_MAJOR}.${JETSON_VERSION_MINOR}.${JETSON_VERSION_PATCH}
ARG JETSON_LINUX_RELEASE_URI="https://developer.nvidia.com/downloads/embedded/l4t/r${JETSON_VERSION_MAJOR}_release_v${JETSON_VERSION_MINOR}.${JETSON_VERSION_PATCH}/release"
ARG JETSON_LINUX_RELEASE_PACKAGE_NAME="Jetson_Linux_r${JETSON_VERSION}_aarch64.tbz2"
ARG JETSON_LINUX_RELEASE_PACKAGE_URL="${JETSON_LINUX_RELEASE_URI}/${JETSON_LINUX_RELEASE_PACKAGE_NAME}"

ENV JETSON_LINUX_RELEASE_PACKAGE_URL=${JETSON_LINUX_RELEASE_PACKAGE_URL}

ADD ${JETSON_LINUX_RELEASE_PACKAGE_URL} /jetson_linux_release.tbz2
WORKDIR /workspace
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked  \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && apt-get install -y lbzip2 && \
    tar --use-compress-program=lbzip2 -xf /jetson_linux_release.tbz2 --strip-components=1

############ BUILDER ############
FROM ${ARG_IMAGE_FROM}

ARG JETSON_VERSION_MAJOR=36
ARG JETSON_VERSION_MINOR=4
ARG JETSON_VERSION_PATCH=3
ARG JETSON_VERSION=${JETSON_VERSION_MAJOR}.${JETSON_VERSION_MINOR}.${JETSON_VERSION_PATCH}
ARG JETSON_LINUX_RELEASE_URI="https://developer.nvidia.com/downloads/embedded/l4t/r${JETSON_VERSION_MAJOR}_release_v${JETSON_VERSION_MINOR}.${JETSON_VERSION_PATCH}/release"
ARG JETSON_LINUX_RELEASE_PACKAGE_NAME="Jetson_Linux_r${JETSON_VERSION}_aarch64.tbz2"
ARG JETSON_LINUX_RELEASE_PACKAGE_URL="${JETSON_LINUX_RELEASE_URI}/${JETSON_LINUX_RELEASE_PACKAGE_NAME}"

ENV JETSON_VERSION_MAJOR=${JETSON_VERSION_MAJOR} \
    JETSON_VERSION_MINOR=${JETSON_VERSION_MINOR} \
    JETSON_VERSION_PATCH=${JETSON_VERSION_PATCH} \
    JETSON_VERSION=${JETSON_VERSION} \
    JETSON_LINUX_RELEASE_URI=${JETSON_LINUX_RELEASE_URI} \
    JETSON_LINUX_RELEASE_PACKAGE_NAME=${JETSON_LINUX_RELEASE_PACKAGE_NAME} \
    JETSON_LINUX_RELEASE_PACKAGE_URL=${JETSON_LINUX_RELEASE_PACKAGE_URL}

COPY --from=jetson_release_artifact /workspace /workspace

WORKDIR /workspace

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked  \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && apt-get install -y \
        bc \
        bison \
        build-essential \
        bzip2 \
        cpp \
        curl \
        device-tree-compiler \
        efibootmgr \
        flex \
        git-core \
        kmod \
        lbzip2 \
        libssl-dev \
        mkbootimg \
        nano \
        pigz \
        python3 \
        qemu-user-static \
        sudo \
        tar \
        tzdata \
        unzip \
        wget  \
        xz-utils

RUN export DEBIAN_FRONTEND=noninteractive && \
    ./tools/l4t_flash_prerequisites.sh

CMD ["/bin/bash"]

LABEL org.opencontainers.image.title="NVIDIA Jetson Builder Image" \
      org.opencontainers.image.version="${JETSON_VERSION}" \
      org.opencontainers.image.description="Container image based on NVIDIA's official Jetson release package"
