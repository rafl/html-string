use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
  NAME => 'HTML-String',
  VERSION => '1.0',
  PREREQ_PM => {
    'Safe::Isa' => 1,
    'Data::Munge' => '0.04',
    'B::Hooks::EndOfScope' => '0.11',
    'strictures' => 1,
    'UNIVERSAL::ref' => 0.14,
  }
);
