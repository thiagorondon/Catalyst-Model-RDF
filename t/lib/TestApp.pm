package # hide from PAUSE
    TestApp;

use strict;
use warnings;

use Catalyst;

__PACKAGE__->config(
    name        => 'TestApp',
    'Model::RDF' => {
        format     => 'rdfxml',
        store      => {
            storetype => 'DBI',
            name      => 'test',
            dsn       => 'dbi:SQLite:dbname=test.sqlite',
            # to shut up the warnings
            username  => '',
            password  => '',
        },
    },
);

__PACKAGE__->setup;


1;
