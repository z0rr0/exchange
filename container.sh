#!/bin/bash

CONTAINER="golang:1.8-alpine"
SOURCES="$GOPATH/src"
TARGET="$GOPATH/bin/alpine"
ATTRS="`bash version.sh`"

rm -rf $TARGET exchange
mkdir -p $TARGET/bin $TARGET/pkg

/usr/bin/docker run --rm --user `id -u $USER`:`id -g $USER` \
	--volume ${SOURCES}:/usr/p/src:ro \
	--volume $TARGET/pkg:/usr/p/pkg \
	--volume ${TARGET}/bin:/usr/p/bin \
	--workdir /usr/p/src/github.com/z0rr0/exchange \
	--env GOPATH=/usr/p \
	${CONTAINER} go install -v -ldflags "${ATTRS}" github.com/z0rr0/exchange

if [[ $? -gt 0 ]]; then
	echo "ERROR: build container"
	exit 1
fi
cp -v $TARGET/bin/exchange ./
