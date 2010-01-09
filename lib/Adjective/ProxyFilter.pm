package Adjective::ProxyFilter;
use base qw( HTTP::Proxy::HeaderFilter );

use strict;
require HTTP::Response;

sub init {
    my ($self, $ruleset) = @_;
    $self->{ruleset} = $ruleset;
}

sub filter {
    my ($self, $headers, $request) = @_;
    
    unless ( $self->{ruleset}->pass( $request ) ) {
        print $request->uri, " blocked\n";

        my $response = HTTP::Response->new(200);
        $response->content("blocked by Adjective");
        $response->content_type("text/plain");
        $self->proxy->response($response);
    }
}

1;
