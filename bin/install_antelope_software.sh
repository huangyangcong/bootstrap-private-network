#!/usr/bin/env bash

####
# Installs spring/nodeos and cdt software
# does not build software
# depends on successfull run of build_antelope_software.sh successfull
# called from Docker Build
###

TUID=$(id -ur)

# must  be root to run
if [ "$TUID" -eq 0 ]; then
  echo "running as root"

  ROOT_DIR=/local/eosnetworkfoundation
  SPRING_BUILD_DIR="${ROOT_DIR}"/spring_build
  CDT_BUILD_DIR="${ROOT_DIR}"/repos/cdt/build

  cd "${SPRING_BUILD_DIR:?}" || exit
  PRIME_LOC='./antelope-spring_[1-9].[0-9].[0-9]*-ubuntu22.04_amd64.deb'
  if [ -e $PRIME_LOC ]; then
    dpkg -i $PRIME_LOC
  else
    echo "Can not find spring software deb package"
    exit 1
  fi

  cd "${CDT_BUILD_DIR:?}" || exit
  make install

else
  echo "must be root user to install software"
  exit
fi
