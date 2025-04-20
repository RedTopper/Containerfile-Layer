FROM scratch AS build
COPY build /

# Need to wait for this before Fedora 42!
# https://github.com/linux-surface/linux-surface/issues/1735
FROM ghcr.io/ublue-os/kinoite-main:41

RUN --mount=type=bind,from=build,source=/,target=/build \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    dnf5 config-manager \
        addrepo --from-repofile=https://pkg.surfacelinux.com/fedora/linux-surface.repo && \
    dnf5 install  -y --setopt=keepcache=1 --allowerasing \
        kernel-surface iptsd libwacom-surface libwacom-surface-data && \
    dnf5 remove -y --setopt=keepcache=1 \
        kernel kernel-core kernel-modules kernel-modules-extra && \
    systemctl disable linux-surface-default-watchdog.path && \
    /build/initramfs.sh && \
    rm -rf /boot/.vmlinuz* /boot/* && echo "OK!"

RUN --mount=type=bind,from=build,source=/,target=/build \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    dnf5 remove -y --setopt=keepcache=1 \
        firefox firefox-langpacks && \
    dnf5 install -y --setopt=keepcache=1 \
        arc-theme cockpit plasma-mobile plasma-settings zsh && \
    cp /build/sddm-wallpaper.jpg /usr/share/wallpapers/Next/contents/images/5120x2880.png

# Clean var folder to pass linting checks.
RUN ls /usr/lib/modules/ && tree /var && rm -rf /var/* && ostree container commit

RUN bootc container lint
