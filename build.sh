#!/bin/bash -e

export IMAGE_NAME=shippable/microbase
export BRANCH=master
export SHIPPABLE_BUILD_NUMBER=latest
export DOCKER_CREDS_RES=docker-creds
export DOCKER_CREDS_RES_INT=shipDH.json

dockerBuild() {
  echo "Starting Docker build"
  sudo docker build --rm -t=$IMAGE_NAME:$BRANCH.$SHIPPABLE_BUILD_NUMBER .
  echo "Completed Docker build"
}

dockerLogin() {
  echo "Extracting docker creds"
  #node /build/IN/$REPO_RESOURCE_NAME/$REPO_RESOURCE_NAME/extractCreds.js $(cat /build/IN/$CLUSTER_RESOURCE_NAME/$CLUSTER_INTEGRATION_NAME) > $CREDS_LOCATION
  cat ./IN/$DOCKER_CREDS_RES/$DOCKER_CREDS_RES_INT
  echo "docker creds successfully parsed"
}

main() {
  dockerLogin
  #dockerBuild
}

main
