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

  cat ./IN/$DOCKER_CREDS_RES/$DOCKER_CREDS_RES_INT  | jq -r '.formJSONValues | map(.label + "=" + .value)|.[]' > dockerInt.sh

  . dockerInt.sh
  echo "logging into Docker with username " $username
  docker login -u $username -p $password
  echo "docker login successful"
}

main() {
  dockerLogin
  #dockerBuild
}

main
