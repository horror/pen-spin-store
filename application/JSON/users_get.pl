#! C:\strawberry\perl\bin\perl.exe -w
use File::Basename;
use lib dirname(dirname(dirname(__FILE__))) . '\framework\classes\\';
use lib dirname(dirname(__FILE__)) . '\config\\';
use JSON;
use Test::JSON;
use DBI;
use fw_database;
use config_database;
use CGI 3.47;
use strict;
use utf8;

my $q = CGI->new;

my $page = $q->param('page'); 
my $limit = $q->param('rows');
my $sidx = $q->param('sidx'); 
my $sord = $q->param('sord'); 

my $dbh = DBI->connect('DBI:' . DB_TYPE. ':' . DB_NAME,
                                DB_USER,
                                DB_PASSWORD
            )
    || die "Could not connect to database: $DBI::errstr";
$dbh->do("SET NAMES 'utf8'");
$dbh->{'mysql_enable_utf8'} = 1;

my @rows = qw[id name login email password role];

my $start = $limit * $page - $limit;

my $response = {};
$response->{rows} = fw_database->new($dbh)->select_and_fetchall_array_for_JSON(
            'users', \@rows, {}, { "-$sord" => $sidx }, $limit, $start
        );

foreach (@{$response->{rows}}) {
    $_->{cell}->[-1] = ($_->{cell}->[-1]) ? 'Админ' : 'Пользователь'; 
}

my $count = fw_database->new($dbh)->select_num_rows('users');

my $total_pages;
if( $count > 0 ) {
    $total_pages = int ($count / $limit);
    $total_pages++ if ($count % $limit);
} else {
    $total_pages = 0;
}

$response->{page} = $page;
$response->{total} = $total_pages;
$response->{records} = $count;

my $json = JSON->new;
print $q->header(-type => "application/json", -charset => "utf-8");
my $json_text = $json->utf8->encode($response);
#Test::JSON::is_valid_json $json_text;
print $json_text;