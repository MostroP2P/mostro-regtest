# Mostro Regtest

![TESTS](https://github.com/lnbits/legend-regtest-enviroment/actions/workflows/ci.yml/badge.svg)

# Nodes

Here is the complete list of nodes:
* mostro
* nostr-relay
* bitcoind
* lnd: Lightning Node


# Additional services

* mempool (api|web|db): Mempool Explorer
* fulcrum: Electrum Server

# Installing regtest 
Get the regtest environment ready
```sh
# Install docker https://docs.docker.com/engine/install/
# Make sure your user has permission to use docker 'sudo usermod -aG docker ${USER}' then reboot
# Stop/start docker 'sudo systemctl stop docker' 'sudo systemctl start docker'

git clone https://github.com/MostroP2P/mostro-regtest/
cd mostro-regtest
./start.sh  # start the regtest and also run tests
```
## Stopping regtest
Stop the regtest environment
```
./stop.sh # stop the regtest containers
```

# Running Nutshell on regtest
Add this ENV variables to your `.env` file (assuming that the `mostro-regtest` directory is in `../` from the `mostro` directory)
```sh
# LND
# NOSTR RELAY
# MOSTRO CORE
```


# URLs

* lnd rest: http://localhost:8081/

# Debugging Docker logs
```sh
docker logs mostro-regtest-bitcoind-1-f
docker logs mostro-regtest-lnd-1 -f
docker logs mostro-regtest-mostro-1 -f
docker logs nostr-relay -f
```
