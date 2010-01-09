package Adjective::ProxyFilter;
use base qw( HTTP::Proxy::HeaderFilter );

use strict;

sub init {
    my ($self, $ruleset) = @_;
    $self->{ruleset} = $ruleset;
}

sub filter {
    my ($self, $headers, $message) = @_;
    
    unless ( $self->{ruleset}->pass( $message->request ) ) {
        $message->content_type("text/plain");
        $message->content("blocked by Adjective");
        print $message->request->uri, " blocked\n";
    }
}

1;
