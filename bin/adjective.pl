#!/usr/bin/perl

use strict;
use Adjective::Ruleset;
use HTTP::Proxy;
use Adjective::ProxyFilter;

my $ruleset = Adjective::Ruleset->from_file($ARGV[0]);
my $filter = new Adjective::ProxyFilter($ruleset);

my $proxy = HTTP::Proxy->new( port => 3180 );

$proxy->push_filter( response => $filter );

$proxy->start;
