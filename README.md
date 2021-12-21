# List of perl releases

This repository contains a list of perl releases,
which will be automatically updated by [GitHub Actions](https://github.com/skaji/perl-releases/actions) every 30 minutes.

# Details of the list

## perl-releases.v1.csv

Each line of [perl-releases.v1.csv](perl-releases.v1.csv) contains the following fields:

* 1st: key which may be useful for sorting
* 2nd: status (stable, unstable or testing)
* 3rd: version like 5.30.1
* 4th: gz tarball url
* 5th: xz tarball url if any (if there is no xz tarball for this version, then it will be `NA`)
* 6th: latest release in each stable releases

An example is:

```
❯ grep ,5.30.0, perl-releases.v1.csv | perl -F, -anle 'print $_+1, ": $F[$_]" for 0..$#F'
1: 5.030.000.999
2: stable
3: 5.30.0
4: https://cpan.metacpan.org/authors/id/X/XS/XSAWYERX/perl-5.30.0.tar.gz
5: https://cpan.metacpan.org/authors/id/X/XS/XSAWYERX/perl-5.30.0.tar.xz
6: (empty)
```

# Credit

The source of the list of perl releases is https://fastapi.metacpan.org.

# Author

Shoichi Kaji

# License

MIT
