package widget_cart; {
    use base fw_controller;
    use model_orders;
    use JSON;
    use MIME::Base64 qw(decode_base64);
    use strict;
    
    sub new {
	my ($class, $args, $cookies, $dbh) = @_;
	my $self = fw_controller::new($class, $args, $cookies, {}, $dbh);
	$self->template_settings('widgets', 'widget_cart.tpl');
	$self->before();
        return $self;
    }
    
    sub before {
        my $self = shift;
        
	my $auth = auth->new($self->cookies(), $self->database_handler());
	
	my $product_cnt = model_orders
	    ->new($self->database_handler(), $self->lang())
	    ->get_products_cart_cnt($auth->logged_user_id());
	    
	my $prods_id = $self->cookies->{comparison_prod_ids}->{value}->[0];
	if (defined $prods_id) {
	    $prods_id = decode_base64($prods_id);
	    $prods_id = JSON->new->utf8->decode($prods_id) if $prods_id;
	    $prods_id = scalar(@$prods_id);
	}
	else {
	    $prods_id = 0;
	}
	$self->add_template_params({
	    product_cnt => $product_cnt,
	    product_comp_cnt => $prods_id, 
	});
    }
}

1;