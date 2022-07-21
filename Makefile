DOCKER := docker
SED := sed
GIT := git

SPACE=$() $()
COMMA=,

TAG_LATEST=true
REPOSITORY := homebase

GIT_BRANCH := $(shell $(GIT) rev-parse --abbrev-ref HEAD | $(SED) 's/[^a-zA-Z0-9-]//g') # Sanitize
GIT_HASH := $(shell $(GIT) rev-parse HEAD)

override TAGS += branch-$(GIT_BRANCH) \
                 git-$(GIT_HASH)

# Tag image with 'latest' by default
ifeq ($(TAG_LATEST),true)
override TAGS += latest
endif

# Auto enable buildx when available
BUILDX_ENABLED := $(shell docker buildx version > /dev/null 2>&1 && printf true || printf false)
BUILDX_PLATFORMS := linux/amd64 linux/arm64 linux/arm/v7 linux/arm/v6
BUILDX_FLAGS :=

ifdef REPOSITORY_PREFIX
    override REPOSITORY := $(REPOSITORY_PREFIX)/$(REPOSITORY)
endif

ifdef TAGS
    TAG_PREFIX := --tag $(REPOSITORY):
    override DOCKER_BUILD_FLAGS += $(TAG_PREFIX)$(subst $(SPACE),$(SPACE)$(TAG_PREFIX),$(strip $(TAGS)))
endif

ifeq ($(BUILDX_ENABLED),true)
    override DOCKER := $(DOCKER) buildx
    override DOCKER_BUILD_FLAGS += --platform $(subst $(SPACE),$(COMMA),$(BUILDX_PLATFORMS))
endif

$(info Docker buildx enabled: $(BUILDX_ENABLED))

.PHONY: image image-push

image:
	$(DOCKER) build . $(DOCKER_BUILD_FLAGS)

image-push:
ifeq ($(BUILDX_ENABLED),true)
	$(MAKE) image DOCKER_BUILD_FLAGS+="--push"
else
	$(DOCKER) push $(REPOSITORY) --all-tags
endif
