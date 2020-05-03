# LibreSpeed-Go
The [Go implementation of LibreSpeed](https://github.com/librespeed/speedtest/tree/go) in a Docker image.

## Docker-Compose Example
```
version: 2.4
services:

  librespeed:
    image: "ingenieurmt/librespeed-go:latest"
    container_name: librespeed
    hostname: speedtest
    domainname: example.com
    restart: unless-stopped
    networks:
      - dockernet
    environment:
      - TITLE=Custom Speedtest Title Here
      - STATSPASS=statspassword
    volumes:
      - type: volume
        source: librespeed_data
        target: /opt/librespeed/data
    ports:
      - "8989:8989/tcp"
```
