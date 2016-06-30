DOCKER_IMAGE_NAME = devopshacks/alpine-base
DOCKER_IMAGE_TAG ?= latest
SHELL = /bin/bash -e

default:

docker-login:
	docker login -u ${DOCKER_USER} -p ${DOCKER_PASSWORD} -e ${DOCKER_EMAIL}

build:
	docker pull `awk '/^FROM /{print $$2}' Dockerfile`
	docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} .

upload: docker-login
	docker push ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}

run-bash:
	docker run -it --rm ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} bash

test:
	@for suite in spec/tests/*_spec.rb; do \
		echo $$suite; \
		DOCKER_IMAGE_NAME=${DOCKER_IMAGE_NAME} DOCKER_IMAGE_TAG=${DOCKER_IMAGE_TAG} bundle exec rspec $$suite; \
	done; \

test-deps:
	bundle install --path=vendor/bundle --binstubs=vendor/bin
