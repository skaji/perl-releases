#!/usr/bin/env perl
use 5.14.0;
use warnings;
use CPAN::Perl::Releases::MetaCPAN;

my $release = CPAN::Perl::Releases::MetaCPAN->new->get;

my @release;
for my $r (@$release) {
    my ($version, $major, $minor, $RC) = $r->{name} =~ /^perl-(5\.(\d+)\.(\d+)(?:-(?:RC|TRIAL)(\d+))?)$/;
    next if !$major;
    my $type = $major % 2 == 1 ? "unstable"
             : defined $RC ? "testing"
             : "stable";
    my $sort_by = sprintf "5.%03d.%03d.%03d", $major, $minor, (defined $RC ? $RC : 999);
    next if $sort_by lt "5.008.001.000";
    my $url = $r->{download_url};
    $url =~ s/\.(bz2|xz)$/.gz/;
    my $xz_url = "NA";
    if ($sort_by gt "5.021.005.999" && $version ne "5.23.6") {
        $xz_url = $url =~ s/\.gz$/.xz/r;
    }

    push @release, {
        version => $version,
        type => $type,
        sort_by => $sort_by,
        url => $url,
        xz_url => $xz_url,
    };
}

@release = sort { $b->{sort_by} cmp $a->{sort_by} } @release;

for my $r (@release) {
    say join ",", @{$r}{qw(sort_by type version url xz_url)};
}
