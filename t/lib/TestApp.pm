package # hide from PAUSE
    TestApp;

use strict;
use warnings;

use Catalyst;

__PACKAGE__->config(
    name        => 'TestApp',
    'Model::RDF' => {
        format     => 'xml',
    },
);

__PACKAGE__->setup;


1;
