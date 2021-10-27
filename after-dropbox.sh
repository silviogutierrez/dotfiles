#!/bin/bash

set -e
set -x

mackup restore --force
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain \
    ~/Dropbox/Backup/self-signed-root-cert/root.pem
