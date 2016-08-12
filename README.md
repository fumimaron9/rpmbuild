# rpmbuild

## requirements

docker >= 1.9

## usage

```
# for mac only
brew install coreutils gnu-getopt
brew link gnu-getopt --force
```

```
git clone https://github.com/fumimaron9/rpmbuild.git
cd rpmbuild
sh rpmbuild.sh centos/6/php-redis
ls -lt mount/RPMS/x86_64
```

