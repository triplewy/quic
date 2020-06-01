FROM debian:buster

RUN apt-get update
RUN apt-get --yes --fix-missing update

# Get and build quiche with HTTP/3 support
COPY quiche-server .

COPY run_server.sh .
RUN chmod +x run_server.sh

ENTRYPOINT [ "./run_server.sh" ]