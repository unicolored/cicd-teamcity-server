#! /bin/bash

set -e

docker-compose down

#ECR_REPO="951583383645.dkr.ecr.eu-west-1.amazonaws.com"
#
#aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin $ECR_REPO

docker-compose up --remove-orphans -d

#docker exec -it agent sh -c "yarn set version stable"
#docker exec -it agent sh -c "yarn set version latest"

docker logs proxy
