package controller_json_users; {
    use base controller_json_grid_base;
    use model_users;
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
	
	if (!$self->user_is_admin()) {
	    return;
	}
        
	my $page = $self->request->{'page'}; 
	my $limit = $self->request->{'rows'};
	my $sidx = $self->request->{'sidx'} unless $self->request->{'sidx'} =~ /\W/; 
	my $sord = $self->request->{'sord'} unless $self->request->{'sord'} =~ /\W/;  
	
	my $start = $limit * $page - $limit;
	
	$self->data->{rows} = model_users->new($self->database_handler(), $self->lang())
	    ->get_users_jbgrid_format_calls({ "-$sord" => $sidx }, $limit, $start);
	my $count = model_users->new($self->database_handler(), $self->lang())->get_users_count();
	
	$self->set_grid_params($count, $limit, $page);
    }

    sub action_set {
        my $self = shift;
        controller_json_grid_base::action_set($self);
    }
 
    sub action_add {
        my $self = shift;
	
	my $user_info = validation->new($self->request(), $self->lang())->validate_user_card_form();   
        $user_info = {} unless ref $user_info eq "HASH";
	
	model_users->new($self->database_handler(), $self->lang())->add_user($user_info);
    }
    
    sub action_edit {
        my $self = shift;
	
	my $user_info = validation->new($self->request(), $self->lang())->validate_user_card_form();          
        $user_info = {} unless ref $user_info eq "HASH";
	
	model_users->new($self->database_handler(), $self->lang())
	    ->update_user($user_info, $self->request->{'id'});
    }
    
    sub action_delete {
        my $self = shift;
	
	model_users->new($self->database_handler(), $self->lang())
	    ->delete_user($self->request->{'id'});
    }
}

1;