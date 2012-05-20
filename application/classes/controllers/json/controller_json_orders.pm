package controller_json_orders; {
    use base controller_json_grid_base;
    use model_orders;
    use validation;
    use strict;
    use utf8;
    use 5.010;
     
    sub new {
        my($class, $params, $cookies) = @_;
    
        my $self = controller_json_grid_base::new($class, $params, $cookies);
            
        return $self;
    }
    
    sub action_get_orders {
        my $self = shift;
	
	my $offset = $self->get_offset();
	my $limit = $self->get_limit();
	my $filters = $self->get_filters();
	my $order = $self->get_order();
	
	$self->data->{rows} = ($self->user_is_admin()) ?
	    model_orders->new($self->database_handler(), $self->lang())
	        ->get_all_orders_jbgrid_format_calls($filters, $order, $limit, $offset) :
	    model_orders->new($self->database_handler(), $self->lang())
	        ->get_user_orders_jbgrid_format_calls($self->user_id(), $filters, $order, $limit, $offset);
	    
	my $count = ($self->user_is_admin()) ?
	    model_orders->new($self->database_handler(), $self->lang())
	        ->get_orders_count() :
	    model_orders->new($self->database_handler(), $self->lang())
	        ->get_user_orders_count($self->user_id());
	
	$self->set_grid_params($count);
    }
    
    sub action_get_order_items {
        my $self = shift;
        
	my $offset = $self->get_offset();
	my $limit = $self->get_limit();
	my $order = $self->get_order(); 
	
	my $user_id = auth->new($self->cookies(), $self->database_handler())
	    ->logged_user_id();
	
	$self->data->{rows} = model_orders->new($self->database_handler(), $self->lang())
	    ->get_order_items_jbgrid_format_calls($self->request->{'id'}, $order, $limit, $offset);
	    
	my $count = model_orders->new($self->database_handler(), $self->lang())
	    ->get_order_items_count($self->request->{'id'});
	$self->set_grid_params($count);
    }

    sub action_set {
        my $self = shift;
        controller_json_grid_base::action_set($self);
    }
    
   sub action_edit {
        my $self = shift;
	
	model_orders->new($self->database_handler(), $self->lang())
	    ->change_order_status($self->request->{'id'}, $self->request->{'status'});
    }
    
    sub action_delete {
        my $self = shift;
	
	model_orders->new($self->database_handler(), $self->lang())
	    ->delete_order($self->request->{'id'});
    }
}

1;