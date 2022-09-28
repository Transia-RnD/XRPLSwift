FROM cimg/base:2020.05

LABEL maintainer="BytesGuy <bytesguy@users.noreply.github.com>"

ENV SWIFTLINT_VERSION 0.46.5
ENV SWIFT_VERSION 5.6.1

USER root

# Install Swift
WORKDIR /home/circleci
RUN apt-get update && apt-get install -y --no-install-recommends binutils git libc6-dev libcurl4 libedit2 libgcc-5-dev libpython2.7 libsqlite3-0 libstdc++-5-dev libxml2 pkg-config tzdata zlib1g-dev && \
    wget https://swift.org/builds/swift-${SWIFT_VERSION}-release/ubuntu1804/swift-${SWIFT_VERSION}-RELEASE/swift-${SWIFT_VERSION}-RELEASE-ubuntu18.04.tar.gz && \
    mkdir /home/circleci/swift && \
    tar xzf swift-${SWIFT_VERSION}-RELEASE-ubuntu18.04.tar.gz --strip 1 -C /home/circleci/swift && \
    cp -r /home/circleci/swift/usr/* /usr/local && \
    rm -rf swift* && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install SwiftLint
RUN git clone https://github.com/realm/SwiftLint.git
WORKDIR /home/circleci/SwiftLint
RUN git checkout tags/${SWIFTLINT_VERSION} && \
    git submodule update --init --recursive; make install
WORKDIR /home/circleci
RUN rm -rf SwiftLint && \
    swiftlint version

WORKDIR /home/circleci/project
USER circleci