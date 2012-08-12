use strictures 1;
use Test::More;
use HTML::String;

my $hi = 'Hi <bob>';

my $one = html('<tag>').$hi.html('</tag>');

is("$one", '<tag>Hi &lt;bob&gt;</tag>');

my $two = do {
  use HTML::String::Overload;

  "<tag>${hi}</tag>";
};

is("$two", '<tag>Hi &lt;bob&gt;</tag>');

my $three = html('<tag>');

$three .= $hi;

$three .= html('</tag>');

is("$three", '<tag>Hi &lt;bob&gt;</tag>');

my $four; {
  use HTML::String::Overload { ignore => { non_existant_package_name => 1 } };

  #$four = "<tag>".$hi."</tag>\n";
  $four = "<tag>$hi</tag>"."\n";
};

chomp($four);

is("$four", '<tag>Hi &lt;bob&gt;</tag>');

{
    package MyPkg;

    sub new { 'foo' }

    sub load { 'bar' }
}

is(html('MyPkg')->new, 'foo');

is(html('MyPkg')->load, 'bar');

done_testing;
