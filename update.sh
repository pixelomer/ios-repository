#!/usr/bin/env bash

set -e

md5() {
  command md5sum "${@}" | awk '{ print $1 }'
}

sha256() {
  command shasum -a 256 "${@}" | awk '{ print $1 }'
}

len() {
  command wc -c "${@}" | awk '{ print $1 }'
}

entry() {
  printf "$("$1" "$2") $(len "$2") $2"
}

dpkg-scanpackages -t deb -m debs | tee Packages | bzip2 -c > Packages.bz2
cat > Release <<EOF
$(cat Release.template)
MD5Sum:
  $(entry md5 Packages)
  $(entry md5 Packages.bz2)
SHA256Sum:
  $(entry sha256 Packages)
  $(entry sha256 Packages.bz2)
EOF
