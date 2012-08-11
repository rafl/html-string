package HTML::String::TT;

use strictures 1;

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
