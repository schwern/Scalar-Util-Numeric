#!/usr/bin/env perl

use strict;
use warnings;

use Config;
use Math::BigInt;
use Math::Complex;
use Test::More tests => 37;

use_ok('Scalar::Util::Numeric', qw(:all));

my $uvmax = Scalar::Util::Numeric::uvmax();

ok(defined($uvmax), 'uvmax is defined');

my $uvmax_plus_one = Math::BigInt->new($uvmax)->badd(1)->bstr();

ok(defined($uvmax_plus_one), 'uvmax + 1 is defined');

my $infinity = do {
    no warnings 'once';
    $Math::Complex::Inf;
};

ok(defined($infinity), 'infinity is defined');

# only debug the value if one or more of its tests fails
sub diag_if_fail($@) {
    my $diag = shift;
    my $fail = 0;

    for my $test (@_) {
        ++$fail unless ($test->());
    }

    if ($fail) {
        $diag = [ $diag ] unless (ref $diag);
        diag $_ for @$diag;
    }
}

is (isnum(0), 1, 'isnum(0) == 1');
is (isnum(1), 1, 'isnum(1) == 1');
is (isnum(-1), 9, 'isnum(-1) == 9');
is (isnum('0.00'), 5, "isnum('0.00') == 5");
is (isnum(undef), 0, "isnum(undef) == 0");
is (isnum('A'), 0, "isnum('A') == 0");
is (isnum('A0'), 0, "isnum('A0') == 0");
is (isnum('0A'), 0, "isnum('0A') == 0");
is (isnum(\&ok), 0, "isnum(\\&ok) == 0");

diag_if_fail "UV_MAX: '$uvmax'" =>
    sub { is (isuv($uvmax), 1, 'isuv($uvmax) == 1') },
    sub { is (isuv(-1), 1, "isuv(-1) == 1") };

diag_if_fail [ "UV_MAX: '$uvmax'", "UV_MAX + 1: '$uvmax_plus_one'" ] =>
    sub { is (isbig($uvmax), 0, "isbig(\$uvmax) == 0") },
    sub { is (isbig($uvmax_plus_one), 1, "isbig(\$uvmax + 1) == 1") };

is (isfloat(3.1415927), 1, "isfloat(3.1415927) == 1");
is (isfloat(-3.1415927), 1, "isfloat(-3.1415927) == 1");
is (isfloat(3), 0, "isfloat(3) == 0");
is (isfloat("1.0"), 1, "isfloat('1.0')");

is (isneg(-1), 1, "isneg(-1) == 1");
is (isneg(-3.1415927), 1, "isneg(-3.1415927) == 1");
is (isneg(1), 0, "isneg(1) == 0");
is (isneg(3.1415927), 0, "isneg(3.1415927) == 0");

diag_if_fail "INFINITY: '$infinity'" =>
    sub { is (isinf('Inf'), 1, "isinf('Inf') == 1") },
    sub { is (isinf(3.1415927), 0, "isinf(3.1415927) == 0") },
    sub { is (isinf($infinity), 1, 'isinf($Math::Complex::Inf) == 1') };

is (isint(-99), -1, "isint(-99) == -1");
is (isint(0), 1, "isint(0) == 1");
is (isint(3.1415927), 0, "isint(3.1415927) == 0");
is (isint(-3.1415927), 0, "isint(-3.1415927) == 0");
is (isint($uvmax), 1, 'isint($uvmax) == 1');
is (isint($infinity), 0, 'isint($Math::Complex::Inf) == 0');
is (isint("1.0"), 0, "isint('1.0')");

SKIP: {
    skip ('NaN is not supported by this platform', 2) unless($Config{d_isnan});
    is (isnan('NaN'), 1, "isnan('NaN') == 1");
    is (isnan(42), 0, "isnan(42) == 0");
}
