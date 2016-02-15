FROM centos:6

RUN yum -y localinstall http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum -y localinstall http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm

RUN yum update -y
RUN yum install -y kernel-devel libtool gcc-c++ cmake bison flex gettext rpmdevtools redhat-rpm-config mock yum-utils
RUN yum clean all

RUN groupadd -g 700 mockbuild
RUN useradd -u 700 -g mockbuild -s /bin/false -d /dev/null -M mockbuild

RUN rpmdev-setuptree
RUN echo '%_topdir %(echo $HOME)/rpmbuild' >> ~/.rpmmacros

RUN echo 'chown -R root. ~/rpmbuild' >> ~/.bash_profile
RUN echo 'useradd -u ${BUILD_UID} ${BUILD_USER}' >> ~/.bash_profile

RUN echo 'alias exit="chown -R ${BUILD_USER}. ~/rpmbuild && exit"' >> ~/.bashrc

ENV USER root
ENV HOME /root
ENV SHELL /bin/bash
USER root
WORKDIR /root/rpmbuild

CMD ["/bin/bash", "-l"]
