#!/bin/bash -e

export IMAGE_NAME=shippable/microbase
export BRANCH=master
export SHIPPABLE_BUILD_NUMBER=latest
export DOCKER_CREDS_RES=docker-creds
export DOCKER_CREDS_RES_INT=shipDH.json
export MICRO_REPO_NAME=microbase-repo

dockerBuild() {
  echo "Starting Docker build"
  sudo docker build --rm -t=$IMAGE_NAME:$BRANCH.$SHIPPABLE_BUILD_NUMBER .
  echo "Completed Docker build"
}

dockerLogin() {
  echo "Extracting docker creds"
  node ./IN/$MICRO_REPO_NAME/$MICRO_REPO_NAME/extractCreds.js $(cat ./IN/$DOCKER_CREDS_RES/$DOCKER_CREDS_RES_INT)
  echo "docker creds successfully parsed"
}

main() {
  dockerLogin
  #dockerBuild
}

main
