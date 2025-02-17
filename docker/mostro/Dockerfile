FROM debian:stable-slim

RUN apt-get update -y \
  && apt-get install -y curl gosu jq \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install mostrod
RUN BIN_URL=$(curl -s https://api.github.com/repos/MostroP2P/mostro/releases/latest | grep -oP '"browser_download_url":\s*"\K[^"]+' | grep x86_64 | grep linux-musl) \
  && TMP_DIR=$(mktemp -d) \
  && cd $TMP_DIR \
  && curl -SLO $BIN_URL \
  && tar -xzf ${BIN_URL##*/} \
  && DIR_NAME=${BIN_URL##*mostro-} && DIR_NAME=${DIR_NAME%.tar.gz} \
  && install $DIR_NAME/mostrod /usr/local/bin \
  && cd - \
  && rm -rf $TMP_DIR

# install mostro-cli
RUN apt-get update && \
    apt-get install -y \
    git \
    curl \
    build-essential \
    pkg-config \
    libssl-dev \
    && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && . $HOME/.cargo/env \
    && git clone https://github.com/MostroP2P/mostro-cli.git \
    && cd mostro-cli \
    && cargo build --release \
    && install target/release/mostro-cli /usr/local/bin \
    && cd .. \
    && rm -rf mostro-cli \
     # Install nak before cleanup
    && BIN_URL=$(curl -s https://api.github.com/repos/fiatjaf/nak/releases/latest | grep -oP '"browser_download_url":\s*"\K[^"]+' | grep linux-amd64) \
    && TMP_DIR=$(mktemp -d) \
    && cd $TMP_DIR \
    && curl -SLO $BIN_URL \
    && install ${BIN_URL##*/} /usr/local/bin/nak \
    && cd - \
    && rm -rf $TMP_DIR \
    # clean 
    && apt-get remove -y git build-essential \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf $HOME/.cargo

COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

COPY settings.toml /home/mostro/.mostro/settings.toml
COPY empty.db /home/mostro/.mostro/mostro.db

WORKDIR "/home/mostro"

ENTRYPOINT ["/entrypoint.sh"]

CMD ["mostrod", "-d", "/home/mostro/.mostro"]