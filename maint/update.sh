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
git config --global user.name 'github-actions[bot]'
git config --global user.email '41898282+github-actions[bot]@users.noreply.github.com'
git add perl-releases.v1.csv
MESSAGE="$(git diff --cached | grep '^+5' | cut -d, -f3)"
if [[ -z $MESSAGE ]]; then
  MESSAGE='auto update'
fi
git commit -m "$MESSAGE"
git push https://skaji:$GITHUB_TOKEN@github.com/skaji/perl-releases.git main
