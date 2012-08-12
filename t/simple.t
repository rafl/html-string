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
  use HTML::String::Overload { ignore => { lies => 1 } };

  #$four = "<tag>".$hi."</tag>\n";
  $four = "<tag>$hi</tag>"."\n";
};

chomp($four);

is("$four", '<tag>Hi &lt;bob&gt;</tag>');

done_testing;
