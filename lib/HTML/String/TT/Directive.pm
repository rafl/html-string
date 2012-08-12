package HTML::String::TT::Directive;

use strictures 1;
use HTML::String::Overload ();
use Data::Munge;
use base qw(Template::Directive);

sub template {
    return byval {
        s/sub {/sub { package HTML::String::TT::_TMPL; use HTML::String::Overload { ignore => { q{Template::Provider} => 1, q{Template::Directive} => 1, q{Template::Document} => 1, q{Template::Plugins} => 1 } };/;
    } Template::Directive::pad(shift->SUPER::template(@_), 2);
}

# TT code does &text(), no idea why

sub textblock {
    my ($self, $text) = @_;
    return $Template::Directive::OUTPUT.' '.$self->text($text).';';
}

# https://rt.perl.org/rt3/Ticket/Display.html?id=49594

sub text {
    my ($class, $text) = @_;
    for ($text) {
        s/(["\$\@\\])/"."\\$1"."/g;
        s/\n/"."\\n"."/g;
    }
    return '"' . $text . '"';
}

1;
