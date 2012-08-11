use strictures 1;
use Test::More;
use HTML::String;

my $hi = 'Hi <bob>';

my $one = html('<tag>').$hi.html('</tag>');

is("$one", '<tag>Hi &lt;bob&gt;</tag>');

my $two = do {
  use HTML::String::Overload;

  "<tag>${hi}</tag>"
};

is("$two", '<tag>Hi &lt;bob&gt;</tag>');

done_testing;
