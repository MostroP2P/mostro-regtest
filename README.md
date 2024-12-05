# Mostro Regtest

![TESTS](https://github.com/lnbits/legend-regtest-enviroment/actions/workflows/ci.yml/badge.svg)

# Services

Here is the complete list of services:
* mostro
* nostr-relay
* bitcoind
* lnd: Lightning Node
* thunderhub

# Installing regtest 
Get the regtest environment ready
```sh
# Install docker https://docs.docker.com/engine/install/
# Make sure your user has permission to use docker 'sudo usermod -aG docker ${USER}' then reboot
# Stop/start docker 'sudo systemctl stop docker' 'sudo systemctl start docker'

git clone https://github.com/MostroP2P/mostro-regtest.git
cd mostro-regtest
./devenv start
```

## Stopping regtest
Stop the regtest environment
```
./devenv stop
```

# Mostro config
```txt
- mnemonic: monster monster monster monster monster monster monster monster monster monster monster trade
- private key: e074ab631273b52479eccda1e1aea6ed5e8400906f5a9dd20422e14e56b5da59
- public key: 724497f34e6c4f55f9aa90f5e9dcc326c76a9f2ed817b0f0eb940ee7218ac8d5
```

Use the public key to communicate with Regtest Mostro instance.

# Docker published ports:

- bitcoind
  - 18443 -> RPC
  - 29000 -> ZMQ TX
  - 29001 -> ZMQ BLOCK
  - 29002 -> ZMQ HASH BLOCK
- lnd
  - 10001 -> RPC
  - 8081 -> REST
- nostr_relay
  - 8080 -> WS
- thunderhub
  - 3000 -> HTTP

Access Thunderhub as a logged in user from:
`http://localhost:3000/sso?token=1`

# Debugging Docker logs
```sh
docker compose logs bitcoin -f
docker compose logs mostro_lnd -f
docker compose logs nostr_relay -f
docker compose logs mostro -f
```
