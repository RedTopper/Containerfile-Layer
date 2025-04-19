FROM alpine:latest AS rpms

RUN mkdir /rpms && apk --no-cache add ca-certificates

WORKDIR /rpms
RUN wget https://github.com/linux-surface/linux-surface/releases/download/silverblue-20201215-1/kernel-20201215-1.x86_64.rpm

FROM ghcr.io/ublue-os/kinoite-main:41

RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    dnf5 remove -y --setopt=keepcache=1 \
        firefox firefox-langpacks && \
    dnf5 install -y --setopt=keepcache=1 \
        arc-theme cockpit plasma-mobile plasma-settings zsh

RUN --mount=type=bind,from=rpms,source=/rpms,target=/rpms \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    wget -O /etc/yum.repos.d/linux-surface.repo \
        https://pkg.surfacelinux.com/fedora/linux-surface.repo && \
    dnf remove -y --setopt=keepcache=1 \
        kernel-core kernel-modules kernel-modules-extra && \
    dnf install  -y --setopt=keepcache=1 --allowerasing \
        /rpms/*.rpm kernel-surface iptsd libwacom-surface libwacom-surface-data; \
    kver="$(rpm -q --qf "%{REQUIREVERSION}" kernel-surface)"; \
    dracut --no-hostonly --kver "$kver" --reproducible -v --add ostree -f "/lib/modules/$kver/initramfs.img" && \
    chmod 0600 "/lib/modules/$kver/initramfs.img" && \
    tree /boot && rm -rf /boot/.vmlinuz* /boot/*

# Once secureboot is installed, you don't need to run this step anymore.
RUN --mount=type=bind,src=/key,dst=/key,relabel=shared,rw=true \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    dnf5 install -y --setopt=keepcache=1 \
        install surface-secureboot && \
    cp /usr/share/surface-secureboot/surface.cer /key && \
    echo "The above key has been copied to the 'key' directory." && \
    echo "Run the 'bootstrap-secureboot.sh' script after the build finishes!"

COPY assets/sddm-wallpaper.jpg /usr/share/wallpapers/Next/contents/images/5120x2880.png

# Clean var folder to pass linting checks.
RUN tree /var && ls /usr/lib/modules/ && rm -rf /var/* && ostree container commit

RUN bootc container lint
