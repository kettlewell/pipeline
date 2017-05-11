#!/bin/bash
set -euo pipefail
root=$1
shift
test -n "${root:-}" && test ${root} != '/'
cd ${root}
# Strip documentation 
find usr/share/doc/ -type f |
  (while read line; do
    bn=$(basename ${line});
    if echo ${bn} | grep -Eiq '^(COPYING|LICENSE)'; then
      continue
    else
       rm $line
    fi;
   done)

rm usr/share/doc/{info,man} -rf
rm usr/share/gnupg/help*.txt -f

# See: https://bugzilla.redhat.com/show_bug.cgi?id=1051816
KEEPLANG=en_US
for dir in locale i18n; do 
    find usr/share/${dir} -mindepth  1 -maxdepth 1 -type d -not \( -name "${KEEPLANG}" -o -name POSIX \) -exec rm -rf {} +
done

# Pruning random things
rm usr/lib/rpm/rpm.daily   # seriously?
rm usr/lib64/nss/unsupported-tools/ -rf  # unsupported

# gcc should really split this off
rm usr/share/gcc*/python -rf

# Statically linked crap
rm usr/sbin/{glibc_post_upgrade.x86_64,sln}
ln usr/bin/ln usr/sbin/sln

# Final pruning
rm -rf etc/machine-id var/cache/* var/log/* run/* tmp/*
