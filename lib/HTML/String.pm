package HTML::String;

use strictures 1;
use HTML::String::Value;
use Exporter 'import';

our @EXPORT = qw(html);

sub html {
  HTML::String::Value->new($_[0]);
}

1;
