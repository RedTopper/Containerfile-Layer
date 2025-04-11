FROM scratch AS rpm

COPY rpm/* /rpm/

FROM ghcr.io/ublue-os/kinoite-nvidia:41

# Install custom packages and remove firefox (only needed on base images)
RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    dnf5 remove -y --setopt=keepcache=1  \
        firefox firefox-langpacks && \
    dnf5 install -y --setopt=keepcache=1 \
        arc-theme \
        cockpit cockpit-machines cockpit-podman cockpit-selinux \
        steam steam-devices \
        monado-vulkan-layers waydroid input-remapper \
        libi2c-devel lm_sensors libvirt \
        mono-devel python3-pip flatpak-builder \
        qdirstat qterminal \
        zsh && \
    systemctl enable input-remapper

# Add some packages from bazzite, then disable the COPRs so later commands do not use them
# kylegospo/bazzite -> gamescope-session-plus gamescope-session-steam
# kylegospo/bazzite-multilib -> gamescope (custom build, needs higher priority than fedora build)
# kylegospo/wallpaper-engine-kde-plugin -> wallpaper-engine-kde-plugin
RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    dnf5 -y copr enable kylegospo/bazzite && \
    dnf5 -y copr enable kylegospo/bazzite-multilib && \
    dnf5 -y copr enable kylegospo/wallpaper-engine-kde-plugin && \
    dnf5 -y config-manager setopt copr:copr.fedorainfracloud.org:kylegospo:bazzite-multilib.priority=98 && \
    dnf5 install -y --setopt=keepcache=1 \
        wallpaper-engine-kde-plugin \
        gamescope gamescope-session-plus gamescope-session-steam && \
    dnf5 -y copr disable kylegospo/bazzite && \
    dnf5 -y copr disable kylegospo/bazzite-multilib && \
    dnf5 -y copr disable kylegospo/wallpaper-engine-kde-plugin

# Finally, install custom local RPMs. Just drop them in the ./rpm folder.
RUN --mount=type=bind,from=rpm,source=/rpm,target=/rpm \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    dnf5 install -y --setopt=keepcache=1 /rpm/*

RUN dnf5 clean all && \
    find /var/* -maxdepth 0 -type d \! -name cache -exec rm -fr {} \; && \
    mkdir -p /var/tmp && \
    chmod -R 1777 /var/tmp && \
    ostree container commit

RUN bootc container lint
