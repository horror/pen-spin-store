package controller_json_categories; {
    use base controller_json_grid_base;
    use model_products;
    use Switch;
    use strict;
    use utf8;
     
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
	$self->data->{rows} = model_products->new($self->database_handler(), $self->lang())->get_category_tree_jbgrid_format_calls();
	
	$self->set_grid_params(7, $limit, $page);
    }
    
    sub action_set {
        my $self = shift;
        controller_json_grid_base::action_set($self);
    }
    
     sub action_add {
        my $self = shift;	
	
	model_products->new($self->database_handler(), $self->lang())->add_category($self->request->{'parent'}, $self->request->{'name'});
    }
    
    sub action_edit {
        my $self = shift;
	
	model_products->new($self->database_handler(), $self->lang())
	    ->edit_category($self->request->{'id'}, $self->request->{'name'});
    }
    
    sub action_delete {
        my $self = shift;
	
	model_products->new($self->database_handler(), $self->lang())
	    ->delete_category($self->request->{'id'});
    }

    
}

1;