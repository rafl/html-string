package HTML::String::TT;

use strictures 1;
use Template;
use Template::Parser;
use Template::Stash;
use HTML::String::TT::Directive;

sub new {
    shift;
    Template->new(
        PARSER => Template::Parser->new(
            FACTORY => 'HTML::String::TT::Directive'
        ),
        STASH => Template::Stash->new,
        @_
    );
}

1;
