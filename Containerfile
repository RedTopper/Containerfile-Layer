FROM scratch AS rpms

COPY rpms/* /rpms/

FROM ghcr.io/ublue-os/kinoite-nvidia:41

RUN --mount=type=bind,from=rpms,source=/rpms,target=/rpms \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    # Install custom local RPMs first
    dnf5 install -y /rpms/* && \
    # Enable COPRs
    dnf5 -y copr enable kylegospo/bazzite && \
    dnf5 -y copr enable kylegospo/bazzite-multilib && \
    dnf5 -y copr enable kylegospo/wallpaper-engine-kde-plugin && \
    # Remove firefox (only needed on base images)
    dnf5 remove -y firefox firefox-langpacks && \
    # Install custom packages
    dnf5 install -y \
      arc-theme wallpaper-engine-kde-plugin \
      cockpit cockpit-machines cockpit-podman cockpit-selinux \
      steam steam-devices gamescope gamescope-session-plus gamescope-session-steam \
      monado-vulkan-layers waydroid input-remapper \
      libi2c-devel lm_sensors libvirt \
      mono-devel python3-pip flatpak-builder \
      qdirstat qterminal \
      zsh && \
    # Disable COPRs so they don't end up in the image
    dnf5 -y copr disable kylegospo/bazzite && \
    dnf5 -y copr disable kylegospo/bazzite-multilib && \
    dnf5 -y copr disable kylegospo/wallpaper-engine-kde-plugin && \
    systemctl enable input-remapper && \
    echo "OK!"

RUN bootc container lint
