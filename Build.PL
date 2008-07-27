use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'App::ZofCMS::Test::Plugin',
    license             => 'perl',
    dist_author         => 'Zoffix Znet <zoffix@cpan.org>',
    dist_version_from   => 'lib/App/ZofCMS/Test/Plugin.pm',
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'Test::Builder'         => 0.80,
        'Test::Builder::Module' => 0.80,
    },
    add_to_cleanup      => [ 'App-ZofCMS-Test-Plugin-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
