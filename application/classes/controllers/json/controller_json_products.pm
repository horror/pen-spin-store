package controller_json_products; {
    use base controller_json_grid_base;
    use model_products;
    use validation;
    use strict;
    use utf8;
     
    sub new {
        my($class, $params, $cookies) = @_;
    
        my $self = controller_json_grid_base::new($class, $params, $cookies);
            
        return $self;
    }
    
    sub action_get {
        my $self = shift;
        
	my $offset = $self->get_offset();
	my $limit = $self->get_limit();
	
	my $order = $self->get_order();
	my $count;
	
	if ($self->request->{_search} eq 'true') {
	    my $filters = $self->get_filters();
	    
	    $self->data->{rows} = model_products->new($self->database_handler(), $self->lang())
		->get_products($filters, $order, $limit, $offset);
		
	    $count = model_products->new($self->database_handler(), $self->lang())
		->get_products_cnt($filters);
	}
	else {
	    $self->data->{rows} = model_products->new($self->database_handler(), $self->lang())
		->get_products_by_category_id(
		    $self->request->{'cat_id'}, $order, $limit, $offset
		);
		
	    $count = model_products->new($self->database_handler(), $self->lang())
	        ->get_products_cnt_by_category_id($self->request->{'cat_id'});
	}
	
	
	$self->set_grid_params($count);
    }
   
    sub action_set {
        my $self = shift;
        controller_json_grid_base::action_set($self);
    }
    
    sub action_add {
        my $self = shift;
	
	my $product_info = validation->new($self->request(), $self->lang())
	    ->validate_product_form();   
        $product_info = {} unless ref $product_info eq "HASH";
	
	model_products->new($self->database_handler(), $self->lang())
	    ->add_product($product_info, $self->request->{'cat_id'});
    }
    
    sub action_edit {
        my $self = shift;
	
	my $product_info = validation->new($self->request(), $self->lang())
	    ->validate_product_form();          
        $product_info = {} unless ref $product_info eq "HASH";
	
	model_products->new($self->database_handler(), $self->lang())
	    ->edit_product($product_info, $self->request->{'id'});
    }
    
    sub action_delete {
        my $self = shift;
	
	model_products->new($self->database_handler(), $self->lang())
	    ->delete_product($self->request->{'id'});
    }
}

1;