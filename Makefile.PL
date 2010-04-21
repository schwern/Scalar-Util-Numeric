use 5.006;
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'            =>    'Scalar::Util::Numeric',
    'VERSION_FROM'    =>    'lib/Scalar/Util/Numeric.pm',     # finds $VERSION
    'PREREQ_PM'       =>    {
        'Test::More'	=> 0,
    },         
    'LIBS'            =>    [''],         # e.g. '-lm'
    # 'OPTIMIZE'      =>    '-g',
    # 'OPTIMIZE'      =>    '-pg',
    'OPTIMIZE'        =>    '-O3',
    'INC'             =>    ''         # e.g. '-I/usr/include/other'
);
