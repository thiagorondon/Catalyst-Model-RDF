
package Catalyst::Model::RDF;

use Moose;
extends 'Catalyst::Model';

use Moose::Util::TypeConstraints;
use RDF::Trine::Model;

# ABSTRACT: RDF model class for Catalyst based on RDF::Trine::Model.
# VERSION

=head1 SYNOPSIS

    # on the shell
    $ myapp_create.pl model RDF

    # in myapp.conf
    <Model::RDF>
        # see documentation for RDF::Trine::Store, this structure
        # gets passed verbatim to `new_with_config'.
        <store>
        storetype DBI
        name      myapp
        dsn       dbi:Pg:dbname=rdf
        user      rdfuser
        password  suparsekrit
        </store>
    </Model::RDF>

=head1 ATTRIBUTES

Format can be: OwnIFn, NTriples, NQuads, Turtle, RDFXML, Notation3 or RDFJSON.

=head2

=cut

# don't need this at the moment
# sub BUILD {
#     my ($self, $args) = @_;
#     require Data::Dumper;
#     warn Data::Dumper::Dumper($args);
# }

subtype 'SerializerFormat', as 'Str',
    where { grep { lc $_ } RDF::Trine::Serializer->serializer_names };

has format => (
    is      => 'rw',
    isa     => 'SerializerFormat',
    lazy    => 1,
    default => 'rdfxml',
);

class_type TrineStore => { class => 'RDF::Trine::Store' };
coerce 'TrineStore', from 'HashRef',
    via { RDF::Trine::Store->new_with_config(shift) };

has store => (
    is     => 'ro',
    isa    => 'TrineStore',
    coerce => 1,
);

has _class => (
    is      => 'ro',
    isa     => 'RDF::Trine::Model',
    lazy    => 1, # hack to ensure store is created first
    default => sub {
        my $self = shift;
        return $self->store ? RDF::Trine::Model->new($self->store) :
            RDF::Trine::Model->temporary_model;
    },
    handles => qr/.*/
);

sub serializer {
    my $self = shift;

    my $serializer = RDF::Trine::Serializer->new($self->format);

    my $output = $serializer->serialize_model_to_string($self->_class);

    return $output;
}

1;

__END__

=head1 METHODS

The same as L<RDF::Trine::Model>.

=head2 serializer

Serializes the $model to RDF/$format, returning the result as a string.

=cut

