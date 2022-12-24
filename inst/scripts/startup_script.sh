#!/usr/bin/env bash

# This script allows us to have R 4.2.2 in a Hail/Spark cluster on terra
# At this time, BiocHail's basilisk-based hail_init(2) won't interface to gs:// storage,
# but pure reticulate interface to hail does

# This script builds R from source as it has been difficult to find debian packaging
# yielding R 4.2

conda update -n base -c defaults conda
apt -y upgrade
apt-get update
apt-get install -y r-base-dev
apt-get install -y subversion
apt-get install -y rsync
apt-get install -y libcurl4-gnutls-dev
apt-get install -y vim
apt-get install openjdk-8-jdk
svn co https://svn.r-project.org/R/branches/R-4-2-branch R-4-2-src
cd R-4-2-src
cd tools
./rsync-recommended
cd ..  
./configure --enable-R-shlib --with-x=no
make -j 2
make install
/usr/local/bin/R CMD javareconf
/usr/local/bin/R -e "options(repos=c(CRAN = 'https://cloud.r-project.org'));install.packages(c('remotes', 'BiocManager'))"
export PIP_USER=false
/usr/local/bin/R -e "BiocManager::install('vjcitn/BiocHail')"
#wget https://www.openssl.org/source/openssl-3.0.7.tar.gz
#tar zxf openssl-3.0.7.tar.gz
#cd openssl-3.0.7
#./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl shared zlib
#make
#make install
#echo /usr/local/ssl/lib >> /etc/ld.so.conf.d/openssl-3.0.7.ld.conf
#ldconfig
#/usr/local/bin/R -e "library(BiocHail); example(get_1kg)"
