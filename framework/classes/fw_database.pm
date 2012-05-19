package fw_database; {
    use SQL::Abstract;
    use SQL::Abstract::Limit;
    use DBI;
    use Class::InsideOut qw/:std/;
    use config_database;
    use strict;
    use utf8;
    
    public database_handler => my %database_handler;
    public sql_gen_handler => my %sql_gen_handler;
    
    sub new {
        my($class, $dbh) = @_;
        my $self = bless {}, $class;
      
        register($self); 
            
        $self->database_handler($dbh);
        $self->sql_gen_handler(SQL::Abstract::Limit->new( limit_dialect => $dbh ));
            
        return $self;
    }
    
    sub select_and_fetchall_hashref {
        my($self, $table_name, $key_field, $params, $where, $order) = @_;
        
        my($stmt, @bind) = $self->sql_gen_handler->select(TBL_PREFIX . $table_name, $params, $where, $order);
        my $sth = $self->database_handler->prepare($stmt);
        $sth->execute(@bind);
        
        return $sth->fetchall_hashref($key_field);
    }
    
    sub select_and_fetchall_arrayhashesref {
        my($self, $table_name, $params, $where, $order, $limit, $offset) = @_;
        
        my($stmt, @bind) = $self->sql_gen_handler->select(TBL_PREFIX . $table_name, $params, $where, $order);
        my $sth = $self->database_handler->prepare($stmt);
        $sth->execute(@bind);
        my @fetched_array;
        while (my $data = $sth->fetchrow_hashref) {
            push @fetched_array, $data;
        }
        return \@fetched_array;
    }
    
    sub select_and_fetchall_arrayhashesref_without_abstract {
        my($self, $stmt, $bind) = @_;
        
        my $sth = $self->database_handler->prepare($stmt);
        $sth->execute(@$bind);
        my @fetched_array;
        while (my $data = $sth->fetchrow_hashref) {
            push @fetched_array, $data;
        }
        return \@fetched_array;
    }
    
    sub select_and_fetchall_array_for_jsGrid {
        my($self, $table_name, $params, $where, $order, $limit, $offset) = @_;
        
        my($stmt, @bind) = $self->sql_gen_handler->select(TBL_PREFIX . $table_name, $params, $where, $order, $limit, $offset);
        my $sth = $self->database_handler->prepare($stmt);
        $sth->execute(@bind);
        my @fetched_array;
        while (my @data = $sth->fetchrow_array) {
            push @fetched_array, {cell => \@data, id => $data[0]};
        }
        return \@fetched_array;
    }
    
    sub select_and_fetchall_array_for_jsGrid_without_abstract {
        my($self, $stmt, $bind) = @_;
        my $sth = $self->database_handler->prepare($stmt);
        $sth->execute(@$bind);
        my @fetched_array;
        while (my @data = $sth->fetchrow_array) {
            push @fetched_array, {cell => \@data, id => $data[0]};
        }
        return \@fetched_array;
    }
    
    sub select_and_fetchrow_hashref {
        my($self, $table_name, $key_field, $params, $where) = @_;
        
        my($stmt, @bind) = $self->sql_gen_handler->select(TBL_PREFIX . $table_name, $params, $where);
        my $sth = $self->database_handler->prepare($stmt);
        $sth->execute(@bind);
        
        return $sth->fetchrow_hashref();
    }
    
    sub select_num_rows {
        my($self, $table_name, $where) = @_;
        
        my($stmt, @bind) = $self->sql_gen_handler->select(TBL_PREFIX . $table_name, 'count(*)', $where);
        my $sth = $self->database_handler->prepare($stmt);
        $sth->execute(@bind);
        
        my @row = $sth->fetchrow_array; #как сделать хорошо?
        
        return $row[0];
    }
    
    sub select_num_rows_without_abstract {
        my($self, $stmt, $bind) = @_;
        
        my $sth = $self->database_handler->prepare($stmt);
        $sth->execute(@$bind);
        
        my @row = $sth->fetchrow_array; #как сделать хорошо?
        
        return $row[0];
    }
    
    sub last_inserted_id {
        my($self, $table_name) = @_;
        $table_name = TBL_PREFIX . $table_name;
        my $result = $self->database_handler->selectrow_hashref("SELECT LAST_INSERT_ID() as id FROM $table_name");
        return $result->{id};
    }
    
    sub update {
        my($self, $table_name, $params, $where) = @_;
      
        my($stmt, @bind) = $self->sql_gen_handler->update(TBL_PREFIX . $table_name, $params, $where);
        my $sth = $self->database_handler->prepare($stmt);
        $sth->execute(@bind);
    }
    
    sub insert {
        my($self, $table_name, $params) = @_;
      
        my($stmt, @bind) = $self->sql_gen_handler->insert(TBL_PREFIX . $table_name, $params);
        my $sth = $self->database_handler->prepare($stmt);
        $sth->execute(@bind);
    }
    
    sub delete {
        my($self, $table_name, $where) = @_;
      
        my($stmt, @bind) = $self->sql_gen_handler->delete(TBL_PREFIX . $table_name, $where);
        my $sth = $self->database_handler->prepare($stmt);
        $sth->execute(@bind);
    }
    
    sub truncate {
        my($self, $table_name) = @_;
        $table_name = TBL_PREFIX . $table_name;
        my $sth = $self->database_handler->prepare("TRUNCATE $table_name");
        $sth->execute();
    }
    
    sub get_where {
        my($self, $params, $order, $limit, $offset) = @_;
        return $self->sql_gen_handler->where($params, $order, $limit, $offset);
    }
}

1;