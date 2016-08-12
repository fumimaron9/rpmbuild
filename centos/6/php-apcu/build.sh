#!/bin/bash

chown -R root. *

RPMS=`find RPMS -name "*.rpm" 2> /dev/null | sed -e "s/^.*\/\(.*\)\.rpm$/\1/g"`
for RPM in ${RPMS[@]}; do
  if [ `rpm -qa | grep ${RPM}` ];then
    rpm -ev ${RPM}
  fi
done

yum-builddep -y SPECS/php-apcu.spec
spectool -g -R SPECS/php-apcu.spec
rpmbuild -ba SPECS/php-apcu.spec

yum install -y --nogpgcheck RPMS/x86_64/*-[^d.+].*

useradd -u ${BUILD_UID} ${BUILD_USER}
chown -R ${BUILD_USER}. *
