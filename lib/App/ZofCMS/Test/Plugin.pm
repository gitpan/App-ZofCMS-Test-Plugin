package App::ZofCMS::Test::Plugin;

use warnings;
use strict;

our $VERSION = '0.0103';

use base 'Test::Builder::Module';

my $Test = Test::Builder->new;

sub import {
    my $self = shift;
    my $caller = caller;
    no strict 'refs';
    *{$caller.'::plugin_ok'}   = \&plugin_ok;

    $Test->exported_to($caller);
    $Test->plan( tests => 3);
}

sub plugin_ok {
    my ( $plugin_name, $template_with_input, $query ) = @_;

    $template_with_input ||= {};
    $query ||= {};

    eval "use App::ZofCMS::Plugin::$plugin_name";
    if ( $@ ) {
        $Test->ok(1);
        $Test->ok(1);
        $Test->ok(1);
        $Test->diag("Failed to use App::ZofCMS::Plugin::$plugin_name");
        exit 0;
    }
    my $o = "App::ZofCMS::Plugin::$plugin_name"->new;
    $Test->ok( $o->can('new'), "new() method is available");
    $Test->ok( $o->can('process'), "process() method is available");

    SKIP: {
        eval "use App::ZofCMS::Config";
        if ( $@ ) {
            $Test->ok (1);
            $Test->diag ("App::ZofCMS::Config is required for process() testing");
            last;
        }

        my $config = App::ZofCMS::Config->new;

        $o->process( $template_with_input, $query, $config );

        delete @$template_with_input{ qw/t d conf plugins/ };
        $Test->ok( 0 == keys %$template_with_input,
            "Template must be empty after deleting {t}, {d}, {conf}"
            . " and {plugins} keys"
        );

        $Test->diag(
            "Query ended up as: \n" . join "\n", map 
                "[$_] => [$query->{$_}]", keys %$query
        );
    }
}

1;
__END__

=head1 NAME

App::ZofCMS::Test::Plugin - test module for testing ZofCMS plugins

=head1 SYNOPSIS

    #!/usr/bin/env perl

    use strict;
    use warnings;

    use Test::More;

    eval "use App::ZofCMS::Test::Plugin;";
    plan skip_all
    => "App::ZofCMS::Test::Plugin required for testing plugin"
        if $@;

    plugin_ok(
        'PlugName',  # plugin's name
        { input => 'Foo' }, # plugin takes input via first level 'input' key
        { foo => 'bar'   }, # query parameters
    );

=head1 DESCRIPTION

The module provides some basic test for ZofCMS plugins. See SYNOPSYS
for usage. That would be in one of your t/test.t files.

=head2 plugin_ok

    plugin_ok(
        'PlugName',  # plugin's name
        { input => 'Foo' }, # plugin takes input via first level 'input' key
        { foo => 'bar'   }, # query parameters
    );

Takes three arguments, second and third one are optional.
First argument is the name
of your plugin with the C<App::ZofCMS::Plugin::> part stripped off (i.e.
the name that you would use in ZofCMS template to include the plugin).
Second parameter is optional, it must be a hashref which would represent
the input from your plugin. In the example above the plugin takes input
via first level key C<input> in ZofCMS template. This is basically to
check that any first level keys used by the plugin are deleted by the
plugin. Third parameter is optional and is also a hashref which represents
query parameters with keys being parameters names and values being
parameters' values. Use this if your plugin depends on some query
parameters.

=head1 AUTHOR

Zoffix Znet, C<< <zoffix at cpan.org> >>
(L<http://zoffix.com>, L<http://haslayout.net>)

=head1 BUGS

Please report any bugs or feature requests to C<bug-app-zofcms-test-plugin at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=App-ZofCMS-Test-Plugin>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc App::ZofCMS::Test::Plugin

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=App-ZofCMS-Test-Plugin>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/App-ZofCMS-Test-Plugin>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/App-ZofCMS-Test-Plugin>

=item * Search CPAN

L<http://search.cpan.org/dist/App-ZofCMS-Test-Plugin>

=back

=head1 COPYRIGHT & LICENSE

Copyright 2008 Zoffix Znet, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

