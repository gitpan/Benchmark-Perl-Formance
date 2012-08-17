
use strict;
use warnings;

use 5.010;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "PerlFormance - Benchmark Suite",
  "AUTHOR" => "Steffen Schwigon <ss5\@renormalist.net>",
  "BUILD_REQUIRES" => {
    "Data::YAML::Reader" => 0,
    "Test::More" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Benchmark-Perl-Formance",
  "EXE_FILES" => [
    "bin/benchmark-perlformance"
  ],
  "LICENSE" => "perl",
  "NAME" => "Benchmark::Perl::Formance",
  "PREREQ_PM" => {
    "Benchmark" => 0,
    "Benchmark::Perl::Formance::Cargo" => "0.05",
    "Clone" => 0,
    "Config" => 0,
    "Cwd" => 0,
    "Data::DPath" => "0.47",
    "Data::Dumper" => 0,
    "Data::Structure::Util" => 0,
    "Data::YAML::Writer" => 0,
    "Devel::Platform::Info" => 0,
    "Devel::Size" => "0.78",
    "Exporter" => 0,
    "File::Copy::Recursive" => 0,
    "File::Find" => 0,
    "File::ShareDir" => 0,
    "File::Temp" => 0,
    "Getopt::Long" => 0,
    "IO::Handle" => 0,
    "IO::Select" => 0,
    "List::Util" => 0,
    "Math::GMP" => 0,
    "Math::MatrixReal" => 0,
    "Moose" => 0,
    "MooseX::Declare" => 0,
    "Mouse" => 0,
    "Storable" => 0,
    "Sys::Hostname" => 0,
    "Test::More" => "0.90",
    "Time::HiRes" => 0,
    "constant" => 0,
    "integer" => 0,
    "strict" => 0,
    "threads" => 0,
    "threads::shared" => 0,
    "vars" => 0,
    "warnings" => 0
  },
  "VERSION" => "0.29",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



