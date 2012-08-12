package HTML::String::TT;

use strictures 1;

BEGIN {
    if ($INC{"Template.pm"} and !$INC{"UNIVERSAL/ref.pm"}) {
        warn "Template was loaded before we could load UNIVERSAL::ref"
             ." - this means you're probably going to get weird errors."
             ." To avoid this, use HTML::String::TT before loading Template."
    }
    require UNIVERSAL::ref;
}

use HTML::String;
use HTML::String::TT::Directive;
use Safe::Isa;
use Template;
use Template::Parser;
use Template::Stash;

sub new {
    shift;
    Template->new(
        PARSER => Template::Parser->new(
            FACTORY => 'HTML::String::TT::Directive'
        ),
        STASH => Template::Stash->new,
        FILTERS => { no_escape => sub {
            $_[0]->$_isa('HTML::String::Value')
                ? HTML::String::Value->new(map $_->[0], @{$_[0]->{parts}})
                : HTML::String::Value->new($_)
        } },
        (ref($_[0]) eq 'HASH' ? %{$_[0]} : @_)
    );
}

1;
