# from: https://github.com/php/php-src/blob/master/php7.spec.in

Name:          php
Summary:       PHP: Hypertext Preprocessor
Group:         Development/Languages
Version:       5.5.38
Release:       1%{?dist}
License:       The PHP license (see "LICENSE" file included in distribution)
URL:           https://github.com/php/php-src
Source0:       https://github.com/php/php-src/archive/%{name}-%{version}.tar.gz
Source1:       php.ini
Source2:       opcache.ini
Prefix:        /usr


BuildRequires: libcurl-devel db4-devel libxml2-devel bzip2-devel libpng-devel libjpeg-devel openssl-devel readline-devel mysql-community-devel
Requires:      libpng mysql-community-client


%description
PHP is an HTML-embedded scripting language. Much of its syntax is
borrowed from C, Java and Perl with a couple of unique PHP-specific
features thrown in. The goal of the language is to allow web
developers to write dynamically generated pages quickly.


%prep


%setup -q -n php-src-php-%{version}


%build
set -x
./buildconf --force

CFLAGS="$RPM_OPT_FLAGS -fno-strict-aliasing -Wno-pointer-sign"
export CFLAGS


%configure --with-libdir=lib64 --with-config-file-path=%{_sysconfdir} --with-config-file-scan-dir=%{_sysconfdir}/php.d \
  --disable-debug --without-pear --without-sqlite3 --without-pdo-sqlite \
  --enable-bcmath --with-bz2 --enable-calendar --with-curl \
  --enable-dba --with-cdb --with-db4 --with-inifile --with-flatfile \
  --enable-exif --enable-ftp --with-gd --with-gettext \
  --enable-mbstring --with-mhash --with-openssl --enable-pcntl --with-readline --enable-shmop --enable-soap \
  --enable-sockets --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-wddx \
  --enable-opcache --enable-zip --with-zlib \
  --enable-fpm --with-fpm-user=nobody --with-fpm-group=nobody \
  --with-mysqli=/usr/bin/mysql_config --with-pdo-mysql=/usr/bin/mysql_config

make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install INSTALL_ROOT=$RPM_BUILD_ROOT

install -m 755 -d $RPM_BUILD_ROOT%{_sysconfdir}
install -m 644 %{SOURCE1} $RPM_BUILD_ROOT%{_sysconfdir}/php.ini
install -m 755 -d $RPM_BUILD_ROOT%{_sysconfdir}/php.d
install -m 644 %{SOURCE2} $RPM_BUILD_ROOT%{_sysconfdir}/php.d/opcache.ini

rm -f $RPM_BUILD_ROOT%{_sysconfdir}/php-fpm.conf.default


%files
%defattr(-,root,root,-)
%config(noreplace) %{_sysconfdir}/php.ini
%dir %{_sysconfdir}/php.d
%{_sysconfdir}/php.d/opcache.ini
#/usr
%{_prefix}
