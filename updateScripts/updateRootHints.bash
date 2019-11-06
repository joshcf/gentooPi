#!/bin/bash

# Download latest root hints file
curl --output /etc/unbound/var/root.hints https://www.internic.net/domain/named.cache
