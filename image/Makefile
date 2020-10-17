.PHONY: build

build:
	cp ../artifacts/bin/mgmtd input
	source input/config.env && docker run \
		--rm \
		-v input:/input \
		-v output:/output \
		bboehmke/raspi-alpine-builder
