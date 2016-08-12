#!/bin/bash

chown -R root. *

RPMS=`find RPMS -name "*.rpm" 2> /dev/null | sed -e "s/^.*\/\(.*\)\.rpm$/\1/g"`
for RPM in ${RPMS[@]}; do
  if [ `rpm -qa | grep ${RPM}` ];then
    rpm -ev ${RPM}
  fi
done

yum-builddep -y SPECS/php.spec
spectool -g -R SPECS/php.spec
rpmbuild -ba SPECS/php.spec

yum install -y --nogpgcheck RPMS/x86_64/*-[^d.+].*

useradd -u ${BUILD_UID} ${BUILD_USER}
chown -R ${BUILD_USER}. *
