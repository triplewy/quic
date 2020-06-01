FROM debian:buster

RUN apt-get update
RUN apt-get --yes --fix-missing update

# Get and build proxygen with HTTP/3 support
RUN apt-get install --yes wget net-tools iputils-ping tcpdump ethtool iperf

# Copy HQ
COPY hq .
# Copy shared libs
COPY libs.tar .
RUN tar xvf libs.tar
RUN rm libs.tar

# Create the logs directory
RUN mkdir /logs
RUN mkdir /qlog

COPY run_server.sh .
RUN chmod +x run_server.sh

ENTRYPOINT [ "./run_server.sh" ]