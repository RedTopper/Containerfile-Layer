FROM quay.io/fedora-ostree-desktops/kinoite:41

# Install rpmfusion and install the gstreamer-plugins/ffmpeg, among other things
RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    dnf5 remove -y --setopt=keepcache=1 \
        firefox firefox-langpacks && \
    dnf5 install -y --setopt=keepcache=1 \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
    dnf5 install -y --setopt=keepcache=1 --allowerasing \
        arc-theme \
        distrobox \
        ffmpeg gstreamer1-plugins-bad-free-extras gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly gstreamer1-vaapi intel-media-driver \
        tk-devel \
        qterminal \
        zsh thefuck just

# Override the sddm wallpaper
COPY assets/sddm-wallpaper.png /usr/share/wallpapers/Next/contents/images/5120x2880.png

# Clean var folder to pass linting checks.
RUN tree /var && rm -rf /var/* && ostree container commit

RUN bootc container lint
