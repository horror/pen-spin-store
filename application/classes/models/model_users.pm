package model_users; {
    use base fw_model;
    use Digest::MD5 qw(md5_hex);
    use config_session;
    use utf8;
    
    sub new {
        my($class, $dbh) = @_;
        
        my $self = fw_model::new($class, $dbh);
            
        return $self;
    }
    
    sub add_user {
        my($self, $fields) = @_;
        my $pass = $fields->{password};
        $fields->{password} = md5_hex($fields->{password});
        $self->fw_database_handler->insert('users', $fields);
        $fields->{password} = $pass;
    }
    
    sub update_user {
        my($self, $fields, $user_id) = @_;
        delete $fields->{password};
        $self->fw_database_handler->update('users', $fields, { id => $user_id });
    }
    
    sub delete_user {
        my($self, $user_id) = @_;
        $self->fw_database_handler->delete('users', { id => $user_id });
    }
    
    sub get_all_users {
        my($self, $online_only, $filters, $order) = @_;
        
        if ($online_only) {
            $filters->{last_visit} = { '>' => \["UNIX_TIMESTAMP() - ?", SESSION_TIME_SECONDS]};
        }
        
        return $self->fw_database_handler->select_and_fetchall_arrayhashesref(
            'users', '*', $filters, $order
        );
    }
    
    sub get_users_jbgrid_format_calls {
        my($self, $order, $limit, $start) = @_;
        
        my @rows = qw[id name login email password role];
        
        $result = $self->fw_database_handler->select_and_fetchall_array_for_jsGrid(
		    'users', @rows, {}, $order, $limit, $start
		);
        
        foreach (@$result) {
	    $_->{cell}->[-1] = ($_->{cell}->[-1]) ? 'Админ' : 'Пользователь'; 
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