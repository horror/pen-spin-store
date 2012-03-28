package products_importer; {
    use model_products;
    use fw_database;
    use LWP::Simple;
    use Class::InsideOut qw/:std/;
    use strict;
    use utf8;
    
    public database_handler => my %database_handler;
    
    sub new {
        my($class, $dbh) = @_;
        my $self = bless {}, $class;
        
        register($self); 
            
        $self->database_handler($dbh);
        return $self;
    }
    
    sub penwish_import {
        my $self = shift;
	
	fw_database->new($self->database_handler())->truncate("products");
	fw_database->new($self->database_handler())->truncate("categories");
	
	my $page = get "http://penwish.com/";
	$self->parse_category($1, $2)
            while ($page =~ m#<a class="navGrey".*?href="(.*?)">(?:<strong>|)(.*?)(?:<[/]?s.*?|)</a>#ig);
    }
    
    sub parse_category {
	my($self, $url, $cat_name, $cat_path) = @_;
	my ($cat_id) = $url =~ m#^.*?cPath=.*?(\d+)$#i;
	my ($parent_cat_id) = $cat_path =~ m#(\d+)\.$#;
	$parent_cat_id = 0 if !defined $parent_cat_id;
	$cat_path .= "$cat_id.";
	
	model_products->new($self->database_handler())->add_category($parent_cat_id, $cat_name, $cat_path, $cat_id);
	
	my $page = get $url;
	if ($page =~ /productListing/i) {
	    $self->parse_products($page, $cat_name, $cat_id, $cat_path);
	}
	else {
	    $self->parse_sub_categorises($page, $cat_name, $cat_id, $cat_path);
	}
    }
    
    sub parse_sub_categorises {
	my($self, $page, $par_cat_name, $cat_id, $cat_path) = @_;
	
	$self->parse_category($1, $2, $cat_path)
	    while ($page =~ m#<a.*?href="(.*?cPath=[\d]+_[\d]+.*?)">(?:<strong>|)(?:<.*?>)*(.*?)(?:<[/]?s.*?|)</a>#ig);
    }
    
    sub parse_products {
	my($self, $page, $par_cat_name, $cat_id, $cat_path) = @_;
	my $prod_id = 0;
	while ($page =~ m#<tr class="productListing-(?:odd|even)">.*?<img src="images/(.*?)".*?<a.*?products_id=.*?>(.*?)</a>.*?<td.*?>(?:&nbsp;|)\$(.*?)(?:&nbsp;|)</td>#igs) {
	    $prod_id = model_products->new($self->database_handler())
	        ->add_product_and_get_id({image => $1, name => $2, price => $3}, $cat_id, $cat_path);
	    model_products->new($self->database_handler())
		->add_product_images_by_id($prod_id, [$1]);
	    my $file = 'C:\Apache2.2\localhost\www\application\media\img\products\\' . $1;
	    unless (-e $file) {
	        getstore( "http://penwish.com/images/$1", 'C:\Apache2.2\localhost\www\application\media\img\products\\' . $1);
	    }
	}
	
	my ($next_page) = $page =~  m%<a href="([^"]+)[^<>]+title="\s*Next\s*Page\s*">%;
	if ($next_page) {
	    $page = get $next_page;
	    $self->parse_products($page, $par_cat_name, $cat_id, $cat_path);
	}
	
    }
    
}

1;