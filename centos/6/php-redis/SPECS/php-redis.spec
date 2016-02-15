# from: https://github.com/remicollet/remirepo/blob/master/php/php-redis/php-redis.spec

#%global php_apiver  %((echo 0; php -i 2>/dev/null | sed -n 's/^PHP API => //p') | tail -1)
%global php_apiver  20100412-x86-64
%global php_extdir  %(php-config --extension-dir 2>/dev/null || echo "undefined")

Name:          php-redis
Version:       2.2.7
Release:       dev%{?dist}
Summary:       A PHP extension for Redis
Group:         Development/Languages
License:       PHP
URL:           https://github.com/phpredis/phpredis
Source0:       https://github.com/phpredis/phpredis/archive/5241a5c34ba29e0b1db665cea468aa25c4fbc9c7.tar.gz
Source1:       redis.ini

# 教えてのphpに近くremiにあるversionを指定(5.4.34-1.el6.remi)
BuildRequires: php-devel = 5.4.45
Requires:      php(api) = %{php_apiver}

%description
A PHP extension for Redis

%prep
%setup -q -n phpredis-5241a5c34ba29e0b1db665cea468aa25c4fbc9c7

%build
%{_bindir}/phpize
%configure
make %{?_smp_mflags}

%install
rm -rf %{buildroot}
make install INSTALL_ROOT=%{buildroot}

# install configuration
%{__mkdir} -p $RPM_BUILD_ROOT%{_sysconfdir}/php.d
%{__cp} %{SOURCE1} $RPM_BUILD_ROOT%{_sysconfdir}/php.d/redis.ini

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root,-)
%config(noreplace) %{_sysconfdir}/php.d/redis.ini
%{php_extdir}/redis.so
