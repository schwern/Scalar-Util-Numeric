use 5.006;
use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

WriteMakefile(
    'NAME'            =>    'Scalar::Util::Numeric',
    'VERSION_FROM'    =>    'lib/Scalar/Util/Numeric.pm',     # finds $VERSION
    'INSTALLDIRS'     =>    'site',
    'PREREQ_PM'       =>    { # e.g. Module::Name => 1.1
        'Math::Complex'	=> 0,
        'Test::More'	=> 0,
    },         
    'LIBS'            =>    [''],         # e.g. '-lm'
    # 'OPTIMIZE'      =>    '-g',
    # 'OPTIMIZE'      =>    '-pg',
    'OPTIMIZE'        =>    '-O3',
    'INC'             =>    ''         # e.g. '-I/usr/include/other'
);
