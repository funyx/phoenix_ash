FROM debian:bullseye

ENV DOCKER_BUILDKIT=true
ENV DEBIAN_FRONTEND=noninteractive
ENV ZSH=/home/vscode
# elixir expects utf8.
ENV ELIXIR_VERSION="v1.13.4" \
	LANG=C.UTF-8 \
    OTP_VERSION="25.1.1" \
    REBAR3_VERSION="3.19.0" \
	REBAR_VERSION="2.6.4" \
	NODE_VERSION="16"

ENV NVM_DIR=/usr/local/share/nvm
ENV NVM_SYMLINK_CURRENT=true \
	PATH=${NVM_DIR}/current/bin:${PATH}

ARG SERVER_NAME=vscode
ARG SERVER_GROUP=vscode
ARG SERVER_GROUP_ID=1000
ARG SERVER_HOME=/home/vscode
ARG SERVER_USER=vscode
ARG SERVER_USER_ID=1000
ARG INSTALL_ZSH=true
ARG UPGRADE_PACKAGES=true
ARG ADDGROUP=docker

# create group if not existing
RUN addgroup --quiet --system --gid=$SERVER_GROUP_ID $SERVER_GROUP 2>/dev/null ||true
RUN addgroup --quiet --system --gid=1001 docker 2>/dev/null ||true
# create homedir if not existing
RUN test -d $SERVER_HOME || mkdir $SERVER_HOME
# create user if not existing
RUN adduser --quiet \
    --system \
    --ingroup=$SERVER_GROUP \
    --disabled-password \
    --uid=$SERVER_USER_ID \
    --shell=/bin/zsh \
    $SERVER_USER 2>/dev/null || true
# adjust passwd entry
RUN usermod --comment=$SERVER_NAME \
    --home=$SERVER_HOME \
    --gid=$SERVER_GROUP \
    $SERVER_USER

RUN if ![ dpkg-statoverride --list $SERVER_HOME >/dev/null ]; \
    then chown -R $SERVER_USER:${SERVER_GROUP} $SERVER_HOME; \
    chmod u=rwx,g=rxs,o= $SERVER_HOME; \
    fi
# add the user to the ADDGROUP group
RUN if [ test -n $ADDGROUP ]; \
    then if ![ groups $SERVER_USER | cut -d: -f2 | grep -qw $ADDGROUP ]; \
    then adduser $SERVER_USER $ADDGROUP; \
    fi \
    fi

COPY ./home/.ssh ${SERVER_HOME}/.ssh
RUN chown -R ${SERVER_USER}:${SERVER_GROUP} ${SERVER_HOME}/.ssh \
    && chmod 400 ${SERVER_HOME}/.ssh/**

RUN mkdir -p ${SERVER_HOME}/.vscode-server/extensions \
    ${SERVER_HOME}/.vscode-server-insiders/extensions \
    && chown -R ${SERVER_USER}:${SERVER_GROUP} \
    ${SERVER_HOME}/.vscode-server \
    ${SERVER_HOME}/.vscode-server-insiders

RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
	ca-certificates \
	curl \
	netbase \
	wget \
	gnupg \
	dirmngr \
	git \
	mercurial \
	openssh-client \
	subversion \
	procps \
	autoconf \
	automake \
	bzip2 \
	dpkg-dev \
	file \
	g++ \
	gcc \
	imagemagick \
	libbz2-dev \
	libc6-dev \
	libcurl4-openssl-dev \
	libdb-dev \
	libevent-dev \
	libffi-dev \
	libgdbm-dev \
	libglib2.0-dev \
	libgmp-dev \
	libjpeg-dev \
	libkrb5-dev \
	liblzma-dev \
	libmagickcore-dev \
	libmagickwand-dev \
	libmaxminddb-dev \
	libncurses5-dev \
	libncursesw5-dev \
	libpng-dev \
	libpq-dev \
	libreadline-dev \
	libsqlite3-dev \
	libssl-dev \
	libtool \
	libwebp-dev \
	libxml2-dev \
	libxslt-dev \
	libyaml-dev \
	make \
	patch \
	unzip \
	xz-utils \
	zlib1g-dev \
	inotify-tools

# common
COPY ./library-scripts/common-debian.sh /tmp/library-scripts/common-debian.sh
RUN bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${SERVER_USER}" "${SERVER_USER_ID}" "${SERVER_GROUP_ID}" "${UPGRADE_PACKAGES}" "${INSTALL_ZSH}" "${UPGRADE_PACKAGES}"

# [enable non-root docker access flag] [non-root user] [use moby] [Engine/CLI Version] [Major version for docker-compose]
COPY ./library-scripts/docker-in-docker-debian.sh /tmp/library-scripts/docker-in-docker-debian.sh
RUN /bin/bash /tmp/library-scripts/docker-in-docker-debian.sh "true" "${SERVER_USER}" "true" "latest" "v2"

# .zshrc
COPY ./home/.zshrc ${SERVER_HOME}/.zshrc
RUN chown ${SERVER_USER}:${SERVER_GROUP} ${SERVER_HOME}/.zshrc

# elixir
COPY ./library-scripts/elixir-install.sh /tmp/library-scripts/elixir-install.sh
RUN /bin/bash /tmp/library-scripts/elixir-install.sh

RUN mkdir -p /var/tmp/history && chown -R ${SERVER_USER}:${SERVER_GROUP} /var/tmp/history
ENV ERL_AFLAGS="-kernel shell_history enabled -kernel shell_history_path '\"/var/tmp/history/erlang.history\"'"

RUN apt-get -y install --no-install-recommends \
    jq \ 
    fzf

COPY ./start.sh /usr/start.sh

USER vscode

RUN /bin/bash -c 'mix local.rebar --force && \
	mix local.hex --force && \
	mix archive.install hex phx_new --force'

ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD ["/usr/start.sh"]