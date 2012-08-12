package HTML::String::Value;

use strictures 1;
use UNIVERSAL::ref;
use Safe::Isa;
use Data::Munge;

use overload
    '""'   => 'escaped_string',
    '.'    => 'dot',
    'bool' => 'is_true',

    fallback => 1,
;

sub new {
    my ($class, @raw_parts) = @_;

    my $opts = (ref($raw_parts[-1]) eq 'HASH') ? pop(@raw_parts) : {};

    my @parts = map {
        if (ref($_) eq 'ARRAY') {
            $_
        } elsif ($_->$_isa(__PACKAGE__)) {
            @{$_->{parts}}
        } else {
            [ $_, 0 ]
        }
    } @raw_parts;

    my $self = bless { parts => \@parts, %$opts }, $class;

    return $self;
}

sub escaped_string {
    my $self = shift;

    if ($self->{ignore}{scalar caller}) {
        return $self->unescaped_string;
    }

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

    return ref($self)->new(@parts, { ignore => $self->{ignore} });
}

sub is_true {
    my ($self) = @_;
    return 1 if grep length($_), map $_->[0], @{$self->{parts}};
}

sub ref { '' }

1;
