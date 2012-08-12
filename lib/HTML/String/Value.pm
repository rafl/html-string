package HTML::String::Value;

use strictures 1;
use UNIVERSAL::ref;
use Safe::Isa;
use Data::Munge;

use overload
    '""'   => 'escaped_string',
    '.'    => 'dot',

    fallback => 1,
;

sub new {
    my ($class, @raw_parts) = @_;

    my @parts = map {
        if (ref($_) eq 'ARRAY') {
            $_
        } elsif ($_->$_isa(__PACKAGE__)) {
            @{$_->{parts}}
        } else {
            [ $_, 0 ]
        }
    } @raw_parts;

    my $self = bless { parts => \@parts }, $class;

    return $self;
}

sub escaped_string {
    my $self = shift;

    return join '', map +(
        $_->[1]
            ? byval { 
                s/&/&amp;/g;
                s/</&lt;/g;
                s/>/&gt;/g;
                s/"/&quot;/g;
              } $_->[0]
            : $_->[0]
    ), @{$self->{parts}};
}

sub unescaped_string {
    my $self = shift;

    return join '', map $_->[0], @{$self->{parts}};
}

sub dot {
    my ($self, $str, $prefix) = @_;

    return $self unless $str;

    my @parts = @{$self->{parts}};

    my @new_parts = (
        $str->$_isa(__PACKAGE__)
            ? @{$str->{parts}}
            : [ $str, 1 ]
    );

    if ( $prefix ) {
        unshift @parts, @new_parts;
    } else {
        push @parts, @new_parts;
    }

    return ref($self)->new(@parts);
}

sub ref { '' }

1;
