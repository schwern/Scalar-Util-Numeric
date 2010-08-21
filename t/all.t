#!/usr/bin/env perl

use strict;
use warnings;

use Config;
use Test::More tests => 34;

use_ok('Scalar::Util::Numeric', qw(:all));

my $uvmax = Scalar::Util::Numeric::uvmax();

my $uvmax_plus_one = do {
    require Math::BigInt;
    Math::BigInt->new($uvmax)->badd(1)->bstr();
};

my $inf = do {
    require Math::Complex;
    my $inf = do {
        no warnings 'once';
        $Math::Complex::Inf;
    };
    diag("Infinity: <<$inf>>");
    $inf;
};

is (isnum(0), 1, 'isnum(0) == 1');
is (isnum(1), 1, 'isnum(1) == 1');
is (isnum(-1), 9, 'isnum(-1) == 9');
is (isnum('0.00'), 5, "isnum('0.00') == 5");
is (isnum(undef), 0, "isnum(undef) == 0");
is (isnum('A'), 0, "isnum('A') == 0");
is (isnum('A0'), 0, "isnum('A0') == 0");
is (isnum('0A'), 0, "isnum('0A') == 0");
is (isnum(\&ok), 0, "isnum(\\&ok) == 0");

is (isuv($uvmax), 1, 'isuv($uvmax) == 1') or diag "UVMAX: $uvmax";
is (isuv(-1), 1, "isuv(-1) == 1");

is (isbig($uvmax), 0, "isbig(\$uvmax) == 0");
SKIP: {
    skip "Need Math::BigInt with bstr() to test numbers bigger than UV", 1 unless $uvmax_plus_one;
    is (isbig($uvmax_plus_one), 1, "isbig(\$uvmax + 1) == 1");
}

is (isfloat(3.1415927), 1, "isfloat(3.1415927) == 1");
is (isfloat(-3.1415927), 1, "isfloat(-3.1415927) == 1");
is (isfloat(3), 0, "isfloat(3) == 0");
is (isfloat("1.0"), 1, "isfloat('1.0')");

is (isneg(-1), 1, "isneg(-1) == 1");
is (isneg(-3.1415927), 1, "isneg(-3.1415927) == 1");
is (isneg(1), 0, "isneg(1) == 0");
is (isneg(3.1415927), 0, "isneg(3.1415927) == 0");

is (isinf('Inf'), 1, "isinf('Inf') == 1");
is (isinf(3.1415927), 0, "isinf(3.1415927) == 0");
SKIP: {
    skip "Need Math::Complex to test $Math::Complex::Inf", 1 unless $inf;
    is (isinf($inf), 1, 'isinf($Math::Complex::Inf) == 1');
}

is (isint(-99), -1, "isint(-99) == -1");
is (isint(0), 1, "isint(0) == 1");
is (isint(3.1415927), 0, "isint(3.1415927) == 0");
is (isint(-3.1415927), 0, "isint(-3.1415927) == 0");
is (isint($uvmax), 1, 'isint($uvmax) == 1');
is (isint($inf), 0, 'isint($Math::Complex::Inf) == 0');
is (isint("1.0"), 0, "isint('1.0')");

SKIP: {
    skip ('NaN is not supported by this platform', 2) unless($Config{d_isnan});
    is (isnan('NaN'), 1, "isnan('NaN') == 1");
    is (isnan(42), 0, "isnan(42) == 0");
}
