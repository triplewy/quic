FROM debian:buster

RUN apt-get update
RUN apt-get --yes --fix-missing update

COPY libs.tar .

RUN tar xvf libs.tar
RUN mv libs/* /lib/x86_64-linux-gnu/

COPY quic_server .
COPY run_server.sh .
RUN chmod +x run_server.sh

ENTRYPOINT [ "./run_server.sh" ]