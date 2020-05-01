#!/bin/sh
set -xe

# Select server mode
cp /assets/example-singleServer-full.html /assets/index.html

# Set title
if [ ! -z "$TITLE" ]; then
  sed -i "s/LibreSpeed Example/$TITLE/g" /assets/index.html
fi

# Set bind address and port
echo -e "bind_address=\"$BINDADDR\"\n" > settings.toml
echo -e "listen_port=\"$LISTENPORT\"\n" >> settings.toml

# Set server location manually if desired
if [ ! -z "$SERVERLAT" ]; then
  echo -e "server_lat=\"$SERVERLAT\"\n" >> settings.toml
fi

if [ ! -z "$SERVERLNG" ]; then
  echo -e "server_lng=\"$SERVERLNG\"\n" >> settings.toml
fi

# Set ipinfo.io API key (if applicable)
echo -e "ipinfo_api_key=\"$IPINFOKEY\"\n" >> settings.toml

# Set password for logging into statistics page
if [ -z "$STATSPASS" ]; then
  echo -e "statistics_password=\"PASSWORD\"\n" >> settings.toml
else
  echo -e "statistics_password=\"$STATSPASS\"\n" >> settings.toml
fi

# Redact IP addresses?
if [ "$REDACTIP" == "true" ]; then
  echo -e "redact_ip_addresses=true\n" >> settings.toml
else
  echo -e "redact_ip_addresses=false\n" >> settings.toml
fi

# Set BoltDB defaults
echo -e "database_type=\"bolt\"\n" >> settings.toml
echo -e "database_hostname=\"\"\n" >> settings.toml
echo -e "database_name=\"\"\n" >> settings.toml
echo -e "database_username=\"\"\n" >> settings.toml
echo -e "database_password=\"\"\n" >> settings.toml

# Set BoltDB location
echo -e "database_file=\"/data/speedtest.db\"\n" >> settings.toml

# Run speedtest
echo "settings.toml generated, starting LibreSpeed..."
/speedtest
