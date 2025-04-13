FROM scratch AS rpms

COPY rpms/* /rpms/

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
# kylegospo/bazzite-multilib -> gamescope
# kylegospo/wallpaper-engine-kde-plugin -> wallpaper-engine-kde-plugin
RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    REPOS="kylegospo/bazzite kylegospo/bazzite-multilib kylegospo/wallpaper-engine-kde-plugin"; \
    for repo in $REPOS; do dnf5 -y copr enable $repo && dnf5 -y config-manager setopt "*${repo////:}.priority=10"; done && \
    dnf5 install -y --setopt=keepcache=1 \
        wallpaper-engine-kde-plugin \
        gamescope gamescope-session-plus gamescope-session-steam && \
    for repo in $REPOS; do dnf5 -y copr disable $repo; done

# Install custom local RPMs (mostly for protonmail)
RUN --mount=type=bind,from=rpms,source=/rpms,target=/rpms \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    dnf5 install -y --setopt=keepcache=1 /rpms/*

COPY users/missing-users.conf /usr/lib/sysusers.d/missing-users.conf

# Clean var folder.
RUN tree /var && rm -rf /var/* && ostree container commit

RUN bootc container lint
