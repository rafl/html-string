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

# Check we aren't nailed by https://rt.perl.org/rt3/Ticket/Display.html?id=49594

is(
    do_tt('<foo>"$bar"</foo>'."\n"),
    '<foo>"$bar"</foo>'."\n"
);

is(
    do_tt(
        '[% FOREACH item IN items %][% item %][% END %]',
        { items => [ '<script>alert("lalala")</script>', '-> & so "on" <-' ] }
    ),
    '&lt;script&gt;alert(&quot;lalala&quot;)&lt;/script&gt;'          
        .'-&gt; &amp; so &quot;on&quot; &lt;-'
);

done_testing;
