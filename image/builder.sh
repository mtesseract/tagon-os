#!/bin/sh

echo "VERSION in Docker: $VERSION"
echo "SHORT_VERSION in Docker: $SHORT_VERSION"

ln -sf $GITHUB_WORKSPACE/image/input /input
mkdir $GITHUB_WORKSPACE/image/work
rmdir /work
ln -sf $GITHUB_WORKSPACE/image/work /work
mkdir $GITHUB_WORKSPACE/image/tmp
rmdir /tmp
ln -sf $GITHUB_WORKSPACE/image/tmp /tmp
ln -sf $GITHUB_WORKSPACE/image/output /output
. /input/config.env

/resources/build.sh

mv /output/sdcard.img.gz /output/tagon-os-${SHORT_VERSION}_full-img.gz
mv /output/sdcard.img.gz.sha256 /output/tagon-os-${SHORT_VERSION}_full-img.gz.sha256

mv /output/sdcard_update.img.gz /output/tagon-os-${SHORT_VERSION}_update-img.gz
mv /output/sdcard_update.img.gz.sha256 /output/tagon-os-${SHORT_VERSION}_update-img.gz.sha256

# touch /output/tagon-os-${SHORT_VERSION}_full-img.gz
# touch /output/tagon-os-${SHORT_VERSION}_full-img.gz.sha256
# touch /output/tagon-os-${SHORT_VERSION}_update-img.gz
# touch /output/tagon-os-${SHORT_VERSION}_update-img.gz.sha256
