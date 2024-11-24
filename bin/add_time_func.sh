#!/usr/bin/env bash

ENDPOINT_ONE=${1:-http://127.0.0.1:8888}
account_name=eosio.time
CONTRACT_DIR=/local/eosnetworkfoundation/repos/eosio.time/

cleos --url $ENDPOINT_ONE set contract ${account_name} ${CONTRACT_DIR} eosio.time.wasm eosio.time.abi -p ${account_name}@active
