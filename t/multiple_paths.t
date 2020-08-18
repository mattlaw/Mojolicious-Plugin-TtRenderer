#!/usr/bin/env perl

use strict;
use warnings;
use 5.016;

BEGIN { $ENV{MOJO_MODE}='testing'; };

use utf8;

use Test::More tests => 6;

use Mojolicious::Lite;
use Test::Mojo;
use File::Temp qw( tempdir );
use File::Spec;

# Silence
app->log->level('fatal');

my @paths = map { File::Spec->catdir(app->home, $_) } "templates/multiple_first", "templates/multiple_second";
app->renderer->paths([@paths]);

plugin 'TtRenderer' => {template_options => { COMPILE_DIR => tempdir( CLEANUP => 1 ) }};

get '/first' => 'first';
get '/second' => 'second';

my $t = Test::Mojo->new;

$t->get_ok('/first')->status_is(200)->content_like(qr/First/);
$t->get_ok('/second')->status_is(200)->content_like(qr/Second/);

