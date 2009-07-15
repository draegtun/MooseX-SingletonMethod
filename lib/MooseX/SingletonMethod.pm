package MooseX::SingletonMethod;
use Moose::Role;

our $VERSION = '0.01';

my $singleton = sub {
    my $self    = shift;
    my $methods = shift || {};
    
    my $meta = $self->meta->create_anon_class(
        superclasses => [ $self->meta->name ],
        methods      => $methods,
    );
    
    $meta->add_method( meta => sub { $meta } );
    $meta->rebless_instance( $self );
};

sub become_singleton      { $_[0]->$singleton }

sub add_singleton_method  { $_[0]->$singleton({ $_[1] => $_[2] }) }

sub add_singleton_methods { 
    my $self = shift;
    $self->$singleton({ @_ });
}


no Moose::Role;
1;



__END__

=head1 NAME

MooseX::SingletonMethod - Role providing Singleton Method option

=head1 VERSION

Version 0.01


=head1 SYNOPSIS

Simple usage example....

    package Baz;
    use Moose;
    with 'MooseX::SingletonMethod';
    no Moose;
    
    package main;
    my $baz = Baz->new;
    my $foo = Baz->new;
    
    # add singleton method called "baz" just to $baz and not to Baz class
    $baz->add_singleton_method( baz => sub { 'baz!' } ); 
    
    say $baz->baz;   # => 'baz'
    say $foo->baz;   # ERROR: Can't locate object method "baz"....
    

=head1 DESCRIPTION

=head2 What is a "Singleton Method?"

TBD.


=head2 What is "MooseX::SingletonMethod"?

Using roles you can already create Singleton Methods with Moose:  

=over 4

=item L<http://transfixedbutnotdead.com/2009/06/03/using-moose-roles-to-create-singleton-methods/>

=item L<http://transfixedbutnotdead.com/2009/06/10/roles-singleton-methods-moosexdeclare/>

=item L<http://transfixedbutnotdead.com/2009/06/19/moose-fairy-dust/>

=item L<http://transfixedbutnotdead.com/2009/06/28/moose-fairy-dust-now-with-diagrams/>

=item L<http://transfixedbutnotdead.com/2009/07/07/moose-singleton-method-now-without-roles/>

=back


MooseX::SingletonMethod simple adds a nicety wrapper (role!) around this.

There are three methods available to create Singleton Methods using MooseX::SingletonMethod.  Here are some examples using L<MooseX::Declare>:

    use MooseX::Declare;  
  
    class FooBarBaz with MooseX::SingletonMethod {  
        method comes_with { "comes with FooBarBaz class" }  
    }  
  
    # one way to create singleton method....  
    my $foo = FooBarBaz->new;  
    $foo->become_singleton;                   # make $foo a singleton  
    $foo->meta->add_method( foo => 'foo!' );  # add method "foo" using meta  
  
    # and another.....  
    my $bar = FooBarBaz->new;  
    $bar->add_singleton_method( bar => sub { 'bar!' } );  
  
    # and finally multiple methods....  
    my $baz = FooBarBaz->new;  
    $baz->add_singleton_methods(  
        baz1 => sub { 'baz1!' },  
        baz2 => sub { 'baz2!' },  
    );
    
    # Methods each object now has:
    #
    # $foo  ->   [ comes_with, foo ]
    # $bar  ->   [ comes_with, bar ]
    # $baz  ->   [ comes_with, baz1, baz2 ]
 

=head2 Things to note

Each time add_singleton_method or add_singleton_methods is called it creates a new anonymous class which the object is blessed into.

If you want to add more methods to already bless anon class then simply use ->meta->add_method like in above $foo example.

=head1 EXPORT

None


=head1 METHODS

=head2 become_singleton

Makes the object a singleton (by creating an anonymous class which the object is blessed with):

    $baz->become_singleton;
    

=head2 add_singleton_method

Adds a singleton method to this object (same as above + creates prescribed method):

    $bar->add_singleton_method( bar => sub { 'bar!' } );  

=head2 add_singleton_methods

Same as above except allows multiple method declaration:

    $baz->add_singleton_methods(  
        baz1 => sub { 'baz1!' },  
        baz2 => sub { 'baz2!' },  
    );



=head1 AUTHOR

Barry Walsh, C<< <draegtun at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-moosex-singletonmethod at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MooseX-SingletonMethod>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc MooseX::SingletonMethod


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=MooseX-SingletonMethod>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/MooseX-SingletonMethod>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/MooseX-SingletonMethod>

=item * Search CPAN

L<http://search.cpan.org/dist/MooseX-SingletonMethod/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 DISCLAIMER

This is beta software.   I'll strive to make it better each and every day!

However I accept no liability I<whatsoever> should this software do what you expected ;-)



=head1 COPYRIGHT & LICENSE

Copyright 2009 Barry Walsh (Draegtun Systems Ltd), all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


