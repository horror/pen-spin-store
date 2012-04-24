#! C:\strawberry\perl\bin\perl.exe -w

use strict;
use JSON;
use PDF::API2;
use PDF::Table;
use DBI;
use SQL::Abstract;
use Win32::Pipe;
use utf8;

sub DB_TYPE() {'mysql'};
sub DB_NAME() {'pen_store'};
sub DB_USER() {'root'};
sub DB_PASSWORD() {'c2h5oh'};
sub TBL_PREFIX() {'ps_'};

my $dbh = DBI->connect('DBI:' . DB_TYPE. ':' . DB_NAME,
		    DB_USER,
		    DB_PASSWORD
)
    || die "Could not connect to database: $DBI::errstr";
$dbh->do("SET NAMES 'utf8'");
$dbh->{'mysql_enable_utf8'} = 1;

my $PipeName = "pdf_gen";

for(;;){
    if (my $Pipe = new Win32::Pipe($PipeName)) {
	while ($Pipe->Connect()) {
	    my $json_task = $Pipe->Read();
	    my $task = JSON->new->utf8->decode($json_task);
	    my $param_for_SQL = &prepere_param($task);
	    my $data = &get_data($param_for_SQL);
	    &gen_report($data, $task->{'name'});
	    print scalar(localtime) . "Report named '$task->{'name'}' was created\n";
	    $Pipe->Disconnect();
	}
        $Pipe->Close();
    }
}

sub prepere_param() {
    my $params = shift;
    
    my $users_fields = {sex => "IF(u.sex, 'Мужчины', 'Женщины')", adress => 'u.adress', name => 'u.login'};
    my $product_fields = {prod_name => 'p.name', cat_name => 'c.name'};
    my $date = 'FROM_UNIXTIME(o.order_date)';
    my $date_fields = {
        day => "DATE_FORMAT($date, '%d.%m.%Y')",
	week => "CONCAT('c ', DATE_FORMAT(DATE_ADD($date, INTERVAL(1-DAYOFWEEK($date)) DAY), '%d.%m.%Y'),
	    ' по ', DATE_FORMAT(DATE_ADD($date, INTERVAL(7-DAYOFWEEK($date)) DAY), '%d.%m.%Y'))",
	month => "DATE_FORMAT($date, '%m.%Y')",
	year => "YEAR($date)"
    };
    my $detal = {users => $users_fields, products => $product_fields, periods => $date_fields};
    
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
    my $font = $pdf->corefont('Verdana', -encode=> 'windows-1251');
    my $text = $page->text();
    $text->font($font, 16);
    $text->translate(50, 700);
    #огромный отчет
    if(@$report > 10)
    {
	$text->text('Слишком большой отчет. Измените оси или усильте фильтры');
	$pdf->saveas();
	return;
    }
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
	    min_w => 60,       # Minimum column width.
	    max_w => 150,       # Maximum column width.
	    justify => 'left', # One of left|center|right ,
	    font => $font,
	    font_size => 9,
	    font_color=> '#CCCC99',
	    background_color => '#336666',
	}
    ];  
    my $hdr_props = 
    {
        # This param could be a pdf core font or user specified TTF.
        #  See PDF::API2 FONT METHODS for more information
        font       => $font,
        font_size  => 9,
        font_color => '#CCCC99',
        bg_color   => '#336666',
        repeat     => 1,    # 1/0 eq On/Off  if the header row should be repeated to every new page
    };
    
    my $left_edge_of_table = 30;
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
	font => $font,
	font_size  => 8,
	padding => 5,
	padding_right => 10,
	background_color_odd  => "gray",
	background_color_even => "lightblue", #cell background color for even rows
	header_props   => $hdr_props, # see section HEADER ROW PROPERTIES
        column_props   => $col_props, # see section COLUMN PROPERTIES
     );
    
    $pdf->saveas();
    
}