#!/bin/bash

TOOLCHAIN="/home/imx8/InstallQt/toolchain/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu/bin"
SYSROOT="/home/denis/projects/defigo/sysroot"
# export PKG_CONFIG_SYSROOT_DIR="/home/denis/projects/defigo/sysroot"
# export PKG_CONFIG_DIR=""
# export PKG_CONFIG_LIBDIR="${SYSROOT}/usr/lib/pkgconfig:${SYSROOT}/usr/share/pkgcongif"
export PKG_CONFIG_SYSROOT_DIR="${SYSROOT}"

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
	CFLAGS="--sysroot=${SYSROOT} -I${SYSROOT}/usr/include/vivante -I${SYSROOT}/usr/include/libdrm -I${SYSROOT}/usr/lib/aarch64-linux-gnu/glib-2.0/include -Wl,-rpath-link,${SYSROOT}/usr/lib/aarch64-linux-gnu,--allow-shlib-undefined,-verbose" \
	CPPFLAGS="--sysroot=${SYSROOT} -I${SYSROOT}/usr/include/vivante" \
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


