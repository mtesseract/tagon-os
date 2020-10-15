.PHONY: build

build:
	docker run \
		--env-file config.env \
		--rm \
		-v input:/input \
		-v output:/output \
		bboehmke/raspi-alpine-builder
