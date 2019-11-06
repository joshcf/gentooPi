#!/bin/bash

# Manually deal with the psh.txt file
TMPDIR=$(mktemp -d)
OLDPWD=$(pwd)
cd "${TMPDIR}"
curl --output psh.txt https://hosts-file.net/psh.txt
iconv -f ISO-8859-1 -t UTF-8 psh.txt > pshTmp1.txt
tr -d '\15\32' < pshTmp1.txt > pshTmp2.txt
cat pshTmp2.txt | awk  -F'[\\\\|\\\\^| \t]+' -v RS='\r|\n' '{if (($0 ~ /^\|\|.*\^$/ || $1 ~ /^0.0.0.0|127.0.0.1/) && $2 ~ /.*\.[a-z].*/)  printf "%s\n",tolower($2) }' > /etc/unbound/psh.hosts

cat /etc/unbound/custom_block.hosts /etc/unbound/facebook.hosts /etc/unbound/google.hosts /etc/unbound/psh.hosts > /etc/unbound/josh_block.hosts

curl --output adList.txt https://v.firebog.net/hosts/lists.php?type=nocross

head -c -1 adList.txt > adListTmp.txt

tr '\n' ',' < adListTmp.txt > adListTmp2.txt

ADLISTS=$(cat adListTmp2.txt)

/usr/local/bin/dns_blocklist.sh -b /etc/unbound/josh_block.hosts -w /etc/unbound/josh_white.hosts -r always_nxdomain -o /etc/unbound/unbound.conf.d/blocklist.conf -s ${ADLISTS}

/etc/init.d/unbound restart

cd "${OLDPWD}"
rm -rf "${TMPDIR}"
