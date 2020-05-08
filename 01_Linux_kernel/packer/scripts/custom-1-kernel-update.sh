#!/bin/bash

VERSION=$(uname -r)
# Update and install packages
yum update -y
yum makecache
yum install -y ncurses-devel make gcc bc openssl-devel elfutils-libelf-devel rpm-build wget flex-devel flex bison-devel bison
# Download latest stable kernel
cd /opt/ && wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.6.11.tar.xz
tar xvf linux-5.6.11.tar.xz
cd linux-5.6.11/
cp -v /boot/config-${VERSION} .config
# Install custom kernel
make olddefconfig
make rpm-pkg
rpm -iUv /root/rpmbuild/RPMS/x86_64/*.rpm
# Reboot VM
shutdown -r now
