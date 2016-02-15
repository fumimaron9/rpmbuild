#!/bin/bash

chown -R root. *

RPMS=`find RPMS -name "*.rpm" 2> /dev/null | sed -e "s/^.*\/\(.*\)\.rpm$/\1/g"`
for RPM in ${RPMS[@]}; do
  if [ `rpm -qa | grep ${RPM}` ];then
    rpm -ev ${RPM}
  fi
done

mkdir -p SOURCES

curl -kL https://nodejs.org/dist/v4.2.2/node-v4.2.2.tar.gz -o SOURCES/node-v4.2.2.tar.gz

#curl -kL https://copr-fe.cloud.fedoraproject.org/coprs/rhscl/devtoolset-3/repo/epel-6/rhscl-devtoolset-3-epel-6.repo -o /etc/yum.repos.d/rhscl-devtoolset-3-epel-6.repo
yum install -y centos-release-scl-rh centos-release-SCL
yum install -y devtoolset-3-gcc devtoolset-3-gcc-c++ devtoolset-3-binutils python27

yum-builddep -y SPECS/nodejs.spec
#source /opt/rh/devtoolset-3/enable
scl enable devtoolset-3 python27 'rpmbuild -ba SPECS/nodejs.spec'

useradd -u ${BUILD_UID} ${BUILD_USER}
chown -R ${BUILD_USER}. *
