#!/bin/bash

OLDPWD=$(pwd)

if [ ! -d /usr/share/xt_geoip ]
then
	mkdir -p /usr/share/xt_geoip
fi

# Create Temp directory to work in

mkdir -p /tmp/geoipUpdate

# Move to the temp directory

cd /tmp/geoipUpdate

# Download the latest geoip database

/lib64/xtables-addons/xt_geoip_dl


# Build the geoip files to /usr/share/xt_geoip/

/lib64/xtables-addons/xt_geoip_build -S /tmp/geoipUpdate/GeoLite*/ -D /usr/share/xt_geoip/

# Clean up

cd "${OLDPWD}"
rm -rf /tmp/geoipUpdate

