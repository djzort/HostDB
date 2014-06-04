#!/bin/bash
set -x
set -e

apt-get install git-core apache2 libapache2-mod-fcgid libyaml-syck-perl libnet-ldap-perl liblog-log4perl-perl libcrypt-cbc-perl libcgi-fast-perl libfcgi-perl libio-socket-inet6-perl libsocket6-perl liblog-dispatch-perl libcrypt-blowfish-perl libnetaddr-ip-perl

rsync -a src/server/ /

# setup data dir
NDIR=`grep namespace_dir src/server/etc/hostdb/server_conf.yaml | awk '{print $2}'`;
mkdir -p $NDIR/hosts/.perms
mkdir -p $NDIR/tags/.perms
mkdir -p $NDIR/tags/.members

echo "--- yaml host conf" > $NDIR/hosts/server1.yourdomain.com
echo "--- yaml host conf" > $NDIR/hosts/server2.yourdomain.com
echo "--- yaml tag conf" > $NDIR/tags/tag1
echo "--- yaml tag conf" > $NDIR/tags/tag2
echo "--- yaml tag conf" > $NDIR/tags/tag3
echo "server1.yourdomain.com" > $NDIR/tags/.members/tag1
echo "server2.yourdomain.com" > $NDIR/tags/.members/tag2
echo -e '@tag1\n@tag2' > $NDIR/tags/.members/tag3
echo -e "---\nadmin:\n  data: RW" > $NDIR/hosts/.perms/.default
echo -e "---\nadmin:\n  data: RW\n  members: RW" > $NDIR/tags/.perms/.default
pushd $NDIR && git init . && git add * && git commit -am "init" && popd

src/server/DEBIAN/postinst

echo "Setup complete. login with user 'admin' and passwd 'secret'"


