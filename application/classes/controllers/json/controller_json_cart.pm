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
        
	my $page = $self->request->{'page'}; 
	my $limit = $self->request->{'rows'};
	my $sidx = $self->request->{'sidx'} unless $self->request->{'sidx'} =~ /\W/; 
	my $sord = $self->request->{'sord'} unless $self->request->{'sord'} =~ /\W/;  
	
	my $start = $limit * $page - $limit;
	
	my $user_id = auth->new($self->cookies(), $self->database_handler())
	    ->logged_user_id();
	
	$self->data->{rows} = model_orders->new($self->database_handler(), $self->lang())
	    ->get_card_items_jbgrid_format_calls($user_id, $sord, $sidx, $limit, $start);
	    
	my $count = model_orders->new($self->database_handler(), $self->lang())
	    ->get_card_items_count($user_id);
	
	$self->set_grid_params($count, $limit, $page);
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
	
	model_orders->new($self->database_handler(), $self->lang())
	    ->change_card_item_cnt($self->request->{'id'}, $self->request->{'products_count'});
    }
    
    sub action_delete {
        my $self = shift;
	
	model_orders->new($self->database_handler(), $self->lang())
	    ->delete_card_item($self->request->{'id'});
    }
}

1;