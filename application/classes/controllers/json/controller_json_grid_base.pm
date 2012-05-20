package controller_json_grid_base; {
    use base fw_controller_json;
    use Class::InsideOut qw/:std/;
    use strict;
    use auth;
    use 5.010;
    use utf8;
    
    public user_is_admin => my %user_is_admin;
    public user_id => my %user_id;
     
    sub new {
        my($class, $params, $cookies) = @_;
    
        my $self = fw_controller_json::new($class, $params, $cookies);
	
	if ($self->request->{_search} eq 'true') {
	    $self->request->{filters} = $self->decode_json_request($self->request->{filters});
	}
	
        my $auth = auth->new($self->cookies(), $self->database_handler());
	
        $self->user_is_admin($auth->logged_admin_id() > 0);
	
	$self->user_id($auth->logged_user_id());
	
        return $self;
    }
    
    sub action_set {
        my $self = shift;

	if (!$self->user_is_admin()) {
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
        my ($self, $count) = @_;
	
	my $page = $self->request->{'page'}; 
	my $limit = $self->request->{'rows'};
	
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
    
    sub get_order {
	my $self = shift;
	
	my $sidx = $self->request->{'sidx'} unless $self->request->{'sidx'} =~ /\W/; 
	my $sord = $self->request->{'sord'} unless $self->request->{'sord'} =~ /\W/;
	
	return { "-$sord" => $sidx };
    }
    
    sub get_filters {
	my $self = shift;
	
	my $search_ops_sql_repr = {
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
	};
	
	my $filters = {};
	if ($self->request->{_search} eq 'true') {
	    my $filters_cond = lc $self->request->{filters}->{groupOp};
	    my $filter = {};
	    
	    foreach (@{$self->request->{filters}->{rules}}) {
	        $filter->{$_->{field}} = $search_ops_sql_repr->{$_->{op}};
		my ($key) = keys %{$filter->{$_->{field}}};
		$filter->{$_->{field}}->{$key} = sprintf($filter->{$_->{field}}->{$key}, $_->{data});     
	    }
	    
	    foreach my $key (keys %$filter) {
	        push @{$filters->{"-$filters_cond"}}, {$key => $filter->{$key}};
	    }
	}
	
	return $filters;
    }
    
    sub get_offset {
	my $self = shift;
	
	return $self->request->{'rows'} * $self->request->{'page'} - $self->request->{'rows'};
    }
    
    sub get_limit {
	my $self = shift;
	
	return $self->request->{'rows'};
    }
    
}

1;