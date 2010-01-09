#!/usr/bin/perl

use strict;

package Adjective::Ruleset;
require IO::File;

sub __pattern2regex {
    my ($pattern) = @_;
    my %patmap = (
        '*' => '.*',
        '[' => '[',
        ']' => ']',
        '^' => '(?:[^[:alnum:]|[.%-])',
        '||' => '(?:^|\.)'
    );
    my $re = $pattern;
    $re =~ s{(\|\||.)} { $patmap{$1} || "\Q$1" }ge;
    return $re;
}

sub __parse_rule {
    my ($filter) = @_;
    my %rule = ();

    if ($filter =~ s/^@@//) {
        $rule{exception} = 1;
    }
    if ($filter =~ s/\$(.*)$//) {
        $rule{options} = $1;
    }
    
    $rule{url_regex} = __pattern2regex($filter);

    return \%rule;
}

sub from_file {
    my ($proto, $filename) = @_;
    my $class = ref($proto) || $proto;
    my $self = bless {}, $proto;
    $self->{rules} = [];
    
    my $fh = new IO::File $filename, "r";
    if (defined $fh) {
        while (<$fh>) {
            chop;
            chop;
            next if /^!/;
            next if /#/;
            next if /^\[.*\]$/;
            push @{$self->{rules}}, __parse_rule($_);
        }
        $fh->close();
    } else {
        die "Unable to open file $filename!";
    }
    return $self;
}

sub __apply_rule {
    my ($rule, $request) = @_;
    return $request->uri =~ $rule->{url_regex};
}

sub pass {
    my ($self, $request) = @_;
    
    # first try to apply exceptions
    for my $ex (grep {$_->{exception}} @{$self->{rules}}) {
        return 1 if __apply_rule( $ex, $request);
    }
    for my $ex (grep {! $_->{exception}} @{$self->{rules}}) {
        return 0 if __apply_rule( $ex, $request);
    }
    return 1;
}

1;
