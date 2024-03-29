package Benchmark::Perl::Formance::Plugin::Shootout::pidigits;
BEGIN {
  $Benchmark::Perl::Formance::Plugin::Shootout::pidigits::AUTHORITY = 'cpan:SCHWIGON';
}

# The Computer Language Benchmarks Game
#   http://shootout.alioth.debian.org/
#
#   contributed by Robert Bradshaw
#   modified by Ruud H.G.van Tol
#   modified by Emanuele Zeppieri
#   modified to use Math:GMP by Kuang-che Wu
#   Benchmark::Perl::Formance plugin by Steffen Schwigon

use strict;
use Math::GMP;
use Benchmark ':hireswallclock';

our $VERSION = "0.001";

#############################################################
#                                                           #
# Benchmark Code ahead - Don't touch without strong reason! #
#                                                           #
#############################################################

my($z0, $z1, $z2);

sub extract_digit { return ($z0*$_[0]+$z1)/$z2; }

sub compose {
    if ( defined $_[3] ) {
        $z1 = $z1*$_[0]+$_[1]*$z2;
    } else {
        $z1 = $z1*$_[2]+$_[1]*$z0;
    }
    $z0 = $z0*$_[0];
    $z2 = $z2*$_[2];
    return;
}

sub run
{
        my $output = '';

        ($z0, $z1, $z2) = map Math::GMP->new($_),1,0,1;

        my $n = $_[0];
        local ($,, $\) = ("\t", "\n");
        my ($i, $s, $d); my $k = 0;

        # main loop
        for $i (1..$n) { ## no critic
                while (
                       $z0>$z2 || ( $d = extract_digit(3) ) != extract_digit(4)
                      ) {
                        # y not safe
                        $k++; compose($k, 4*$k+2, 2*$k+1)
                }
                compose(10, -10*$d, 1, 1);
                $s .= $d;

                unless ( $i % 10 ) {
                        $output .= $s; undef $s;
                }
        }

        $s .= ' ' x (10-$i) if $i = $n % 10;

        $output .= $s if $s;
        return $output;
}

sub main
{
        my ($options) = @_;

        my $goal   = $options->{fastmode} ? 100 : 20_000;
        my $count  = $options->{fastmode} ? 1   : 5;

        my $result;
        my $t = timeit $count, sub { $result = run($goal) };
        return {
                Benchmark => $t,
                goal      => $goal,
                count     => $count,
                result    => substr($result, 0, $goal <= 10 ? $goal : 10)."[...]",
               };
}

1;



=pod

=encoding utf-8

=head1 NAME

Benchmark::Perl::Formance::Plugin::Shootout::pidigits

=head1 NAME

Benchmark::Perl::Formance::Plugin::Shootout::pidigits - Language shootout plugin: pidigits

=head1 ABOUT

This plugin does some runs the "pidigits" benchmark from the Language
Shootout.

=head1 AUTHOR

Steffen Schwigon <ss5@renormalist.net>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Steffen Schwigon.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

