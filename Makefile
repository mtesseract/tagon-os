
.PHONY: tag build-image build-mgmtd

VERSION=$(shell git describe --dirty)
.EXPORT_ALL_VARIABLES:

tag:
	@echo "$$VERSION"

build-image: artifacts/bin/mgmtd
	docker run --rm \
		--env-file "$$(pwd)/image/input/config.env" \
		-v "$$(pwd)/image/input:/input" \
		-v "$$(pwd)/artifacts:/output" \
		-v "$$(pwd)/artifacts:/artifacts" \
		bboehmke/raspi-alpine-builder

	sudo mv artifacts/sdcard.img.gz artifacts/tagon-os-${SHORT_VERSION}_full-img.gz
	sudo mv artifacts/sdcard.img.gz.sha256 artifacts/tagon-os-${SHORT_VERSION}_full-img.gz.sha256
	sudo mv artifacts/sdcard_update.img.gz artifacts/tagon-os-${SHORT_VERSION}_update-img.gz
	sudo mv artifacts/sdcard_update.img.gz.sha256 artifacts/tagon-os-${SHORT_VERSION}_update-img.gz.sha256

build-mgmtd: artifacts/bin/mgmtd

artifacts/bin/mgmtd:
	mkdir -p "$$(pwd)/mgmtd/target"
	docker run --rm \
	    -v "$$HOME/.cargo/git:/home/rust/.cargo/git" \
		-v "$$HOME/.cargo/registry:/home/rust/.cargo/registry" \
	    -v "$$(pwd)/mgmtd:/home/rust/src" \
		-v "$$(pwd)/artifacts:/artifacts" \
		ekidd/rust-musl-builder \
		sh -c '\
		  sudo chown -R rust:rust \
		    /artifacts \
			/home/rust/.cargo/git \
			/home/rust/.cargo/registry \
			target \
		  && cargo build --release \
		  && cargo install --path . --root=/artifacts\
		'
	rm -f artifacts/.crates.toml artifacts/.crates2.jsonm

test:
	echo $$VERSION
