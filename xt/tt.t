use strictures 1;
use Test::More;
use HTML::String::TT;

my $tt = HTML::String::TT->new;

sub do_tt {
    my $output;
    $tt->process(\$_[0], $_[1], \$output) or die $tt->error;
    return "$output";
}

is(
    do_tt('<tag>[% foo %]</tag>', { foo => 'Hi <bob>' }),
    '<tag>Hi &lt;bob&gt;</tag>',
);

is(
    do_tt(q{[%
        VIEW myview; BLOCK render; '<tag>'; foo; '</tag>'; END; END;
        myview.include('render');
    %]}, { foo => 'Hi <bob>' }),
    '<tag>Hi &lt;bob&gt;</tag>',
);

is(
    do_tt('<tag>[% foo | no_escape %]</tag>', { foo => 'Hi <bob>' }),
    '<tag>Hi <bob></tag>',
);

done_testing;
