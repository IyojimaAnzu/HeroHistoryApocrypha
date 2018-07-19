#!/bin/bash
# refresh repo
project="latex2epub"
sudo rm -Rf "docker/$project"
git clone -b dev . "docker/$project"
# build docker images
docker build -t $project-compile -f docker/compile.docker docker
docker build -t $project-quiz -f docker/quiz.docker docker
echo " COMPILING  --------------------------"
sudo docker run \
  --mount "type=bind,source=$PWD/docker/$project,target=/srv/$project" \
  -ti $project-compile || exit 1
echo " TESTING  --------------------------"
sudo docker run \
  --mount "type=bind,source=$PWD/docker/$project,target=/srv/$project" \
  -ti $project-quiz || exit 1
