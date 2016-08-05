#!/bin/bash -e

export BRANCH=master
export SHIPPABLE_BUILD_NUMBER=latest
export IMAGE_NAME=shippable/microbase
export IMAGE_TAG=$BRANCH.$SHIPPABLE_BUILD_NUMBER
export DOCKER_CREDS_RES=docker-creds
export DOCKER_CREDS_RES_INT=shipDH.json
export MICRO_REPO_NAME=microbase-repo

dockerBuild() {
  echo "Starting Docker build for" $IMAGE_NAME:$IMAGE_TAG
  cd ./IN/$MICRO_REPO_NAME/$MICRO_REPO_NAME
  sudo docker build -t=$IMAGE_NAME:$IMAGE_TAG .
  echo "Completed Docker build for" $IMAGE_NAME:$IMAGE_TAG
}

dockerPush() {
  echo "Starting Docker push for" $IMAGE_NAME:$IMAGE_TAG
  sudo docker push $IMAGE_NAME:$IMAGE_TAG
  echo "Completed Docker push for" $IMAGE_NAME:$IMAGE_TAG
}

dockerLogin() {
  echo "Extracting docker creds"

  cat ./IN/$DOCKER_CREDS_RES/$DOCKER_CREDS_RES_INT  | jq -r '.formJSONValues | map(.label + "=" + .value)|.[]' > dockerInt.sh

  . dockerInt.sh
  echo "logging into Docker with username" $username
  docker login -u $username -p $password
  echo "docker login successful"
}

main() {
  dockerLogin
  dockerBuild
  dockerPush
}

main
