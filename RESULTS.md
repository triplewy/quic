# Results

## Preliminary Results

Legend:
| Key                                            | Explanation                                           |
| ---------------------------------------------- | ----------------------------------------------------- |
| <span style="color:green">**connect**</span>   | Time required to create TCP/QUIC connection           |
| <span style="color:cyan">**send**</span>       | Time required to send HTTP request to the server      |
| <span style="color:yellow">**wait**</span>     | Waiting for a response from the server                |
| <span style="color:magenta">**receive**</span> | Time required to read entire response from the server |


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