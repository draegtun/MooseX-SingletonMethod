#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'MooseX::SingletonMethod' );
}

diag( "Testing MooseX::SingletonMethod $MooseX::SingletonMethod::VERSION, Perl $], $^X" );
