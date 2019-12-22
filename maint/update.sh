#!/bin/bash

set -euxo pipefail

OLD_LINES=0
if [[ -f perl-releases.v1.csv ]]; then
  OLD_LINES=$(wc -l < perl-releases.v1.csv)
fi
NEW_LINES=$(wc -l < perl-releases.v1.csv.new)
if [[ $OLD_LINES -ge $NEW_LINES ]]; then
  echo "There is no diff, exit"
  exit
fi

mv perl-releases.v1.csv.new perl-releases.v1.csv
git config --global user.name 'Shoichi Kaji'
git config --global user.email 'skaji@cpan.org'
git commit -am 'auto update'
git push https://skaji:$GITHUB_TOKEN@github.com/skaji/perl-releases.git master
