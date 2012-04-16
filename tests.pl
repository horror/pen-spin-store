#! C:\strawberry\perl\bin\perl.exe -w
use File::Basename;
use lib (dirname(__FILE__)); #Корень сайта.
use folder_config;
use lib (FRAMEWORK_CLASSES_PATH, APP_CONFIG_PATH,
         APP_MODELS_PATH, APP_CLASSES_PATH, APP_JSON_PATH,
	 APP_TESTS_PATH, APP_I10N_PATH);
use DBI;
use CGI qw(header);
use config_test;
use strict;

opendir (DIR, APP_TESTS_PATH) or die $!;

my $dbh = DBI->connect('DBI:' . DB_TYPE. ':' . DB_NAME,
                                DB_USER,
                                DB_PASSWORD
            )
    || die "Could not connect to database: $DBI::errstr";
$dbh->do("SET NAMES 'utf8'");
$dbh->{'mysql_enable_utf8'} = 1;
	
print header(-type => "text/plain", -charset => "utf-8");
while (my $test = readdir(DIR)) {
    next if ($test =~ m/^\./);
    require $test;
    $test =~ s/\.pm//;
    $test->new($dbh)->run();
}
