ARG REGISTRY=docker.io/
ARG REDBEAN_TAG=git-ed61f470dbe9cbfd59e4d1fb0b24efb0dc136f46

FROM ${REGISTRY}egladman/redbean:${REDBEAN_TAG}

ADD www /www
