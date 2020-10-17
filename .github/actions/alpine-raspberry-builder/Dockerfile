FROM bboehmke/raspi-alpine-builder:latest

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

RUN echo "HOME=$HOME"

CMD source $HOME/.cargo/env && cd $GITHUB_WORKSPACE && make build-image


