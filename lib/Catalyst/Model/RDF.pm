
package Catalyst::Model::RDF;

use Moose;
extends 'Catalyst::Model';

use RDF::Trine::Model;

# ABSTRACT: RDF model class for Catalyst based on RDF::Trine::Model.
# VERSION

our $AUTOLOAD;

has format => (
    is => 'rw',
    isa => 'Str',
    lazy => 1,
    default => 'xml'
);

has _class => (
    is => 'ro',
    isa => 'Object',
    init_arg => undef,
    lazy => 1,
    default => sub { RDF::Trine::Model->temporary_model }
);

sub AUTOLOAD {
    my $self = shift;
    return if $AUTOLOAD =~ /::DESTROY$/;
    (my $command = $AUTOLOAD) =~ s/^.*:://;
    return $self->_class->$command(@_);
}

sub serializer {
    my $self = shift;

    my $serializer = RDF::Trine::Serializer::RDFXML->new();
    my $output = $serializer->serialize_model_to_string($self->_class);

    return $output;
}

1;

__END__

=head2 METHODS

The same as L<RDF::Trine::Model>.

