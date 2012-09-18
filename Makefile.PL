
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "PerlFormance - Benchmark Suite",
  "AUTHOR" => "Steffen Schwigon <ss5\@renormalist.net>",
  "BUILD_REQUIRES" => {
    "Data::YAML::Reader" => 0,
    "Test::More" => "0.88"
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
    "Data::DPath" => 0,
    "Data::Structure::Util" => 0,
    "Data::YAML::Writer" => 0,
    "Devel::Platform::Info" => 0,
    "List::Util" => 0,
    "Sys::Hostname" => 0
  },
  "VERSION" => "0.32",
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



