#!/bin/bash

passphrase=$(cat passphrase.txt)

ls -la /tmp/secret-key-backup.asc
gpg --batch --passphrase="$passphrase" --import /tmp/secret-key-backup.asc
gpg --batch --passphrase="$passphrase" --import /tmp/secret-subkey-backup.asc

sleep 1
gpg --import-ownertrust /tmp/trustdb-backup.txt
gpg --list-keys
gpg --list-secret-keys

rg --files --hidden /root/.gnupg
