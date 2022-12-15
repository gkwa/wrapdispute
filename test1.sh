#!/bin/bash

gpg --batch --passphrase 'mysecret' --quick-gen-key john.doe@gmail.com default default
gpg --list-keys
pass init john.doe@gmail.com

set +o history
export AWS_ACCESS_KEY_ID=AKIZZZZAAAAAPPPPYYYY
export AWS_SECRET_ACCESS_KEY=AAAABBBBBCCCCCDDDDEEEEFFFFGGGGIIIIHHHHP
set -o history
aws-vault add my_test_profile --debug --env --backend=pass

rg --hidden --files \
    /root/.gnupg \
    /root/.aws \
    /root/.password-store
