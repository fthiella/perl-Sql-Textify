#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Sql::Textify' ) || print "Bail out!\n";
}

diag( "Testing Sql::Textify $Sql::Textify::VERSION, Perl $], $^X" );
