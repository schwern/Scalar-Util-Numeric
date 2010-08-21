use 5.008000;

use strict;
use warnings;

use Config;
use ExtUtils::MakeMaker;

our $OPTIMIZE;

if ($Config{gccversion}) {
    $OPTIMIZE = '-O3 -Wall -W';
    $OPTIMIZE .= ' -g -Wextra -Wdeclaration-after-statement' if (-d 'dev');
} elsif ($Config{osname} eq 'MSWin32') {
    $OPTIMIZE = '-O2 -W4';
} else {
    $OPTIMIZE = $Config{optimize};
}

WriteMakefile(
    NAME             => 'Scalar::Util::Numeric',
    VERSION_FROM     => 'lib/Scalar/Util/Numeric.pm',
    PREREQ_PM        => {
        'Test::More' => 0,
    },
    ABSTRACT_FROM => 'lib/Scalar/Util/Numeric.pm',
    AUTHOR        => 'chocolateboy <chocolate@cpan.org>, Michael G Schwern <schwern@pobox.com>',
    LIBS          => [ '' ],
    DEFINE        => '',
    INC           => '-I.',
    OPTIMIZE      => $OPTIMIZE,
    ($ExtUtils::MakeMaker::VERSION >= 6.31 ? (LICENSE => 'perl') : ()),
    ($ExtUtils::MakeMaker::VERSION >= 6.46 ?
        (META_MERGE => {
            resources => {
                repository => 'http://github.com/schwern/Scalar-Util-Numeric',
            },
        })
        : ()
    ),

);
