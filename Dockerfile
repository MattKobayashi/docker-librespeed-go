FROM golang:1.14.2-alpine3.11 AS buildenv

# Copy files and build
WORKDIR /speedtest
COPY entrypoint.sh /speedtest/entrypoint.sh
RUN apk add --no-cache tar \
	&& wget -O - https://github.com/librespeed/speedtest/tarball/go \
	| tar -xz --strip 1 \
	&& CGO_ENABLED=0 go build -ldflags "-w -s" -trimpath -o speedtest main.go

# Copy compiled binary and supporting files to main image
FROM alpine:3.11
RUN adduser --system speedtest \
    && mkdir /assets/ \
    && chown -R speedtest /assets/ \
    && mkdir /data/ \
    && chown -R speedtest /data/ \
    && touch /settings.toml \
    && chown speedtest /settings.toml
COPY --from=buildenv --chown=speedtest:nogroup /speedtest/speedtest /
COPY --from=buildenv --chown=speedtest:nogroup /speedtest/assets/* /assets/
COPY --from=buildenv --chown=speedtest:nogroup /speedtest/entrypoint.sh /
RUN chmod +x /entrypoint.sh \
    && chmod +x /speedtest
USER speedtest

# Set variable defaults
ENV TITLE=
ENV BINDADDR=
ENV LISTENPORT=8989
ENV IPINFOKEY=
ENV STATSPASS=
ENV REDACTIP=false

# Set volume
VOLUME ["/data"]

# Set expose port and entrypoint
EXPOSE 8989
ENTRYPOINT ["/entrypoint.sh"]

LABEL maintainer="matthew@thompsons.id.au"
