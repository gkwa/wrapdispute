#!/bin/bash

# docker run --rm --workdir /tmp -v $(pwd):/tmp -ti taylorm/wrapdispute bash
# bash -x vault_test.sh

# https://gist.github.com/jan-warchol/bd6340a8b49f0033aec5fbe3e9aa10d5

gpg --batch --passphrase 'mysecret' --quick-gen-key john.doe@gmail.com default default
gpg --list-keys
pass init -p aws-vault john.doe@gmail.com

gpg --batch --edit-key john.doe@gmail.com quit

export AWS_VAULT_BACKEND=pass
export AWS_VAULT_PASS_PASSWORD_STORE_DIR=/root/.password-store/aws-vault

set +o history
export AWS_ACCESS_KEY_ID=AKIZZZZAAAAAPPPPYYYY
export AWS_SECRET_ACCESS_KEY=AAAABBBBBCCCCCDDDDEEEEFFFFGGGGIIIIHHHHP
set -o history

aws-vault add my_test_profile --debug --env --backend=pass

unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY

echo AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
echo AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

# https://github.com/99designs/aws-vault/issues/866#issue-1140436627
aws configure set profile.my_test_profile.region us-west-2
cat ~/.aws/config

pass ls

echo secret is mysecret
pass show aws-vault/my_test_profile

aws-vault exec my_test_profile -- aws --region us-west-2 s3 ls s3://mybucket
aws --region us-west-2 s3 ls s3://mybucket

rg --hidden --files \
    /root/.gnupg \
    /root/.aws \
    /root/.password-store
