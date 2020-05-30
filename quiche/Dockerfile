FROM rust:stretch

RUN apt-get update
RUN apt-get --yes --fix-missing update

# Get and build proxygen with HTTP/3 support
RUN apt-get install --yes wget net-tools iputils-ping tcpdump ethtool iperf
RUN apt-get install --yes git sudo cmake

RUN git clone --recursive https://github.com/cloudflare/quiche

RUN cd quiche && cargo build --manifest-path=tools/apps/Cargo.toml --bin quiche-server --release --target-dir /target
RUN mv /quiche/tools/apps/src/bin/cert.crt /cert.crt
RUN mv /quiche/tools/apps/src/bin/cert.key /cert.key
COPY run_server.sh .
RUN chmod +x run_server.sh

ENTRYPOINT [ "./run_server.sh" ]