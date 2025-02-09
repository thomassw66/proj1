# Use Ubuntu 22.04 as the base image.
FROM ubuntu:22.04

# Set noninteractive mode for apt.
ENV DEBIAN_FRONTEND=noninteractive

# Install required dependencies for Bazel, Clang, and general tools.
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    curl \
    gnupg \
    lsb-release \
    wget \
    build-essential \
    openjdk-11-jdk

# Install Bazelisk 
#	https://github.com/bazelbuild/bazelisk/releases/download/v1.25.0/bazelisk-arm64.deb

# Define the Bazelisk version.
ENV BAZELISK_VERSION=1.25.0

# Download Bazelisk binary and install it as "bazel" in /usr/local/bin.
RUN curl -L https://github.com/bazelbuild/bazelisk/releases/download/v${BAZELISK_VERSION}/bazelisk-linux-amd64 \
    -o /usr/local/bin/bazel && \
    chmod +x /usr/local/bin/bazel

# Update and install Bazel.
# RUN apt-get update && apt-get install -y bazel

RUN apt-get install -y \
	software-properties-common

	# Add the official LLVM apt repository for Ubuntu 22.04 (jammy) and clang 19.
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    echo "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-19 main" > /etc/apt/sources.list.d/llvm-toolchain.list

# Update the package lists and install clang-19 and clang++-19.
RUN apt-get update && apt-get install -y --no-install-recommends \
    clang-19 \
    clang++-19

# 
# ------------------------------
# Clean up APT caches to reduce image size.
# ------------------------------
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the default command.
CMD ["bash"]
