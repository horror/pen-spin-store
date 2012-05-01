#! C:\strawberry\perl\bin\perl.exe -w

use Text::Markdown qw(markdown);
use CGI 3.47 qw(param header);
use strict;

print header(-type => "text/plain", -charset => "utf-8");
print markdown(param('data'));

