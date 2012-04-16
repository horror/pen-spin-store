package model_users; {
    use base fw_model;
    use Digest::MD5 qw(md5_hex);
    use config_session;
    use utf8;
    
    sub new {
        my($class, $dbh, $lang) = @_;
        
        my $self = fw_model::new($class, $dbh, $lang);
            
        return $self;
    }
    
    sub not_allowed_login {
        my($self, $login, $user_id) = @_;
        return $self->fw_database_handler->select_num_rows('users', {login => $login, id => {'!=' => $user_id}});
    }
    
    sub regist_user {
        my($self, $anon_id, $fields) = @_;
        
        if ($self->not_allowed_login($fields->{login}, 0))
        {
            return 0;
        }
        my $pass = $fields->{password};
        $fields->{password} = md5_hex($fields->{password});
        $self->fw_database_handler->update('users', $fields, {id => $anon_id});
        $fields->{password} = $pass;
        return 1;
    }
    
    sub add_anonymous_user {
        my($self, $sid) = @_;
        
        my $fields = {sid => $sid};
        
        $self->fw_database_handler->insert('users', $fields);
    }
    
    sub update_user {
        my($self, $fields, $user_id) = @_;
        delete $fields->{password};
        if ($self->not_allowed_login($fields->{login}, $user_id))
        {
            return 0;
        }
        $self->fw_database_handler->update('users', $fields, { id => $user_id });
        return 1;
    }
    
    sub delete_user {
        my($self, $user_id) = @_;
        $self->fw_database_handler->delete('users', { id => $user_id });
    }
    
    sub get_users_jbgrid_format_calls {
        my($self, $order, $limit, $start) = @_;
        
        my @rows = qw[id name login email password role];
        
        $result = $self->fw_database_handler->select_and_fetchall_array_for_jsGrid(
		    'users', \@rows, {}, $order, $limit, $start
		);
        
        foreach (@$result) {
	    $_->{cell}->[-1] = ($_->{cell}->[-1]) ?
               $self->lang->SELECT_ADMIN_ROLE :
               $self->lang->SELECT_USER_ROLE; 
	}
        
        return $result;
    }
    
    sub get_users_count {
        my $self = shift;
        
        return $self->fw_database_handler->select_num_rows('users')
    }
    
    sub get_user_on_id {
        my($self, $user_id) = @_;
        return $self->fw_database_handler->select_and_fetchrow_hashref('users', 'id', '*', {id => $user_id});
    }
}

1;