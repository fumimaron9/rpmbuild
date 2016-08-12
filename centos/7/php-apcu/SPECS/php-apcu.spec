# from: https://github.com/remicollet/remirepo/blob/master/php/php-redis/php-redis.spec

Name:          php-apcu
Summary:       APCu - APC User Cache
Group:         Development/Languages
Version:       5.1.5
Release:       1%{?dist}
License:       The PHP license (see "LICENSE" file included in distribution)
URL:           https://github.com/krakjoe/apcu
Source0:       https://github.com/krakjoe/apcu/archive/v%{version}.tar.gz
Source1:       apcu.ini

Requires:      php

%description
APCu - APC User Cache

%prep

%setup -q -n apcu-%{version}

%build
%{_bindir}/phpize

%configure --with-php-config=%{_bindir}/php-config

make %{?_smp_mflags}

%install
rm -rf %{buildroot}
make install INSTALL_ROOT=%{buildroot}

# install configuration
%{__mkdir} -p $RPM_BUILD_ROOT%{_sysconfdir}/php.d
%{__cp} %{SOURCE1} $RPM_BUILD_ROOT%{_sysconfdir}/php.d/apcu.ini
rm -rf $RPM_BUILD_ROOT/usr/include/php/ext/apcu/*

%files
%defattr(-,root,root,-)
%config(noreplace) %{_sysconfdir}/php.d/apcu.ini
#%{php_extdir}/apcu.so
%{_libdir}/*
