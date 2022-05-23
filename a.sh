#!/bin/bash

TOOLCHAIN="/home/imx8/InstallQt/toolchain/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu/bin"
SYSROOT="/home/denis/projects/defigo/sysroot"
# export PKG_CONFIG_SYSROOT_DIR="/home/denis/projects/defigo/sysroot"
# export PKG_CONFIG_DIR=""
# export PKG_CONFIG_LIBDIR="${SYSROOT}/usr/lib/pkgconfig:${SYSROOT}/usr/share/pkgcongif"
export PKG_CONFIG_SYSROOT_DIR="${SYSROOT}"

I1="-I${SYSROOT}/usr/include/vivante"
I2="-I${SYSROOT}/usr/include/libdrm"
I3="-I${SYSROOT}/usr/lib/aarch64-linux-gnu/glib-2.0/include"
I4="-I${SYSROOT}/usr/lib/aarch64-linux-gnu/dbus-1.0/include"

L1="${SYSROOT}/usr/lib/aarch64-linux-gnu"

autoreconf --force -v --install

#	--with-sysroot=/home/imx8/InstallQt/sysroot \
# ./configure --with-cairo=image \
# -rpath-link ${SYSROOT}/usr/lib
#  --disable-dependency-tracking
#
#
	# CC="${TOOLCHAIN}/aarch64-linux-gnu-gcc" \
	# CPP="${TOOLCHAIN}/aarch64-linux-gnu-cpp" \
	# LD="${TOOLCHAIN}/aarch64-linux-gnu-ld" \
./configure --host aarch64-linux-gnu --build x86_64-linux-gnu \
    --prefix="/home/denis/projects/defigo/weston-deb/build" \
	CFLAGS="--sysroot=${SYSROOT} ${I1} ${I2} ${I3} ${I4} -Wl,-rpath-link,${L1},--allow-shlib-undefined" \
	LDFLAGS="--sysroot=${SYSROOT}" \
	--with-sysroot="${SYSROOT}" \
	--with-cairo=image \
	--enable-drm-compositor \
	--enable-fbdev-compositor \
	--enable-headless-compositor \
	--enable-wayland-compositor \
	--enable-x11-compositor \
	--enable-rdp-compositor \
	--enable-screen-sharing \
	--enable-systemd-notify \
	--enable-xwayland \
	--disable-devdocs \
	--disable-simple-dmabuf-drm-client \
	--enable-weston-launch

# find usr -type f -exec md5sum {} > md5sums \;

# dpkg-deb --root-owner-group --build weston_5.0.0-3-var-dpu-g2d_arm64

#debmake -p',libweston-5,libweston-5-dev' \
#-v 5.0.0 -r 3-var-gpu-d2d \
#-b"weston:bin,libweston-5:lib,libweston-5-dev:dev" \
#-e debian-x@lists.debian.org -f "Debian X Strike Force" \
#-j -m
#
# debmake [-h] [-c | -k] [-n | -a package-version.orig.tar.gz | -d | -t ] [-p package] [-u version] [-r revision] [-z extension] [-b
    #    "binarypackage, ...]" [-e foo@example.org] [-f "firstname lastname"] [-i "buildtool" | -j] [-l license_file] [-m] [-o file] [-q] [-s]
    #    [-v] [-w "addon, ..."] [-x [01234]] [-y] [-L] [-P] [-T]
