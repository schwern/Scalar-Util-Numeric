package Scalar::Util::Numeric;

use 5.006;

use strict;
use warnings;

require Exporter;
require DynaLoader;
use AutoLoader 'AUTOLOAD';

our @ISA = qw(Exporter DynaLoader);

our %EXPORT_TAGS = (
'all'	=> [ qw(isbig isfloat isinf isint isnan isneg isnum isuv) ],
);

our @EXPORT_OK = ( map { @$_ } values %EXPORT_TAGS );

our $VERSION = '0.01';

bootstrap Scalar::Util::Numeric $VERSION;

1;

__END__

=head1 NAME

Scalar::Util::Numeric - numeric tests for Perl datatypes

=head1 SYNOPSIS

    use Scalar:Util::Numeric qw(isnum isint isfloat);

    foo($bar / 2) if (isnum $bar);

    if (isint $baz) {
        # ...
    } elsif (isfloat $baz) {
        # ...
    }

=head1 DESCRIPTION

This module exports a number of wrappers around perl's builtin C<looks_like_number> function, which 
returns the numeric type of its argument, or 0 if it isn't numeric.

=head1 TAGS

All of the functions exported by Scalar::Util::Numeric can be imported by using the C<:all> tag:

	use Scalar::Util::Numeric qw(:all);

=head1 isnum

=head3 usage

    isnum ($val)

=head3 description

Returns a nonzero value (indicating the numeric type) if $val is a number.

The numeric type is a conjunction of the following flags:

    0x01  IS_NUMBER_IN_UV               (number within UV range - maybe not int)
    0x02  IS_NUMBER_GREATER_THAN_UV_MAX (the pointed-to UV is undefined)
    0x04  IS_NUMBER_NOT_INT             (saw . or E notation)
    0x08  IS_NUMBER_NEG                 (leading minus sign)
    0x10  IS_NUMBER_INFINITY            (this is big)
    0x20  IS_NUMBER_NAN                 (this is not)

The following flavours of C<isnum> (corresponding to the flags above) are also available:

    isint
    isuv
    isbig
    isfloat
    isneg
    isinf
    isnan

C<isint> returns -1 if its operand is a negative integer, 1 if
it's 0 or a positive integer, and 0 otherwise.

The others always return 1 or 0.

=cut

sub isnum ($) {
    return 0 unless defined (my $val = shift);
    # stringify - ironically, looks_like_number always returns 1 unless
    # arg is a string
    return is_num($val . '');
}

sub isint ($) {
    my $isnum = isnum(shift());
    return ($isnum == 1) ? 1 : ($isnum == 9) ? -1 : 0;
}

sub isuv ($) {
    return (isnum(shift()) & 1) ? 1 : 0;
}

sub isbig ($) {
    return (isnum(shift()) & 2) ? 1 : 0;
}

sub isfloat ($) {
    return (isnum(shift()) & 4) ? 1 : 0;
}

sub isneg ($) {
    return (isnum(shift()) & 8) ? 1 : 0;
}

sub isinf ($) {
    return (isnum(shift()) & 16) ? 1 : 0;
}

sub isnan ($) {
    return (isnum(shift()) & 32) ? 1 : 0;
}

=head1 SEE ALSO

L<Scalar::Util>

=head1 AUTHOR

chocolateboy: <chocolate.boy@email.com>

=head1 COPYRIGHT

Copyright (c) 2005, chocolateboy.

This module is free software. It may be used, redistributed
and/or modified under the same terms as Perl itself.

=cut
