package model_stats; {
  use base fw_model;
  use utf8;
  
  sub new {
    my($class, $dbh, $lang) = @_;
    
    my $self = fw_model::new($class, $dbh, $lang);
        
    return $self;
  }
  
  sub get_stats {
    my($self) = @_;

    return [
        [
	    $self->lang->USERS_TABLE_ALIAS,
	    $self->fw_database_handler->select_num_rows('users', '*'),
        ]
    ];
  }
  
}

1;
