package HTML::String::Value;

use strictures 1;
use UNIVERSAL::ref;
use Safe::Isa;
use Data::Munge;

use overload
    '""'   => '_hsv_escaped_string',
    '.'    => '_hsv_dot',
    'bool' => '_hsv_is_true',

    fallback => 1,
;

sub new {
    if (ref($_[0])) { my $c = shift; return $c->_hsv_unescaped_string->new(@_) }
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

sub AUTOLOAD {
    my $invocant = shift;
    (my $meth = our $AUTOLOAD) =~ s/.*:://;
    die "No such method ${meth} on ${invocant}"
        unless ref($invocant);
    return $invocant->_hsv_unescaped_string->$meth(@_);
}

sub _hsv_escaped_string {
    my $self = shift;

    if ($self->{ignore}{scalar caller}) {
        return $self->_hsv_unescaped_string;
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

sub _hsv_unescaped_string {
    my $self = shift;

    return join '', map $_->[0], @{$self->{parts}};
}

sub _hsv_dot {
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

sub _hsv_is_true {
    my ($self) = @_;
    return 1 if grep length($_), map $_->[0], @{$self->{parts}};
}

sub ref { '' }

sub DESTROY { }

1;
