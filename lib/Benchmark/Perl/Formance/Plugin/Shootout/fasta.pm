package Benchmark::Perl::Formance::Plugin::Shootout::fasta;

# COMMAND LINE:
# /usr/bin/perl fasta.perl-4.perl 25000000

# The Computer Language Benchmarks game
# http://shootout.alioth.debian.org/
#
# contributed by David Pyke
# tweaked by Danny Sauer
# optimized by Steffen Mueller
# tweaked by Kuang-che Wu
# Benchmark::Perl::Formance plugin by Steffen Schwigon

use strict;
use warnings;

use Benchmark ':hireswallclock';

use constant IM => 139968;
use constant IA => 3877;
use constant IC => 29573;

use constant LINELENGTH => 60;

my $LAST = 42;
sub gen_random {
    return map {( ($_[0] * ($LAST = ($LAST * IA + IC) % IM)) / IM )} 1..($_[1]||1);
}

sub makeCumulative {
    my $genelist = shift;
    my $cp = 0.0;

    $_->[1] = $cp += $_->[1] foreach @$genelist;
}

sub selectRandom {
    my $genelist = shift;
    my $number = shift || 1;
    my @r = gen_random(1, $number);

    my $s;
    foreach my $r (@r) {
        foreach (@$genelist){
            if ($r < $_->[1]) { $s .= $_->[0]; last; }
        }
    }

    return $s;
}


sub makeRandomFasta {
    my ($id, $desc, $n, $genelist) = @_;

    print ">", $id, " ", $desc, "\n" if $ENV{PERLFORMANCE_SHOOTOUT_FASTA_PRINT};

    # print whole lines
    foreach (1 .. int($n / LINELENGTH) ){
            my $dummy = selectRandom($genelist, LINELENGTH)."\n";
            print $dummy if $ENV{PERLFORMANCE_SHOOTOUT_FASTA_PRINT};
    }
    # print remaining line (if required)
    if ($n % LINELENGTH){
            my $dummy = selectRandom($genelist, $n % LINELENGTH)."\n";
            print $dummy if $ENV{PERLFORMANCE_SHOOTOUT_FASTA_PRINT};
    }
}

sub makeRepeatFasta {
    my ($id, $desc, $s, $n) = @_;

    print ">", $id, " ", $desc, "\n" if $ENV{PERLFORMANCE_SHOOTOUT_FASTA_PRINT};

    my $r = length $s;
    my $ss = $s . $s . substr($s, 0, $n % $r);
    for my $j(0..int($n / LINELENGTH)-1) {
	my $i = $j*LINELENGTH % $r;
        my $dummy = substr($ss, $i, LINELENGTH)."\n";
	print $dummy if $ENV{PERLFORMANCE_SHOOTOUT_FASTA_PRINT};
    }
    if ($n % LINELENGTH) {
            my $dummy = substr($ss, -($n % LINELENGTH)). "\n";
            print $dummy if $ENV{PERLFORMANCE_SHOOTOUT_FASTA_PRINT};
    }
}


my $iub = [
    [ 'a', 0.27 ],
    [ 'c', 0.12 ],
    [ 'g', 0.12 ],
    [ 't', 0.27 ],
    [ 'B', 0.02 ],
    [ 'D', 0.02 ],
    [ 'H', 0.02 ],
    [ 'K', 0.02 ],
    [ 'M', 0.02 ],
    [ 'N', 0.02 ],
    [ 'R', 0.02 ],
    [ 'S', 0.02 ],
    [ 'V', 0.02 ],
    [ 'W', 0.02 ],
    [ 'Y', 0.02 ]
];

my $homosapiens = [
    [ 'a', 0.3029549426680 ],
    [ 'c', 0.1979883004921 ],
    [ 'g', 0.1975473066391 ],
    [ 't', 0.3015094502008 ]
];

my $alu =
    'GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG' .
    'GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA' .
    'CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT' .
    'ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA' .
    'GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG' .
    'AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC' .
    'AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA';

######################################################################
#main

sub run
{
        my ($n) = @_;

        makeCumulative($iub);
        makeCumulative($homosapiens);

        makeRepeatFasta ('ONE', 'Homo sapiens alu', $alu, $n*2);
        makeRandomFasta ('TWO', 'IUB ambiguity codes', $n*3, $iub);
        makeRandomFasta ('THREE', 'Homo sapiens frequency', $n*5, $homosapiens);
}

sub main
{
        my ($options) = @_;

        my $goal   = $ENV{PERLFORMANCE_SHOOTOUT_FASTA_N}     || ($ENV{PERLFORMANCE_TESTMODE_FAST} ? 5000 : 5_000_000);
        my $count  = $ENV{PERLFORMANCE_SHOOTOUT_FASTA_COUNT} || ($ENV{PERLFORMANCE_TESTMODE_FAST} ? 1 : 5);

        my $result;
        my $t = timeit $count, sub { $result = run($goal) };
        return {
                Benchmark     => $t,
                goal          => $goal,
                count         => $count,
                result        => $result,
               };
}

1;

__END__

=head1 NAME

Benchmark::Perl::Formance::Plugin::Shootout::fasta - Language shootout plugin: fasta

=head1 ABOUT

This plugin does some runs of the "fasta" benchmark from the Language
Shootout.

=head1 CONFIGURATION

Because the "fasta" plugin's output can be used to feed other
benchmarks you control its output via the environment variables:

   $ PERLFORMANCE_SHOOTOUT_FASTA_N=1000 \
     PERLFORMANCE_SHOOTOUT_FASTA_PRINT=1 \
     PERLFORMANCE_SHOOTOUT_FASTA_COUNT=1 \
     perl-formance [...]

where "_N" is the algorithm's parameter, "_PRINT" is a boolean 1 or 0
and _COUNT is the repetition counter which in benchmark runs is
usually 5 but only needed 1 for generating the output.

=cut
