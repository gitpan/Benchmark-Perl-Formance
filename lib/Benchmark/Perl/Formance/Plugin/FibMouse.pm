package Benchmark::Perl::Formance::Plugin::FibMouse;

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

__END__

=head1 NAME

Benchmark::Perl::Formance::Plugin::FibMouse - Stress recursion and method calls (Mouse)

=cut

