# TODO

## Create Docker containers for server
- [x] Apache HTTPD (H2)
- [x] Chromium - Google (H3)
  - Required multiple changes in chromium codebase. Future work: Create smaller repo that only includes Quic dependencies 
- [x] Proxygen - Facebook (H3)
- [x] Quiche - Cloudflare (H3)

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

- [x] Export HAR files
- [x] JS files to automate loading pages

## Analyze HAR files
- [ ] Write scripts to analyze HAR files and extract network load times
- [ ] Create graphs based off of HAR data

## Tune Quic implementations
- [ ] Analyze qlog files and compare with TCP packet capture
- [ ] Proxygen - Facebook
- [ ] Quiche - Cloudflare
- [ ] Chromium - Google
