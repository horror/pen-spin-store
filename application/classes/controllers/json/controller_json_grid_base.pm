package controller_json_grid_base; {
    use base fw_controller_json;
    use Class::InsideOut qw/:std/;
    use strict;
    use auth;
    use 5.010;
    use utf8;
    
    public search_ops_sql_repr => my %search_ops_sql_repr;
     
    sub new {
        my($class, $params, $cookies) = @_;
    
        my $self = fw_controller_json::new($class, $params, $cookies);
	
	if ($self->request->{_search} eq 'true') {
	    $self->request->{filters} = $self->decode_json_request($self->request->{filters});
	}
       
        $self->search_ops_sql_repr({
	    eq => { '=' => '%d' },
	    ne => { '!=' => '%d' },
	    lt => { '<' => '%d' },
	    le => { '<=' => '%d' },
	    gt => { '>' => '%d' },
	    ge => { '>=' => '%d' },
	    bw => {-like => '%s%%' },
	    bn => {-not_like => '%s%%' },
	    ew => {-like => '%%%s%' },
	    en => {-not_like => '%%%s%' },
	    cn => {-like => '%%%s%%' },
	    nc => {-not_like => '%%%s%%' },
	});
       
        return $self;
    }
    
    sub action_set {
        my $self = shift;
	
        my $auth = auth->new($self->cookies(), $self->database_handler());
	if (not $auth->logged_admin_id()) {
	    return;
	}
	
	given ($self->request->{'oper'}) {
	    when ("del") {$self->action_delete()}
	    when ("edit") {$self->action_edit()}
	    when ("add") {$self->action_add()}
	}

    }
    
    sub action_delete(){;};
    sub action_edit(){;};
    sub action_add(){;};
    
    sub set_grid_params {
        my ($self, $count, $limit, $page) = @_;
	
	my $total_pages;
	
	if( $count > 0 ) {
	    $total_pages = int ($count / $limit);
	    $total_pages++ if ($count % $limit);
	} else {
	    $total_pages = 0;
	}
	
	$self->data->{page} = $page;
	$self->data->{total} = $total_pages;
	$self->data->{records} = $count;
    }
    
}

1;