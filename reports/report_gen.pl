#! C:\strawberry\perl\bin\perl.exe -w

use strict;
use JSON;
use PDF::API2;
use PDF::Table;
use DBI;
use SQL::Abstract;
use utf8;

#Константы
sub DB_TYPE() {'mysql'};
sub DB_NAME() {'pen_store'};
sub DB_USER() {'root'};
sub DB_PASSWORD() {'c2h5oh'};
sub TBL_PREFIX() {'ps_'};

sub X_HEADER() {1};
sub Y_HEADER() {0};
sub CELL_VALUE() {2};

my $dbh = DBI->connect('DBI:' . DB_TYPE. ':' . DB_NAME,
		    DB_USER,
		    DB_PASSWORD
)
    || die "Could not connect to database: $DBI::errstr";
$dbh->do("SET NAMES 'utf8'");
$dbh->{'mysql_enable_utf8'} = 1;

for(;;){
    open TASK, "+<queue.txt";
    #Получили данные очереди
    my $json_task = "[";
    while (<TASK>){
        chomp;
        $json_task .= $_;
    }
    truncate TASK, 0;
    close TASK;
    
    if ($json_task eq "[") {
		sleep (3);
		next;
	};
    
    $json_task =~ s/,[^,]*$/]/g;
    
    my $task = JSON->new->utf8->decode($json_task);
    open LOG, ">>log/activity.log";
    binmode LOG;
    foreach my $report(@$task) {
        my $param_for_SQL = &prepere_param($report);
        my $data = &get_data($param_for_SQL);
	&gen_report($data, $report->{'name'});
        print LOG scalar(localtime) . " Отчет $report->{'name'} создан\n";
    }
    
    close LOG;
}

sub prepere_param() {
    my $params = shift;
    
    my $users_fields = {sex => 'u.sex', adress => 'u.adress', name => 'u.login'};
    my $product_fields = {prod_name => 'p.name', cat_name => 'c.name'};
    my $detal = {users => $users_fields, products => $product_fields};
    
    my $agregator = {min => 'MIN', max => 'MAX', sum => 'SUM', avg => 'AVG'};
    my $analize_fields = {price => 'op.price_per_one * op.products_count', count => 'op.products_count'};
    
    return {
        x_field => $detal->{$params->{x_axis}}->{$params->{x_detalisation}},
	y_field => $detal->{$params->{y_axis}}->{$params->{y_detalisation}},
	agregator => $agregator->{$params->{aggregation}},
	analized_field => $analize_fields->{$params->{analyze}},
    };
}

sub get_data() {
    my $params = shift;
    
    my $stmt = "SELECT $params->{'x_field'}, $params->{'y_field'}, $params->{'agregator'}($params->{'analized_field'}) 
	FROM ps_orders_products_href op 
	LEFT JOIN ps_orders o on op.order_id = o.id
	LEFT JOIN ps_users u on o.user_id = u.id
	LEFT JOIN ps_products p on p.id = op.product_id
	LEFT JOIN ps_categories c on c.id = p.category_id
	GROUP BY $params->{'x_field'}, $params->{'y_field'}
	ORDER BY $params->{'x_field'}, $params->{'y_field'}";
	
    my $sth = $dbh->prepare($stmt);
    $sth->execute();
    
    return $sth->fetchall_arrayref() 
}

sub in_array {
     my ($arr,$search_for) = @_;
     my %items = map {$_ => 1} @$arr;
     return (exists($items{$search_for}))?1:0;
}

sub gen_report() {
    my ($report, $report_name) = @_;
    
    my $pdftable = new PDF::Table;
    my $pdf = new PDF::API2(-file => "$report_name.pdf");
    my $page = $pdf->page;
    
    my %report_data;
    my @x_axis;
    push @x_axis, '';
    my @y_axis;
    push @y_axis, '';
    for my $row(@$report) {
        $report_data{$row->[0]}{$row->[1]} = $row->[2];
	push @x_axis, $row->[1] unless in_array(\@x_axis, $row->[1]);
	push @y_axis, $row->[0] unless in_array(\@y_axis, $row->[0]);
    };
    
    for my $key(sort keys %report_data) {
        my @values = @{$report_data{$key}}{@x_axis};
        @{$report_data{$key}}{@x_axis} = @values;
    };
    
    my @rd;
    my $i = 1;
    my $j;
    for my $x(sort keys %report_data) {
        $j = 0;
        for my $cell(sort keys $report_data{$x}) {
            $rd[$i][$j] = $report_data{$x}->{$cell};
	    $j++;
	}
	$i++;
    };
    $rd[0] = \@x_axis;
    for my $i(0..@y_axis - 1) {
       $rd[$i][0] = $y_axis[$i];
    }
    my $col_props = [
	{
	    min_w => 100,       # Minimum column width.
	    max_w => 150,       # Maximum column width.
	    justify => 'left', # One of left|center|right ,
	    font => $pdf->corefont('Verdana', -encode=> 'windows-1251'),
	    font_size => 10,
	    font_color=> '#CCCC99',
	    background_color => '#336666',
	}
    ];  
    my $hdr_props = 
    {
        # This param could be a pdf core font or user specified TTF.
        #  See PDF::API2 FONT METHODS for more information
        font       => $pdf->corefont('Verdana', -encode=> 'windows-1251' ),
        font_size  => 10,
        font_color => '#CCCC99',
        bg_color   => '#336666',
        repeat     => 1,    # 1/0 eq On/Off  if the header row should be repeated to every new page
    };
    
    my $left_edge_of_table = 50;
    # build the table layout
    $pdftable->table(
	# required params
	$pdf,
	$page,
	\@rd,
	x => $left_edge_of_table,
	w => 495,
	start_y => 750,
	next_y  => 700,
	start_h => 300,
	next_h  => 500,
	font => $pdf->corefont('Verdana', -encode=> 'windows-1251'),
	# some optional params
	padding => 5,
	padding_right => 10,
	background_color_odd  => "gray",
	background_color_even => "lightblue", #cell background color for even rows
	header_props   => $hdr_props, # see section HEADER ROW PROPERTIES
        column_props   => $col_props, # see section COLUMN PROPERTIES
     );
    
    $pdf->saveas();
    
}