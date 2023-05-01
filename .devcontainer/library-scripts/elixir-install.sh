#!/bin/bash

set -ex

OTP_VERSION=${1:-"25.3.1"}
OTP_DOWNLOAD_SHA256=${2:-"4fafc922e012419205eeea482eb1e8d838377477f39c3ba8fc398d8b69029e14"}
REBAR_VERSION=${3:-"2.6.4"}
REBAR_DOWNLOAD_SHA256=${4:-"577246bafa2eb2b2c3f1d0c157408650446884555bf87901508ce71d5cc0bd07"}
REBAR3_VERSION=${5:-"3.20.0"}
REBAR3_DOWNLOAD_SHA256=${6:-"53ed7f294a8b8fb4d7d75988c69194943831c104d39832a1fa30307b1a8593de"}
ELIXIR_VERSION=${7:-"v1.14.4"}
ELIXIR_DOWNLOAD_SHA256=${8:-"07d66cf147acadc21bd1679f486efd6f8d64a73856ecc83c71b5e903081b45d2"}

OTP_DOWNLOAD_URL="https://github.com/erlang/otp/archive/OTP-${OTP_VERSION}.tar.gz"
REBAR_DOWNLOAD_URL="https://github.com/rebar/rebar/archive/${REBAR_VERSION}.tar.gz"
REBAR3_DOWNLOAD_URL="https://github.com/erlang/rebar3/archive/${REBAR3_VERSION}.tar.gz"
ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/${ELIXIR_VERSION}.tar.gz"


apt-get install -y --no-install-recommends \
		libodbc1 \
		libsctp1 \
		libwxgtk3.0 \
		libwxgtk-webview3.0-gtk3-0v5 \
		unixodbc-dev \
		libsctp-dev \
		libwxgtk-webview3.0-gtk3-dev

export ERL_TOP="/usr/src/otp_src_${OTP_VERSION%%@*}"
mkdir -vp $ERL_TOP
cd $ERL_TOP
curl -fSL -o otp-src.tar.gz "$OTP_DOWNLOAD_URL"

echo "$OTP_DOWNLOAD_SHA256  otp-src.tar.gz" | sha256sum -c -

tar -xzf otp-src.tar.gz --strip-components=1
rm otp-src.tar.gz
./otp_build autoconf
./configure --build="$(dpkg-architecture --query DEB_HOST_GNU_TYPE)"
make -j$(nproc)
make -j$(nproc) docs DOC_TARGETS=chunks
make install install-docs DOC_TARGETS=chunks

find /usr/local -name examples | xargs rm -rf

mkdir -p /usr/src/rebar-src
cd /usr/src/rebar-src
curl -fSL -o rebar-src.tar.gz "$REBAR_DOWNLOAD_URL"

echo "$REBAR_DOWNLOAD_SHA256 rebar-src.tar.gz" | sha256sum -c -

tar -xzf rebar-src.tar.gz --strip-components=1
rm rebar-src.tar.gz
./bootstrap
install -v ./rebar /usr/local/bin/
rm -rf /usr/src/rebar-src

mkdir -p /usr/src/rebar3-src
cd /usr/src/rebar3-src
curl -fSL -o rebar3-src.tar.gz "$REBAR3_DOWNLOAD_URL"

echo "$REBAR3_DOWNLOAD_SHA256 rebar3-src.tar.gz" | sha256sum -c -

tar -xzf rebar3-src.tar.gz --strip-components=1
rm rebar3-src.tar.gz
HOME=$PWD ./bootstrap
install -v ./rebar3 /usr/local/bin/
rm -rf /usr/src/rebar3-src

mkdir -p /usr/local/src/elixir
cd /usr/local/src/elixir
curl -fSL -o elixir-src.tar.gz "$ELIXIR_DOWNLOAD_URL"

echo "$ELIXIR_DOWNLOAD_SHA256  elixir-src.tar.gz" | sha256sum -c -

tar -xzf elixir-src.tar.gz --strip-components=1
rm elixir-src.tar.gz
make install clean
find /usr/local/src/elixir/ -type f -not -regex "/usr/local/src/elixir/lib/[^\/]*/lib.*" -exec rm -rf {} +
find /usr/local/src/elixir/ -depth -type d -empty -delete
