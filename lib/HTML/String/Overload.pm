package HTML::String::Overload;

use strictures 1;
use HTML::String;
use B::Hooks::EndOfScope;
use overload ();

sub import {
    overload::constant q => \&html;
    on_scope_end { __PACKAGE__->unimport };
}

sub unimport {
    overload::remove_constant('q');
}

1;
