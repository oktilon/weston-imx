#!/bin/bash

set -e

# TOOLCHAIN="/home/imx8/InstallQt/toolchain/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu/bin"
SYSROOT="/home/denis/projects/defigo/sysroot"
# SYSROOT="/home/denis/projects/defigo/debian_imx8qxp-var-som/rootfs"
BUILD_BASE="/home/denis/projects/defigo/build"
BUILD="${BUILD_BASE}/usr"
YELLOW='\e[1;33m'
GREEN='\e[1;32m'
NC='\e[0m'

DEBS_PATH="/home/denis/projects/defigo/weston-imx"
DEB_MAIN="weston_5.0.0-3-var-dpu-g2d-rdp_arm64"
DEB_LIB5="libweston-5-0_5.0.0-3-var-dpu-g2d-rdp_arm64"
DEB_LIBD="libweston-5-dev_5.0.0-3-var-dpu-g2d-rdp_arm64"
# export PKG_CONFIG_SYSROOT_DIR="/home/denis/projects/defigo/sysroot"
# export PKG_CONFIG_DIR=""
PK1="${SYSROOT}/usr/lib/pkgconfig"
PK2="${SYSROOT}/usr/share/pkgconfig"
PK3="${SYSROOT}/usr/lib/aarch64-linux-gnu/pkgconfig"
PK4="${SYSROOT}/usr/lib/aarch64-linux-gnu/vivante/pkgconfig"
export PKG_CONFIG_LIBDIR="${PK1}:${PK2}:${PK3}:${PK4}"
export PKG_CONFIG_SYSROOT_DIR="${SYSROOT}"

I1="-I${SYSROOT}/usr/include/vivante"
I2="-I${SYSROOT}/usr/include/libdrm"
I3="-I${SYSROOT}/usr/lib/aarch64-linux-gnu/glib-2.0/include"
I4="-I${SYSROOT}/usr/lib/aarch64-linux-gnu/dbus-1.0/include"

L1="${SYSROOT}/usr/lib/aarch64-linux-gnu"

echo -e " ${YELLOW}"
echo " *********************"
echo " **      CLEAN      **"
echo " *********************"
echo -e " ${NC}"


make clean
sudo rm -rf ${BUILD_BASE}/*

echo -e " ${YELLOW}"
echo " *********************"
echo " **     PREPARE     **"
echo " *********************"
echo -e " ${NC}"

autoreconf --force -v --install

echo -e " ${YELLOW}"
echo " *********************"
echo " **    CONFIGURE    **"
echo " *********************"
echo -e " ${NC}"


# eth.addr == f8:dc:7a:52:df:76
#	--with-sysroot=/home/imx8/InstallQt/sysroot \
# ./configure --with-cairo=image \
# -rpath-link ${SYSROOT}/usr/lib
#  --disable-dependency-tracking
#  CFLAGS -Wl     ,--allow-shlib-undefined
#  CFLAGS -Wl     ,--verbose
#
	# CC="${TOOLCHAIN}/aarch64-linux-gnu-gcc" \
	# CPP="${TOOLCHAIN}/aarch64-linux-gnu-cpp" \
	# LD="${TOOLCHAIN}/aarch64-linux-gnu-ld" \
	# LT_SYS_LIBRARY_PATH="/usr/lib/aarch64-linux-gnu:${L1}" \
./configure --host aarch64-linux-gnu --build x86_64-linux-gnu \
    --prefix=/usr \
	CFLAGS="--sysroot=${SYSROOT} ${I1} ${I2} ${I3} ${I4} -Wl,-rpath-link,${L1},--allow-shlib-undefined" \
	LDFLAGS="--sysroot=${SYSROOT}" \
	--libdir="/usr/lib/aarch64-linux-gnu" \
	--libexecdir="/usr/lib/weston" \
	--with-sysroot="${SYSROOT}" \
	--with-cairo=glesv2 \
	--enable-egl \
	--enable-imxgpu \
	--enable-imxg2d \
	--enable-drm-compositor \
	--enable-fbdev-compositor \
	--enable-headless-compositor \
	--enable-wayland-compositor \
	--enable-x11-compositor \
	--enable-rdp-compositor \
	--enable-screen-sharing \
	--enable-systemd-notify \
	--enable-xwayland \
	--enable-demo-clients-install \
	--disable-devdocs \
	--enable-weston-launch

if [ $1 == 'conf' ]
then
	exit 1
fi


echo -e " ${YELLOW}"
echo " *********************"
echo " **      MAKE       **"
echo " *********************"
echo -e " ${NC}"

# make --debug=v
make |& tee make.log

echo -e " ${YELLOW}"
echo " *********************"
echo " **  MAKE  INSTALL  **"
echo " *********************"
echo -e " ${NC}"

sudo make DESTDIR=${BUILD_BASE} install |& tee install.log

if [ ! "$(ls -A $BUILD_BASE)" ]
then
	echo "Build error"
	exit 1
fi

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
cp ${BUILD}/bin/weston-c* ${DEB}/usr/lib/weston/
cp ${BUILD}/bin/weston-dnd ${DEB}/usr/lib/weston/
cp ${BUILD}/bin/weston-e* ${DEB}/usr/lib/weston/
cp ${BUILD}/bin/weston-f* ${DEB}/usr/lib/weston/
cp ${BUILD}/bin/weston-image ${DEB}/usr/lib/weston/
cp ${BUILD}/bin/weston-multi-resource ${DEB}/usr/lib/weston/
cp ${BUILD}/bin/weston-presentation-shm ${DEB}/usr/lib/weston/
cp ${BUILD}/bin/weston-resizor ${DEB}/usr/lib/weston/
cp ${BUILD}/bin/weston-s* ${DEB}/usr/lib/weston/
cp ${BUILD}/bin/weston-touch-calibrator ${DEB}/usr/lib/weston/
cp ${BUILD}/bin/weston-transformed ${DEB}/usr/lib/weston/

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
cp copyright ${DEB}/usr/share/doc/weston/copyright
cp README.Debian ${DEB}/usr/share/doc/weston/README.Debian
gzip ${DEB}/usr/share/doc/weston/changelog.Debian

cd ${DEB}
find usr -type f -exec md5sum {} > md5sums \;
mv -f ./md5sums DEBIAN/
cd ..

dpkg-deb --root-owner-group --build ${DEB_MAIN}



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
cp copyright ${DEB}/usr/share/doc/libweston-5-0/copyright
gzip ${DEB}/usr/share/doc/libweston-5-0/changelog.Debian

cd ${DEB}
find usr -type f -exec md5sum {} > md5sums \;
mv -f ./md5sums DEBIAN/
cd ..

dpkg-deb --root-owner-group --build ${DEB_LIB5}




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
cp copyright ${DEB}/usr/share/doc/libweston-5-dev/copyright
gzip ${DEB}/usr/share/doc/libweston-5-dev/changelog.Debian

cd ${DEB}
find usr -type f -exec md5sum {} > md5sums \;
mv -f ./md5sums DEBIAN/
cd ..

dpkg-deb --root-owner-group --build ${DEB_LIBD}



echo " "
echo "sudo MACHINE=imx8qxp-var-som ./var_make_debian.sh -c rootfs |& tee rootfs.log"
echo "sudo MACHINE=imx8qxp-var-som ./var_make_debian.sh -c sdcard -d /dev/mmcblk0"