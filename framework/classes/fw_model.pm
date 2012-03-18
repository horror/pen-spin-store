package fw_model; {
  use fw_database;
  use Class::InsideOut qw/:std/;
  use strict;
  use utf8;
  
  public fw_database_handler => my %fw_database_handler;
  
  sub new {
    my($class, $dbh) = @_;
    my $self = bless {}, $class;
    register($self); 
        
    $self->fw_database_handler(fw_database->new($dbh));
        
    return $self;
  }
  
}

1;