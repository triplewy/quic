FROM ubuntu:bionic

RUN apt-get update
RUN apt-get --yes --fix-missing update

# Get and build proxygen with HTTP/3 support
RUN apt-get install --yes wget net-tools iputils-ping tcpdump ethtool iperf
RUN apt-get install --yes git sudo cmake
RUN git clone https://github.com/facebook/proxygen.git
RUN cd proxygen/proxygen && ./build.sh -q -t

# Cop
RUN ldd /proxygen/proxygen/_build/proxygen/httpserver/hq | grep "=> /" | awk '{print $3}' > libs.txt
RUN tar cvf libs.tar --dereference --files-from=libs.txt

COPY run_server.sh .
RUN chmod +x run_server.sh

# Copy HQ
COPY --from=0 /proxygen/proxygen/_build/proxygen/httpserver/hq /proxygen/proxygen/_build/proxygen/httpserver/hq
# Copy shared libs
COPY --from=0 libs.tar /
RUN tar xvf libs.tar
RUN rm libs.tar
# Create the logs directory
RUN mkdir /logs

ENTRYPOINT [ "./run_server.sh" ]