#!/bin/bash

# https://risanb.com/code/backup-restore-gpg-key/

# docker run --rm --name mytest --workdir /tmp -v $(pwd):/tmp -ti taylorm/wrapdispute bash -x test3.sh

set -e
set -x

myscript=$(mktemp /tmp/test3.XXXX)

gpg --version

cat >$myscript <<EOF
#!/bin/bash

# https://github.com/gopasspw/gopass/blob/master/docs/config.md#configuration-options-1
gopass config core.nocolor true
gopass config
gopass --yes setup --create --alias pass --name "Your Name" --email yourname@example.com
EOF

chmod +x $myscript
script --flush --command "$myscript" </dev/null

passphrase=$(grep Passphrase typescript | sed -e 's#Passphrase: *##' | tr -dc '[[:print:]]')
echo "$passphrase"
echo "$passphrase" | xxd -c 1

rm -f /tmp/secret-key-backup.asc
gpg --export-secret-keys --pinentry-mode=loopback --armor --passphrase="$passphrase" --output=/tmp/secret-key-backup.asc
ls -la /tmp/secret-key-backup.asc

rm -f /tmp/trustdb-backup.txt
gpg --export-ownertrust --armor >/tmp/trustdb-backup.txt
ls -la /tmp/trustdb-backup.txt

# simulate disaster:
rm -rf ~/.gnupg

# ensure we're empty now:
gpg --list-keys

ls -la /tmp/secret-key-backup.asc
gpg --batch --passphrase="$passphrase" --import /tmp/secret-key-backup.asc
gpg --import-ownertrust /tmp/trustdb-backup.txt
gpg --list-secret-keys
