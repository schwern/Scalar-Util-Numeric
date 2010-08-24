#!/usr/bin/env perl

use Modern::Perl;
use Devel::Tokenizer::C;

our %MAP = (
    '1.#IND'  => 'IS_NUMBER_NAN | IS_NUMBER_NOT_INT',
    '-1.#IND' => 'IS_NUMBER_NEG | IS_NUMBER_NAN | IS_NUMBER_NOT_INT',
    '1.#INF'  => 'IS_NUMBER_INFINITY | IS_NUMBER_NOT_INT',
    '-1.#INF' => 'IS_NUMBER_NEG | IS_NUMBER_INFINITY | IS_NUMBER_NOT_INT',
);

my $generator = Devel::Tokenizer::C->new(
    CaseSensitive => 1,
    Comments      => 1,
    Indent        => '    ',
    MergeSwitches => 1,
    Strategy      => 'wide',
    StringLength  => 'len',
    TokenEnd      => undef,
    TokenFunc     => sub { "return $MAP{$_[0]};$/" },
    TokenString   => 'str',
    UnknownLabel  => 'not_nan_or_inf',
);

$generator->add_tokens('1.#IND', '-1.#IND', '1.#INF', '-1.#INF');

print $generator->generate();
