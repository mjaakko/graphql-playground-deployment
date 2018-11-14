#!/bin/bash
set -e

# This is run at ci, created an image that contains all the tools needed in
# databuild
#
# Set these environment variables
#DOCKER_USER // dockerhub credentials
#DOCKER_AUTH

ORG=${ORG:-mjaakko}
DOCKER_TAG=${TRAVIS_COMMIT:-latest}
DOCKER_IMAGE=$ORG/graphql-playground-deployment:${DOCKER_TAG}
LATEST_IMAGE=$ORG/graphql-playground-deployment:latest
PROD_IMAGE=$ORG/graphql-playground-deployment:prod


echo Building graphql-playground: $DOCKER_IMAGE

docker build  --tag=$DOCKER_IMAGE -f Dockerfile .

if [ "${TRAVIS_PULL_REQUEST}" == "false" ]; then
  if [ "$TRAVIS_TAG" ];then
    echo "processing release $TRAVIS_TAG"
    #release do not rebuild, just tag
    docker pull ${DOCKER_IMAGE}
    docker tag ${DOCKER_IMAGE} ${PROD_IMAGE}
    docker login -u ${DOCKER_USER} -p ${DOCKER_AUTH}
    docker push ${PROD_IMAGE}
  else
    echo "processing master build $TRAVIS_COMMIT"
    docker build  --tag=$DOCKER_IMAGE -f Dockerfile .
    docker login -u ${DOCKER_USER} -p ${DOCKER_AUTH}
    docker push ${DOCKER_IMAGE}
    docker tag ${DOCKER_IMAGE} ${LATEST_IMAGE}
    docker push ${LATEST_IMAGE}
  fi
else
  docker build  --tag=$DOCKER_IMAGE -f Dockerfile .
fi

echo Build completed
