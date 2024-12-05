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
RUN BIN_URL=$(curl -s https://api.github.com/repos/MostroP2P/mostro-cli/releases/latest | grep -oP '"browser_download_url":\s*"\K[^"]+' | grep x86_64 | grep linux-musl) \
  && TMP_DIR=$(mktemp -d) \
  && cd $TMP_DIR \
  && curl -SLO $BIN_URL \
  && tar -xzf ${BIN_URL##*/} \
  && DIR_NAME=${BIN_URL##*mostro-cli-} && DIR_NAME=${DIR_NAME%.tar.gz} \
  && install $DIR_NAME/mostro-cli /usr/local/bin \
  && cd - \
  && rm -rf $TMP_DIR

# install nak nostr tool
RUN BIN_URL=$(curl -s https://api.github.com/repos/fiatjaf/nak/releases/latest | grep -oP '"browser_download_url":\s*"\K[^"]+' | grep linux-amd64) \
  && TMP_DIR=$(mktemp -d) \
  && cd $TMP_DIR \
  && curl -SLO $BIN_URL \
  && install ${BIN_URL##*/} /usr/local/bin/nak \
  && cd - \
  && rm -rf $TMP_DIR

COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

COPY settings.toml /home/mostro/.mostro/settings.toml
COPY empty.db /home/mostro/.mostro/mostro.db

WORKDIR "/home/mostro"

ENTRYPOINT ["/entrypoint.sh"]

CMD ["mostrod", "-d", "/home/mostro/.mostro"]