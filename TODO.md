# TODO

## Create Docker containers for server
- [x] Apache HTTPD (H2)
- [ ] Chromium - Google (H3)
  - Chromium QUIC server is crashing on handling packets 
   
  ```[0531/210324.834247:FATAL:quic_connection.cc(4421)] Check failed: time_of_last_decryptable_packet_ == time_of_last_received_packet_ || !last_packet_decrypted_.```

- [x] Proxygen - Facebook (H3)
- [ ] Quiche - Cloudfare (H3)

## Create sample HTML files

| Parameter         | Values tested        |
| ----------------- | -------------------- |
| Number of objects | 1, 10, 100           |
| Object sizes (KB) | 10, 100, 1000, 10000 |
12 total combinations
- [x] 10kb
- [x] 100kb
- [x] 1000kb (1mb)
- [x] 10000kb (10mb)

## Create scripts to test and measure page-load times

- [] Export HAR files