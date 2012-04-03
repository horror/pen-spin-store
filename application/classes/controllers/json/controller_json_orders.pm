package controller_json_orders; {
    use base controller_json_grid_base;
    use model_orders;
    use auth;
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
	
	my $user_id = auth->new($self->cookies(), $self->database_handler())
	    ->logged_user_id();
	
	$self->data->{rows} = model_orders->new($self->database_handler(), $self->lang())
	    ->get_orders_jbgrid_format_calls({ "-$sord" => $sidx }, $limit, $start);
	    
	my $count = model_orders->new($self->database_handler(), $self->lang())
	    ->get_orders_count();
	
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
	    ->get_order_items_jbgrid_format_calls(0, $self->request->{'id'}, $sord, $sidx, $limit, $start);
	    
	my $count = model_orders->new($self->database_handler(), $self->lang())
	    ->get_order_items_count(0, $self->request->{'id'});
	
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