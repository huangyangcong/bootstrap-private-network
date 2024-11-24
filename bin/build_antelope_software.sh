#!/usr/bin/env bash

####
# Builds spring/nodeos and cdt software
# does not install software
# called from Docker Build
###

SPRING_GIT_COMMIT_TAG=${1:-v1.0.1}
CDT_GIT_COMMIT_TAG=${2:-v4.1.0}
NPROC=${3:-$(nproc)}
TUID=$(id -ur)

# must not be root to run
if [ "$TUID" -eq 0 ]; then
	echo "Can not run as root user exiting"
	exit
fi

ROOT_DIR=/local/eosnetworkfoundation
SPRING_GIT_DIR="${ROOT_DIR}"/repos/spring
SPRING_BUILD_DIR="${ROOT_DIR}"/spring_build
LOG_DIR=/bigata1/log
cd "${SPRING_GIT_DIR:?}" || exit

# NOTE the branch specified here doesn't change anything
# Docker Build sets branch with --single-branch option prevent other branches from being pulled in
git checkout $SPRING_GIT_COMMIT_TAG
git pull origin $SPRING_GIT_COMMIT_TAG
git submodule update --init --recursive

[ ! -d "$SPRING_BUILD_DIR"/packages ] && mkdir -p "$SPRING_BUILD_DIR"/packages
cd "${SPRING_BUILD_DIR:?}" || exit

echo "BUILDING SPRING FROM ${SPRING_GIT_COMMIT_TAG}"
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/usr/lib/llvm-11 "$SPRING_GIT_DIR" >>"$LOG_DIR"/spring_build_log.log 2>&1
make -j ${NPROC} package >>"$LOG_DIR"/spring_build_log.log 2>&1
echo "FINISHED BUILDING SPRING"

echo "BUILDING CDT FROM ${CDT_GIT_COMMIT_TAG}"
cd "${ROOT_DIR:?}"/repos/cdt || exit

# NOTE the branch specified here doesn't change anything
# Docker Build sets branch with --single-branch option prevent other branches from being pulled in
git checkout $CDT_GIT_COMMIT_TAG
git pull origin $CDT_GIT_COMMIT_TAG
git submodule update --init --recursive

mkdir build
cd build || exit
export spring_DIR="$SPRING_BUILD_DIR"/lib/cmake/spring
cmake .. >>"$LOG_DIR"/cdt_build_log.log 2>&1
make -j ${NPROC} >>"$LOG_DIR"/cdt_build_log.log 2>&1
cd packages || exit
chmod -R +x .
./generate_package.sh deb ubuntu-22.04 amd64
echo "FINSIHED BUILDING CDT"
