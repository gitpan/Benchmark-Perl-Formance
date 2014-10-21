package Benchmark::Perl::Formance::Plugin::FibMouse;
BEGIN {
  $Benchmark::Perl::Formance::Plugin::FibMouse::AUTHORITY = 'cpan:SCHWIGON';
}

# Fibonacci numbers

use strict;
use warnings;

our $VERSION = "0.002";

#############################################################
#                                                           #
# Benchmark Code ahead - Don't touch without strong reason! #
#                                                           #
#############################################################

our $goal;
our $count;

use Benchmark ':hireswallclock';

use Mouse;

sub fib
{
        my $self = shift;
        my $n    = shift;

        $n < 2
         ? 1
          : $self->fib($n-1) + $self->fib($n-2);
}

sub main
{
        my ($options) = @_;

        # ensure same values over all Fib* plugins!
        $goal  = $options->{fastmode} ? 20 : 35;
        $count = 5;

        my $result;
        my $fib = __PACKAGE__->new;
        my $t   = timeit $count, sub { $result = $fib->fib($goal) };
        return {
                Benchmark => $t,
                result    => $result,
                goal      => $goal,
               };
}

1;



=pod

=encoding utf-8

=head1 NAME

Benchmark::Perl::Formance::Plugin::FibMouse

=head1 NAME

Benchmark::Perl::Formance::Plugin::FibMouse - Stress recursion and method calls (Mouse)

=head1 AUTHOR

Steffen Schwigon <ss5@renormalist.net>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Steffen Schwigon.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__


