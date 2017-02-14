#!/bin/bash -e

export CURR_JOB="build_microbase"
export DOCKERHUB_ORG=drydock
export IMAGE_NAME=microbase

export RES_DH="ship_dh"
export RES_REPO="microbase_repo"
export RES_IMAGE="microbase_img"
export RES_DRY_TAG="push_dry_tag"

# get dockerhub EN string
export RES_DH_UP=$(echo $RES_DH | awk '{print toupper($0)}')
export RES_DH_INT_STR=$RES_DH_UP"_INTEGRATION"

# set the drydock tag path
export RES_DRY_TAG_UP=$(echo $RES_DRY_TAG | awk '{print toupper($0)}')
export RES_DRY_TAG_VER_NAME=$(eval echo "$"$RES_DRY_TAG_UP"_VERSIONNAME")
export IMAGE_TAG=$RES_DRY_TAG_VER_NAME

# set the repo path
export RES_REPO_UP=$(echo $RES_REPO | awk '{print toupper($0)}')
export RES_REPO_STATE=$(eval echo "$"$RES_REPO_UP"_STATE")

set_context() {
  export DH_USERNAME=$(eval echo "$"$RES_DH_INT_STR"_USERNAME")
  export DH_PASSWORD=$(eval echo "$"$RES_DH_INT_STR"_PASSWORD")
  export DH_EMAIL=$(eval echo "$"$RES_DH_INT_STR"_EMAIL")

  echo "CURR_JOB=$CURR_JOB"
  echo "DOCKERHUB_ORG=$DOCKERHUB_ORG"
  echo "IMAGE_NAME=$IMAGE_NAME"
  echo "RES_DH=$RES_DH"
  echo "RES_REPO=$RES_REPO"
  echo "RES_IMAGE=$RES_IMAGE"
  echo "RES_DRY_TAG=$RES_DRY_TAG"

  echo "RES_DH_UP=$RES_DH_UP"
  echo "RES_DH_INT_STR=$RES_DH_INT_STR"
  echo "RES_DRY_TAG_UP=$RES_DRY_TAG_UP"
  echo "RES_DRY_TAG_VER_NAME=$RES_DRY_TAG_VER_NAME"
  echo "IMAGE_TAG=$IMAGE_TAG"
  echo "RES_REPO_UP=$RES_REPO_UP"
  echo "RES_REPO_STATE=$RES_REPO_STATE"

  echo "DH_USERNAME=$DH_USERNAME"
  echo "DH_PASSWORD=${#DH_PASSWORD}" #show only count
  echo "DH_EMAIL=$DH_EMAIL"
}

dockerhub_login() {
  echo "Logging in to Dockerhub"
  echo "----------------------------------------------"
  sudo docker login -u $DH_USERNAME -p $DH_PASSWORD -e $DH_EMAIL
}

build_tag_push_image() {
  pushd $RES_REPO_STATE
  echo "Starting Docker build & push for" $IMAGE_NAME:$IMAGE_TAG
  sed -i "s/{{%TAG%}}/$RES_DRY_TAG_VER_NAME/g" Dockerfile
  sudo docker build -t=$IMAGE_NAME:$IMAGE_TAG .
  sudo docker push $IMAGE_NAME:$IMAGE_TAG
  echo "Completed Docker build & push for" $IMAGE_NAME:$IMAGE_TAG
  popd
}

create_image_version() {
  echo "Creating a state file for" $RES_IMAGE
  echo versionName=$IMAGE_TAG > /build/state/$RES_IMAGE.env
  cat /build/state/$RES_IMAGE.env
  echo "Completed creating a state file for" $RES_IMAGE
}

main() {
  set_context
  dockerhub_login
  build_tag_push_image
  create_image_version
}

main
