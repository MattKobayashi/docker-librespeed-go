# docker-librespeed-go
The [Go implementation of LibreSpeed](https://github.com/librespeed/speedtest-go) in a Docker image.

## Docker-Compose Example
```
version: 2.4
services:

  librespeed:
    image: "ingenieurmt/docker-librespeed-go:latest"
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

## Configurable Environment Variables
```
TITLE      - The title displayed on the LibreSpeed web page and title bar (default is "LibreSpeed Example").
BINDADDR   - The IP address that LibreSpeed will bind to (optional, recommended to leave blank for Docker).
LISTENPORT - The port that LibreSpeed will bind to (default is 8989).
SERVERLAT  - The latitude of the server expressed as a signed float (e.g. -27.4698).
SERVERLNG  - The longitude of the server expressed as a signed float (e.g. 153.0251).
IPINFOKEY  - Your API key for ipinfo.io (optional, recommended if expecting a large number of tests).
STATSPASS  - The password you wish to set for access to /stats/ (result records). If left blank, /stats/ will be disabled.
REDACTIP   - When set to true with telemetry enabled, IP addresses and hostnames are redacted from the collected telemetry, for better privacy (default is false).
