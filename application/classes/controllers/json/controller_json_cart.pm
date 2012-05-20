package controller_json_cart; {
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
    
    sub action_get {
        my $self = shift;  
	
	my $limit = $self->get_limit();
	my $offset = $self->get_offset();
	my $order = $self->get_order();
	
	my $user_id = auth->new($self->cookies(), $self->database_handler())
	    ->logged_user_id();
	
	$self->data->{rows} = model_orders->new($self->database_handler(), $self->lang())
	    ->get_order_items_jbgrid_format_calls_by_user_id($user_id, $order, $limit, $offset);
	    
	my $count = model_orders->new($self->database_handler(), $self->lang())
	    ->get_order_items_count_by_user_id($user_id);
	
	$self->set_grid_params($count);
    }

    sub action_set {
        my $self = shift;
	
	given ($self->request->{'oper'}) {
	    when ("del") {$self->action_delete()}
	    when ("edit") {$self->action_edit()}
	}

    }
    
    sub action_edit {
        my $self = shift;
	
	my $user_id = auth->new($self->cookies(), $self->database_handler())
	    ->logged_user_id();
	    
	model_orders->new($self->database_handler(), $self->lang())
	    ->change_card_item_cnt($user_id, $self->request->{'id'}, $self->request->{'products_count'});
    }
    
    sub action_delete {
        my $self = shift;
	
	my $user_id = auth->new($self->cookies(), $self->database_handler())
	    ->logged_user_id();
	    
	model_orders->new($self->database_handler(), $self->lang())
	    ->delete_card_item($user_id, $self->request->{'id'});
    }
}

1;