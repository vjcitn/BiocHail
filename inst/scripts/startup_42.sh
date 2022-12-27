#!/usr/bin/env bash

# 12/27/2022 will produce R 4.2.2 in docker ubuntu:22.04 in 2 minutes

# added
apt update
apt install --yes ca-certificates
DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata

apt install --yes --no-install-recommends wget  	# to add the key
wget -q -O- https://eddelbuettel.github.io/r2u/assets/dirk_eddelbuettel_key.asc \
    | tee -a /etc/apt/trusted.gpg.d/cranapt_key.asc

# USE JAMMY

#echo "deb [arch=amd64] https://dirk.eddelbuettel.com/cranapt jammy main" \
#    > /etc/apt/sources.list.d/cranapt.list
#apt update
# or use the mirror at the University of Illinois Urbana-Champaign:

echo "deb [arch=amd64] https://r2u.stat.illinois.edu/ubuntu jammy main" \
    > /etc/apt/sources.list.d/cranapt.list
apt update

# (In either example, replace focal with jammy for use with Ubuntu 22.04.)

#Third, and optionally, if you do not yet have the current R version, run these two lines (or use the standard CRAN repo setup)
#

wget -q -O- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc \
    | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
echo "deb [arch=amd64] https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" \
    > /etc/apt/sources.list.d/cran-ubuntu.list
apt update
apt install -y r-base-core
