package HTML::String::Overload;

use strictures 1;
use HTML::String::Value;
use B::Hooks::EndOfScope;
use overload ();

sub import {
    my ($class, @opts) = @_;
    overload::constant q => sub {
        HTML::String::Value->new($_[1], @opts);
    };
    on_scope_end { __PACKAGE__->unimport };
}

sub unimport {
    overload::remove_constant('q');
}

1;
