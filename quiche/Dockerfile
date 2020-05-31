FROM rust:stretch

RUN apt-get update
RUN apt-get --yes --fix-missing update

# Get and build proxygen with HTTP/3 support
RUN apt-get install --yes wget net-tools iputils-ping tcpdump ethtool iperf
RUN apt-get install --yes git sudo cmake perl

# Install Go
RUN wget https://dl.google.com/go/go1.14.3.linux-amd64.tar.gz
RUN [ "1c39eac4ae95781b066c144c58e45d6859652247f7515f0d2cba7be7d57d2226  go1.14.3.linux-amd64.tar.gz" = "$(sha256sum go1.14.3.linux-amd64.tar.gz)" ]
RUN sudo tar -C /usr/local -xzf go1.14.3.linux-amd64.tar.gz
RUN export PATH=$PATH:/usr/local/go/bin
RUN go version

RUN cd quiche && cargo build --manifest-path=tools/apps/Cargo.toml --bin quiche-server --release --target-dir /target
RUN mv /quiche/tools/apps/src/bin/cert.crt /cert.crt
RUN mv /quiche/tools/apps/src/bin/cert.key /cert.key
COPY run_server.sh .
RUN chmod +x run_server.sh

ENTRYPOINT [ "./run_server.sh" ]