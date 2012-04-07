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
        
	my $page = $self->request->{'page'}; 
	my $limit = $self->request->{'rows'};
	my $sidx = $self->request->{'sidx'} unless $self->request->{'sidx'} =~ /\W/; 
	my $sord = $self->request->{'sord'} unless $self->request->{'sord'} =~ /\W/;  
	
	my $start = $limit * $page - $limit;
	
	$self->data->{rows} = ($self->user_is_admin()) ?
	    model_orders->new($self->database_handler(), $self->lang())
	        ->get_all_orders_jbgrid_format_calls($sidx, $sord, $limit, $start) :
	    model_orders->new($self->database_handler(), $self->lang())
	        ->get_user_orders_jbgrid_format_calls($self->user_id(), $sidx, $sord, $limit, $start);
	    
	my $count = ($self->user_is_admin()) ?
	    model_orders->new($self->database_handler(), $self->lang())
	        ->get_orders_count() :
	    model_orders->new($self->database_handler(), $self->lang())
	        ->get_user_orders_count($self->user_id());
	
	$self->set_grid_params($count, $limit, $page);
    }
    
    sub action_get_order_items {
        my $self = shift;
        
	my $page = $self->request->{'page'}; 
	my $limit = $self->request->{'rows'};
	my $sidx = $self->request->{'sidx'} unless $self->request->{'sidx'} =~ /\W/; 
	my $sord = $self->request->{'sord'} unless $self->request->{'sord'} =~ /\W/;  
	
	my $start = $limit * $page - $limit;
	
	my $user_id = auth->new($self->cookies(), $self->database_handler())
	    ->logged_user_id();
	
	$self->data->{rows} = model_orders->new($self->database_handler(), $self->lang())
	    ->get_order_items_jbgrid_format_calls($self->request->{'id'}, $sord, $sidx, $limit, $start);
	    
	my $count = model_orders->new($self->database_handler(), $self->lang())
	    ->get_order_items_count($self->request->{'id'});
	
	$self->set_grid_params($count, $limit, $page);
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