image:
	cd image
	docker run \
		--env-file config.env \
		--rm -it \
		-v input:/input \
		-v output:/output \
		bboehmke/raspi-alpine-builder
