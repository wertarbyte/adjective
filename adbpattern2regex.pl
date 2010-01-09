#!/usr/bin/perl
use strict;
use Data::Dumper;

sub pattern2regex {
    my ($pattern) = @_;
    my %patmap = (
        '*' => '.*',
        '[' => '[',
        ']' => ']',
        '^' => '(?:[^[:alnum:]|[-.%])',
        '||' => '(?:^|\.)'
    );
    my $re = $pattern;
    $re =~ s{(\|\||.)} { $patmap{$1} || "\Q$1" }ge;
    return $re;
}

sub parse_filter {
    my ($filter) = @_;
    my %rule = ();

    if ($filter =~ s/^@@//) {
        $rule{exception} = 1;
    }
    if ($filter =~ s/\$(.*)$//) {
        $rule{options} = $1;
    }
    
    $rule{url_regex} = pattern2regex($filter);

    return \%rule;
}

my @rules = ();
while (<STDIN>) {
    chop;
    chop;
    next if /^!/;
    next if /#/;
    next if /^\[.*\]$/;
    push @rules, parse_filter($_);
}

print Dumper(\@rules);
