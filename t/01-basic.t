#!perl -T

use Test::More tests => 10;


{
    package A;
    use Moose;
    with 'MooseX::SingletonMethod';
    sub a { 'a' };
}

my $a1 = A->new;
my $a2 = A->new;
$a1->add_singleton_method( b => sub { 'b' } );
my $a3 = A->new;

ok $a1->can('a');
is $a1->a, 'a';
ok $a1->can('b');
is $a1->b, 'b';

ok $a2->can('a');
is $a2->a, 'a';
ok !$a2->can('b');

ok $a2->can('a');
is $a2->a, 'a';
ok !$a2->can('b');