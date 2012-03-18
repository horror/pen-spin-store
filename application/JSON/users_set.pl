#! C:\strawberry\perl\bin\perl.exe -w
use File::Basename;
use lib dirname(dirname(dirname(__FILE__))) . '\framework\classes\\';
use lib dirname(dirname(__FILE__)) . '\config\\';
use lib dirname(dirname(__FILE__)) . '\classes\\';
use lib dirname(dirname(__FILE__)) . '\classes\models\\';
use JSON;
use Test::JSON;
use DBI;
use model_users;
use config_database;
use CGI 3.47;
use strict;
use utf8;

my $q = CGI->new;

my $dbh = DBI->connect('DBI:' . DB_TYPE. ':' . DB_NAME,
                                DB_USER,
                                DB_PASSWORD
            )
    || die "Could not connect to database: $DBI::errstr";
$dbh->do("SET NAMES 'utf8'");
$dbh->{'mysql_enable_utf8'} = 1;

my $user_id = $q->param('id');
if ($q->param('oper') eq 'del') {
    model_users->new($dbh)->delete_user($user_id);
}
else {
    my %user_info; 
    my @sign_fields = qw\name login email password role\;
    my @user_values = @{$q->Vars()}{@sign_fields};
    
    @user_info{@sign_fields} = @user_values;
    
    model_users->new($dbh)->add_user(\%user_info) if $q->param('oper') eq 'add'; 
    model_users->new($dbh)->update_user(\%user_info, $user_id) if $q->param('oper') eq 'edit';
}

print $q->header("Content-type: text/plain;charset=utf-8");
print "Операция выполнена успешно!";

