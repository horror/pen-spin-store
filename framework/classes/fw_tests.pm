package fw_tests; {
    use Class::InsideOut qw/:std/;
    use strict;
    
    public db => my %db;
    
    sub new {
	my($class, $dbh) = @_;
	my $self = bless {}, $class;
	
	register($self);
	
	
	
	$self->db($dbh);
	
	return $self;
    }
  
}

1;