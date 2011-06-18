package # hide from PAUSE
    TestApp;

use strict;
use warnings;

use Catalyst;

__PACKAGE__->config(
    name        => 'TestApp',
    'Model::RDF' => {
        format     => 'rdfxml',
    },
);

__PACKAGE__->setup;


1;
