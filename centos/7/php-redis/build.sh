#!/bin/bash

chown -R root. *

RPMS=`find RPMS -name "*.rpm" 2> /dev/null | sed -e "s/^.*\/\(.*\)\.rpm$/\1/g"`
for RPM in ${RPMS[@]}; do
  if [ `rpm -qa | grep ${RPM}` ];then
    rpm -ev ${RPM}
  fi
done

rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
sed -i -e "s/enabled=0/enabled=1/g" /etc/yum.repos.d/remi.repo

yum-builddep -y SPECS/php-redis.spec
spectool -g -R SPECS/php-redis.spec
rpmbuild -ba SPECS/php-redis.spec

yum install -y --nogpgcheck RPMS/x86_64/*-[^d.+].*

useradd -u ${BUILD_UID} ${BUILD_USER}
chown -R ${BUILD_USER}. *
