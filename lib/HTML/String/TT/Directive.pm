package HTML::String::TT::Directive;

use strictures 1;
use HTML::String::Overload ();
use Data::Munge;
use base qw(Template::Directive);

sub template {
    return byval {
        s/sub {/sub { use HTML::String::Overload;/;
    } Template::Directive::pad(shift->SUPER::template(@_), 2);
}

1;
