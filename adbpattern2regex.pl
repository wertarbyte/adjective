#!/usr/bin/perl

sub pattern2regex {
    my ($pattern) = @_;
    my $globstr = shift;
    my %patmap = (
        '*' => '.*',
        '[' => '[',
        ']' => ']',
        '^' => '(?:[^[:alnum:]|[-.%])'
    );
    my $re = $pattern;
    $re =~ s{(.)} { $patmap{$1} || "\Q$1" }ge;
    return $re;
}

sub read_filter {
    my ($filter) = @_;
    my ($exception, $start_domain, $start_url);
    my $options;
    while ($filter =~ s/^(@@|\|\||\|#+)//) {
        print "found $1\n";
    }
    if ($filter =~ s/\$(.*)$//) {
        $options = $1;
    }
    print $filter, " [", $options, "]\n";
}

while (<STDIN>) {
    chop;
    chop;
    next if /^!/;
    next if /^\[.*\]$/;
    read_filter($_);
}
