package widget_cart; {
    use base fw_controller;
    use model_orders;
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
	$self->add_template_params({
	    product_cnt => $product_cnt,                            
	});
    }
}

1;