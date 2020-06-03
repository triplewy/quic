# Results

## Preliminary Results [6/2/20 IETF QUIC Draft 27]

Legend:
| Key                                            | Explanation                                           |
| ---------------------------------------------- | ----------------------------------------------------- |
| <span style="color:green">**connect**</span>   | Time required to create TCP/QUIC connection           |
| <span style="color:cyan">**send**</span>       | Time required to send HTTP request to the server      |
| <span style="color:yellow">**wait**</span>     | Waiting for a response from the server                |
| <span style="color:magenta">**receive**</span> | Time required to read entire response from the server |

Client: Google Chrome Canary (Version 85.0.4162.0)

Servers:
- Http2: [Apache httpd:2.4](https://hub.docker.com/_/httpd)
- Chromium: 
- Proxygen: [CommitID: 1ec10a (5/29/20)](https://github.com/facebook/proxygen/commit/1ec10a60ab7634d6f804ccada7b3e123a93e23d6)
- Quiche: [CommitID: 51fb56 (5/31/20)](https://github.com/cloudflare/quiche/commit/51fb5609190db2d087c8c0c62c6f24ab054421cd)

### Size: 10kb, Num objects: 100
![http2](./graphs/10kb/100/http2/graph.png)
![chromium](./graphs/10kb/100/chromium/graph.png)
![proxygen](./graphs/10kb/100/proxygen/graph.png)
![quiche](./graphs/10kb/100/quiche/graph.png)

### Size: 100kb, Num objects: 100
![http2](./graphs/100kb/100/http2/graph.png)
![chromium](./graphs/100kb/100/chromium/graph.png)
![proxygen](./graphs/100kb/100/proxygen/graph.png)
![quiche](./graphs/100kb/100/quiche/graph.png)

### Size: 10kb, Num objects: 10
![http2](./graphs/10kb/10/http2/graph.png)
![chromium](./graphs/10kb/10/chromium/graph.png)
![proxygen](./graphs/10kb/10/proxygen/graph.png)
![quiche](./graphs/10kb/10/quiche/graph.png)

### Size: 100kb, Num objects: 10
![http2](./graphs/100kb/10/http2/graph.png)
![chromium](./graphs/100kb/10/chromium/graph.png)
![proxygen](./graphs/100kb/10/proxygen/graph.png)
![quiche](./graphs/100kb/10/quiche/graph.png)