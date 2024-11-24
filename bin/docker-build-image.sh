#!/usr/bin/env bash

TARGET="build-install-stage"

docker_overlay_fs_with_spaces=$(docker info | grep 'Docker Root Dir' | cut -d: -f2)
docker_overlay_fs=$(echo "$docker_overlay_fs_with_spaces" | xargs)
total_size=$(df -h ${docker_overlay_fs} | awk 'NR==2 {print $2}' | sed 's/Gi*//')
used_size=$(df -h ${docker_overlay_fs} | awk 'NR==2 {print $3}' | sed 's/Gi*//')
max_space_used=$((${total_size}-13-${total_size}*11/100))
if [ $used_size -gt $max_space_used ]; then
  echo "WARNING: may not have enough space in ${docker_overlay_fs}\!"
  echo "WARNING: building smallest possible image"
  sleep 1
  TARGET="clean-out-stage"
fi

# Sept 13th 2024 Build Spring v1.0.1
docker build -f AntelopeDocker --tag savanna-antelope:1.0.1 --ulimit nofile=1024:1024 --target ${TARGET} .
