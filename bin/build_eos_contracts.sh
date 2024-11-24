#!/usr/bin/env bash

####
# Builds savanna compatible contracts that installed into spring/nodeos
# does not install software
# called from Docker Build
###

CONTRACTS_GIT_COMMIT_TAG=${1:-v3.6.0}
NPROC=${2:-$(nproc)}
TUID=$(id -ur)

# must not be root to run
if [ "$TUID" -eq 0 ]; then
  echo "Can not run as root user exiting"
  exit
fi

ROOT_DIR=/local/eosnetworkfoundation
SPRING_BUILD_DIR="${ROOT_DIR}"/spring_build
SPRING_CONTRACT_DIR="${ROOT_DIR}"/repos/eos-system-contracts
LOG_DIR=/bigata1/log

cd "${SPRING_CONTRACT_DIR:?}" || exit
git checkout $CONTRACTS_GIT_COMMIT_TAG
git pull origin $CONTRACTS_GIT_COMMIT_TAG
mkdir build
cd build || exit
cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTS=ON -Dspring_DIR="${SPRING_BUILD_DIR}/lib/cmake/spring" .. >> "${LOG_DIR}"/reference_contracts_build.log 2>&1
make -j ${NPROC} >> "${LOG_DIR}"/reference_contracts_build.log 2>&1

TIME_CONTRACT_DIR="${ROOT_DIR}"/repos/eosio.time
cd "${TIME_CONTRACT_DIR:?}" || exit
cdt-cpp eosio.time.cpp
