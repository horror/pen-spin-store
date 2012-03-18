package fw_controller_json; {
    use Class::InsideOut qw/:std/;
    use DBI;
    use JSON;
    use config_database;
    use folder_config;
    use CGI qw(header cookie redirect);
    use strict;
    use utf8;
    
    
    public database_handler => my %database_handler;
    public request => my %request;
    public cookies => my %cookies;
    public data => my %data;
    
    sub new {
        my($class, $params, $cookies) = @_;
        my $self = bless {}, $class;
    
        register($self); 
    
        $self->request($params);
        $self->cookies($cookies);

        my $dbh = DBI->connect('DBI:' . DB_TYPE. ':' . DB_NAME,
                            DB_USER,
                            DB_PASSWORD
        )
            || die "Could not connect to database: $DBI::errstr";
        $dbh->do("SET NAMES 'utf8'");
        $dbh->{'mysql_enable_utf8'} = 1;
        
        $self->database_handler($dbh);
            
        $self->data({});
            
        return $self;
    }
    
    sub decode_json_request {
        my ($self, $json) = @_;
        
        return JSON->new->utf8->decode($json);
    }
    
    sub render {
        my $self = shift;
        
        print header(-type => "application/json", -charset => "utf-8");;
        print $self->execute();
    }
    
    sub execute {
        my $self = shift;
        
        return (defined $self->data()) ? JSON->new->utf8->encode($self->data()) : '';
    }
    
}

1;