package Benchmark::Perl::Formance::Plugin::PerlCritic;
BEGIN {
  $Benchmark::Perl::Formance::Plugin::PerlCritic::AUTHORITY = 'cpan:SCHWIGON';
}

use strict;
use warnings;

our $VERSION = "0.001";

#############################################################
#                                                           #
# Benchmark Code ahead - Don't touch without strong reason! #
#                                                           #
#############################################################

use File::Temp qw(tempfile tempdir);
use File::Copy::Recursive qw(dircopy);
use File::ShareDir qw(dist_dir);
use Time::HiRes qw(gettimeofday);

our $count;
our $recurse;

use Benchmark ':hireswallclock';

sub prepare {
        my ($options) = @_;

        my $dstdir = tempdir( CLEANUP => 1 );
        my $srcdir = dist_dir('Benchmark-Perl-Formance-Cargo')."/PerlCritic";

        print STDERR "# Prepare Perl::Critic sources in $dstdir ...\n" if $options->{verbose} >= 3;
        dircopy($srcdir, $dstdir);

        return $dstdir;
}

sub upstream {
        my ($options, $dstdir) = @_;

        (my $perlcritic = $^X) =~ s!/perl[\d.]*$!/perlcritic!;
        print STDERR "# Use perlcritic: $perlcritic\n" if $options->{verbose} > 2;

        my $datadir = $dstdir;
        $datadir .= '/Perl/Critic/Utils' if $options->{fastmode};

        my $version = `$^X $perlcritic --version`; chomp $version;
        my $cmd     = qq{$^X $perlcritic --exclude RequireFilenameMatchesPackage $datadir};

        print STDERR "$cmd\n" if $options->{verbose} >= 3;

        my $t = timeit $count, sub {
                my $output = qx($cmd);
        };
        return {
                Benchmark           => $t,
                count               => $count,
                perl_critic_version => $version,
               };
}

sub bundled {
        my ($options, $dstdir) = @_;

        my $datadir = $dstdir;
        $datadir .= '/Perl/Critic/Utils' if $options->{fastmode};

        my $perlcritic = "$dstdir/perlcritic";
        my $version = `$^X -I $dstdir $dstdir/perlcritic --version`; chomp $version;
        my $cmd     = qq{$^X -I $dstdir $dstdir/perlcritic --exclude RequireFilenameMatchesPackage $datadir};

        print STDERR "# Use perlcritic: $^X $perlcritic\n" if $options->{verbose} > 2;
        print STDERR "$cmd\n" if $options->{verbose} >= 3;

        my $t = timeit $count, sub {
                my $output = qx($cmd);
        };
        return {
                Benchmark           => $t,
                count               => $count,
                perl_critic_version => $version,
               };
}

sub main {
        my ($options) = @_;

        $count   = $options->{fastmode} ? 1 : 2;

        my ($dstdir) = prepare($options);
        return {
                upstream => upstream ($options, $dstdir),
                bundled  => bundled  ($options, $dstdir),
               }
}

1;



__END__
=pod

=encoding utf-8

=head1 NAME

Benchmark::Perl::Formance::Plugin::PerlCritic

=head1 SYNOPSIS

Run it as any other plugin.

  $ perl-formance --plugins=PerlCritic

=head1 NAME

Benchmark::Perl::Formance::Plugin::PerlCritic - Run Perl::Critic on itself

=head1 AUTHOR

Steffen Schwigon <ss5@renormalist.net>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Steffen Schwigon.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

