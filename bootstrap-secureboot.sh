#!/bin/bash
set -euo pipefail

if [[ -f key/surface.cer ]]; then
    echo "This will install the surface secureboot key"
    echo "The next step will ask you for a password. Choose a short, temporary password."
    echo "When you reboot, you will need to enter this password again to enroll the key."
    echo "> Press any key to continue."
    read
    mokutil --import key/surface.cer
else
    echo "Key doesn't exist! Have you ran 'just build' or 'just update' yet?"
fi
