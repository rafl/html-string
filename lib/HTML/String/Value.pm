package HTML::String::Value;

use strictures 1;
use Safe::Isa;
use Data::Munge;

sub op_factory {
    my ($op) = @_;

    return eval q|sub {
        my ($self, $str) = @_;

        if ( $str->$_isa(__PACKAGE__) ) {
            return $self->unescaped_string | . $op . q| $str->unescaped_string;
        }
        else {
            return $self->unescaped_string | . $op . q| $str;
        }
    }|;
}

use overload
    '""'   => 'escaped_string',
    '.'    => 'dot',
    '.='   => 'dot_equals',
    '='    => 'clone',

    'cmp' => op_factory('cmp'),
    'eq'  => op_factory('eq'),
    '<=>' => op_factory('<=>'),
    '=='  => op_factory('=='),
    '%'   => op_factory('%'),
    '+'   => op_factory('+'),
    '-'   => op_factory('-'),
    '*'   => op_factory('*'),
    '/'   => op_factory('/'),
    '**'  => op_factory('**'),
    '>>'  => op_factory('>>'),
    '<<'  => op_factory('<<'),

    fallback => 1,
;

sub new {
    my ($class, @raw_parts) = @_;

    my @parts = map { ref($_) eq 'ARRAY' ? $_ : [$_] } @raw_parts;

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

sub dot_equals {
    my ($self, $str, $prefix) = @_;

    return $self unless $str;

    my @new_parts = (
        $str->$_isa(__PACKAGE__)
            ? @{$str->{parts}}
            : [ $str, 1 ]
    );

    push @{$self->{parts}}, @new_parts;

    return $self;
}

sub clone {
    my $self = shift;

    return ref($self)->new(@{$self->{parts}});
}

1;
