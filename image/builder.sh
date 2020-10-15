#!/bin/sh

df -h
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
