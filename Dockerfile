FROM golang:1.17-alpine3.14 AS buildenv

# Copy/grab files and compile
WORKDIR /librespeed
COPY entrypoint.sh /librespeed/entrypoint.sh
RUN apk --no-cache upgrade \
    && apk add --no-cache tar \
    && wget -O - https://github.com/librespeed/speedtest-go/archive/v1.1.4.tar.gz \
    | tar -xz --strip 1 \
    && CGO_ENABLED=0 go build -ldflags "-w -s" -trimpath -o speedtest main.go

# Copy compiled binary and supporting files to main image
FROM alpine:3.14
WORKDIR /opt/librespeed
RUN adduser --system librespeed \
    && apk --no-cache upgrade \
    && mkdir assets/ \
    && mkdir data/ \
    && touch settings.toml
COPY --from=buildenv --chown=librespeed:nogroup /librespeed/speedtest /opt/librespeed/
COPY --from=buildenv --chown=librespeed:nogroup /librespeed/entrypoint.sh /opt/librespeed/
RUN chmod +x entrypoint.sh \
    && chmod +x speedtest \
    && chown -R librespeed /opt/librespeed/
USER librespeed

# Set variable defaults
ENV TITLE=
ENV BINDADDR=
ENV LISTENPORT=8989
ENV PROXYPROTOPORT=
ENV SERVERLAT=
ENV SERVERLNG=
ENV IPINFOKEY=
ENV STATSPASS=
ENV REDACTIP=false

# Set volume
VOLUME ["/opt/librespeed/data"]

# Set expose port and entrypoint
EXPOSE 8989
ENTRYPOINT ["./entrypoint.sh"]

LABEL maintainer="matthew@kobayashi.com.au"
