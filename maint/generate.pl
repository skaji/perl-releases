#!/usr/bin/env perl
use 5.30.0;
use warnings;
use CPAN::Perl::Releases::MetaCPAN;
use Sub::Retry 'retry';

my $releases = retry 3, 10, sub {
    my $releases = CPAN::Perl::Releases::MetaCPAN->new->get;
     if (my @empty = grep { !$_->{download_url} } $releases->@*) {
         die "Empty download_url for ", (join ", ", map { $_->{name} } @empty);
     }
     $releases;
};

my @release;
for my $r ($releases->@*) {
    my ($version, $major, $minor, $RC) = $r->{name} =~ /^perl-(5\.(\d+)\.(\d+)(?:-(?:RC|TRIAL)(\d+))?)$/;
    next if !$major;
    my $key = sprintf "5.%03d.%03d.%03d", $major, $minor, (defined $RC ? $RC : 999);
    next if $key lt "5.008.001.000";
    my $status = $major % 2 == 1 ? "unstable" : defined $RC ? "testing" : "stable";
    my $download_url = $r->{download_url};
    my $gz_url = $download_url =~ s/\.(bz2|xz)$/.gz/r;
    my $xz_url = $key gt "5.021.005.999" && $version ne "5.23.6" ? $gz_url =~ s/\.gz$/.xz/r : "NA";

    push @release, {
        key => $key,
        status => $status,
        version => $version,
        gz_url => $gz_url,
        xz_url => $xz_url,
    };
}

for my $r (sort { $b->{key} cmp $a->{key} } @release) {
    say join ",", $r->@{qw(key status version gz_url xz_url)};
}
