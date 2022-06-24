#!/bin/bash

set -e

BUILD_BASE="/root/weston-build"
BUILD="${BUILD_BASE}/usr"
YELLOW='\e[1;33m'
GREEN='\e[1;32m'
NC='\e[0m'
PROJECT_DIR=$(pwd)
WITH_DEV=0

if [ [ -n "$1" ] && [ $1 == "-d" ] ]
then
    WITH_DEV=1
fi

DEBS_PATH="/root/debs"
DEB_MAIN="weston_5.0.0-3-var-dpu-g2d-rdp_arm64"
DEB_LIB5="libweston-5-0_5.0.0-3-var-dpu-g2d-rdp_arm64"
DEB_LIBD="libweston-5-dev_5.0.0-3-var-dpu-g2d-rdp_arm64"

echo -e " ${YELLOW}"
echo " *********************"
echo " **    MAKE DEBs    **"
echo " *********************"
echo -e " ${NC}"

echo -e "Make ${GREEN}${DEB_MAIN}.deb${NC} package"
echo " "
DEB="${DEBS_PATH}/${DEB_MAIN}"
rm -rf ${DEB}/usr/*


mkdir -p ${DEB}/usr/bin
cp ${BUILD}/bin/wcap-decode ${DEB}/usr/bin/
cp ${BUILD}/bin/weston ${DEB}/usr/bin/
cp ${BUILD}/bin/weston-info ${DEB}/usr/bin/
cp ${BUILD}/bin/weston-launch ${DEB}/usr/bin/
cp ${BUILD}/bin/weston-terminal ${DEB}/usr/bin/

mkdir -p ${DEB}/usr/include
cp -r ${BUILD}/include/weston ${DEB}/usr/include/

mkdir -p ${DEB}/usr/lib/aarch64-linux-gnu/weston
cp ${BUILD}/lib/aarch64-linux-gnu/weston/*.so ${DEB}/usr/lib/aarch64-linux-gnu/weston/

mkdir -p ${DEB}/usr/lib/aarch64-linux-gnu/pkgconfig
cp ${BUILD}/lib/aarch64-linux-gnu/pkgconfig/weston.pc ${DEB}/usr/lib/aarch64-linux-gnu/pkgconfig/

mkdir -p ${DEB}/usr/lib
cp -r ${BUILD}/lib/weston ${DEB}/usr/lib/
cp ${BUILD}/bin/weston-c* ${DEB}/usr/lib/weston/ || :
cp ${BUILD}/bin/weston-dnd ${DEB}/usr/lib/weston/ || :
cp ${BUILD}/bin/weston-e* ${DEB}/usr/lib/weston/ || :
cp ${BUILD}/bin/weston-f* ${DEB}/usr/lib/weston/ || :
cp ${BUILD}/bin/weston-image ${DEB}/usr/lib/weston/ || :
cp ${BUILD}/bin/weston-multi-resource ${DEB}/usr/lib/weston/ || :
cp ${BUILD}/bin/weston-presentation-shm ${DEB}/usr/lib/weston/ || :
cp ${BUILD}/bin/weston-resizor ${DEB}/usr/lib/weston/ || :
cp ${BUILD}/bin/weston-s* ${DEB}/usr/lib/weston/ || :
cp ${BUILD}/bin/weston-touch-calibrator ${DEB}/usr/lib/weston/ || :
cp ${BUILD}/bin/weston-transformed ${DEB}/usr/lib/weston/ || :

mkdir -p ${DEB}/usr/share/man
cp -r ${BUILD}/share/man/man1 ${DEB}/usr/share/man/
cp -r ${BUILD}/share/man/man5 ${DEB}/usr/share/man/
cp -r ${BUILD}/share/man/man7 ${DEB}/usr/share/man/
gzip ${DEB}/usr/share/man/man1/*
gzip ${DEB}/usr/share/man/man5/*
gzip ${DEB}/usr/share/man/man7/*

cp -r ${BUILD}/share/wayland-sessions ${DEB}/usr/share/
cp -r ${BUILD}/share/weston ${DEB}/usr/share/

mkdir -p ${DEB}/usr/share/lintian/overrides
echo "weston: setuid-binary usr/bin/weston-launch 4755 root/root" > ${DEB}/usr/share/lintian/overrides/weston

mkdir -p ${DEB}/usr/share/doc/weston/examples
cp weston.ini ${DEB}/usr/share/doc/weston/examples/
cp changelog.md ${DEB}/usr/share/doc/weston/changelog.Debian
cp COPYING ${DEB}/usr/share/doc/weston/copyright
cp README.Debian ${DEB}/usr/share/doc/weston/README.Debian || :
gzip ${DEB}/usr/share/doc/weston/changelog.Debian

cd ${DEB}
find usr -type f -exec md5sum {} > md5sums \;
mv -f ./md5sums DEBIAN/
cd ..

dpkg-deb --root-owner-group --build ${DEB_MAIN}

cd $PROJECT_DIR


echo " "
echo -e "Make ${GREEN}${DEB_LIB5}.deb${NC} package"
echo " "
DEB="${DEBS_PATH}/${DEB_LIB5}"
rm -rf ${DEB}/usr/*

mkdir -p ${DEB}/usr/lib/aarch64-linux-gnu/libweston-5
cp ${BUILD}/lib/aarch64-linux-gnu/libweston-5/*.so ${DEB}/usr/lib/aarch64-linux-gnu/libweston-5/
cp -P ${BUILD}/lib/aarch64-linux-gnu/libweston-desktop-5.so.0* ${DEB}/usr/lib/aarch64-linux-gnu/
cp -P ${BUILD}/lib/aarch64-linux-gnu/libweston-5.so.0* ${DEB}/usr/lib/aarch64-linux-gnu/

mkdir -p ${DEB}/usr/share/doc/libweston-5-0
cp changelog.md ${DEB}/usr/share/doc/libweston-5-0/changelog.Debian
cp COPYING ${DEB}/usr/share/doc/libweston-5-0/copyright || :
gzip ${DEB}/usr/share/doc/libweston-5-0/changelog.Debian

cd ${DEB}
find usr -type f -exec md5sum {} > md5sums \;
mv -f ./md5sums DEBIAN/
cd ..

dpkg-deb --root-owner-group --build ${DEB_LIB5}

cd $PROJECT_DIR


if [ $WITH_DEV -gt 0 ]
then
    echo " "
    echo -e "Make ${GREEN}${DEB_LIBD}.deb${NC} package"
    echo " "
    DEB="${DEBS_PATH}/${DEB_LIBD}"
    rm -rf ${DEB}/usr/*


    mkdir -p ${DEB}/usr/include
    cp -r ${BUILD}/include/libweston-5 ${DEB}/usr/include/

    mkdir -p ${DEB}/usr/lib/aarch64-linux-gnu/pkgconfig
    cp ${BUILD}/lib/aarch64-linux-gnu/pkgconfig/libweston* ${DEB}/usr/lib/aarch64-linux-gnu/pkgconfig/
    cp -P ${BUILD}/lib/aarch64-linux-gnu/libweston-5.so ${DEB}/usr/lib/aarch64-linux-gnu/
    cp -P ${BUILD}/lib/aarch64-linux-gnu/libweston-desktop-5.so ${DEB}/usr/lib/aarch64-linux-gnu/

    mkdir -p ${DEB}/usr/share/doc/libweston-5-dev
    cp changelog.md ${DEB}/usr/share/doc/libweston-5-dev/changelog.Debian
    cp COPYING ${DEB}/usr/share/doc/libweston-5-dev/copyright
    gzip ${DEB}/usr/share/doc/libweston-5-dev/changelog.Debian

    cd ${DEB}
    find usr -type f -exec md5sum {} > md5sums \;
    mv -f ./md5sums DEBIAN/
    cd ..

    dpkg-deb --root-owner-group --build ${DEB_LIBD}

    cd $PROJECT_DIR
fi


echo "Finish"