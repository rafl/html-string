package HTML::String::TT::Directive;

use strictures 1;
use HTML::String::Overload ();
use base qw(Template::Directive);

sub template {
    my $result = Template::Directive::pad(shift->SUPER::template(@_), 2);
    $result =~ s/sub {/sub { use HTML::String::Overload;/;
    $result;
}

1;
