./autogen.sh \
    --prefix=/usr \
    --disable-setuid-install \
    --enable-xwayland \
    --enable-x11-compositor \
    --enable-drm-compositor \
    --enable-wayland-compositor \
    --enable-headless-compositor \
    --enable-fbdev-compositor \
    --enable-rdp-compositor \
    --enable-screen-sharing \
    --enable-vaapi-recorder \
    --enable-simple-clients \
    --enable-simple-egl-clients \
    --enable-simple-dmabuf-drm-client \
    --enable-simple-dmabuf-v4l-client \
    --enable-clients \
    --enable-resize-optimization \
    --enable-weston-launch \
    --enable-fullscreen-shell \
    --enable-colord \
    --enable-dbus \
    --enable-systemd-login \
    --enable-junit-xml \
    --enable-ivi-shell \
    --enable-wcap-tools \
    --disable-libunwind \
    --enable-demo-clients-install \
    --enable-lcms \
    --with-cairo=glesv2 \
    --libdir=/usr/lib/aarch64-linux-gnu \
    --libexecdir=/usr/lib/weston