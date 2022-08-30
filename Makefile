DOCKER_NAMESPACE=cocktavern
DOCKER_CONTAINER_NAME=kube-ci
DOCKER_REPOSITORY=$(DOCKER_NAMESPACE)/$(DOCKER_CONTAINER_NAME)
DOCKER_PLATFORM=linux/arm64

debug: local-docker-build
	sh debug.sh
	
local-docker-build:
	docker build --rm \
		--build-arg DOCKER_PLATFORM=$(DOCKER_PLATFORM) \
		--tag $(DOCKER_REPOSITORY):local .

ci-docker-auth:
	@echo "${DOCKER_PASSWORD}" | docker login --username "${DOCKER_USERNAME}" --password-stdin

ci-docker-build:
	@docker buildx build \
		--platform $(DOCKER_PLATFORM) \
		--build-arg DOCKER_PLATFORM=$(DOCKER_PLATFORM) \
		--tag $(DOCKER_REPOSITORY):$(GITHUB_SHA) \
		--tag $(DOCKER_REPOSITORY):latest \
		--output "type=image,push=false" .

ci-docker-build-push: ci-docker-build
	@docker buildx build \
		--platform $(DOCKER_PLATFORM) \
		--build-arg DOCKER_PLATFORM=$(DOCKER_PLATFORM) \
		--tag $(DOCKER_REPOSITORY):$(GITHUB_SHA) \
		--tag $(DOCKER_REPOSITORY):latest \
		--output "type=image,push=true" .
