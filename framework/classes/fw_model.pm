package fw_model; {
  use fw_database;
  use Class::InsideOut qw/:std/;
  use strict;
  use utf8;
  
  public fw_database_handler => my %fw_database_handler;
  public lang => my %lang;
  
  sub new {
    my($class, $dbh, $lang) = @_;
    my $self = bless {}, $class;
    register($self); 
        
    $self->fw_database_handler(fw_database->new($dbh));
    $self->lang($lang);
        
    return $self;
  }
  
}

1;