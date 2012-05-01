#! C:\strawberry\perl\bin\perl.exe -w

use Text::Markdown;
use CGI 3.47;
use strict;

my $q = CGI->new;
my $text = $q->param('data');
my $m = Text::Markdown->new;
my $html = $m->markdown($text);

print $q->header(-type => "text/plain", -charset => "utf-8");
print $html;