package fw_controller; {
    use Class::InsideOut qw/:std/;
    use fw_view;
    use DBI;
    use config_database;
    use folder_config;
    use CGI qw(header cookie redirect);
    use strict;
    use russian;
    use utf8;
    
    
    public database_handler => my %database_handler;
    public lang => my %lang;
    public request => my %request;
    public cookies => my %cookies;
    public template_name => my %template_name;
    public template_params => my %template_params;
    public template_styles => my %template_styles;
    public template_scripts => my %template_scripts;
    public template_type => my %template_type;
  
    sub new {
        my($class, $args, $cookies, $dbh) = @_;
        my $self = bless {}, $class;
    
        register($self); 
    
        $self->request($args);
        
        $self->cookies($cookies);
        
        unless(defined($dbh)) {
            $dbh = DBI->connect('DBI:' . DB_TYPE. ':' . DB_NAME,
                                DB_USER,
                                DB_PASSWORD
            )
                || die "Could not connect to database: $DBI::errstr";
            $dbh->do("SET NAMES 'utf8'");
            $dbh->{'mysql_enable_utf8'} = 1;
        }
            
        $self->database_handler($dbh);
        $self->lang(russian->new());
        return $self;
    }
    
    sub render {
        my($self) = shift;
        print header(
            -cookie => [map ($_, values %{$self->cookies()})],
            -charset => "utf-8"
        );
        print $self->execute();
    }
    
    sub execute {
        my $self = shift;
        
        return fw_view
            ->new($self->template_type(), $self->template_name(),
                  $self->template_params(), $self->template_styles(),
                  $self->template_scripts()
            )
            ->execute();
    }
    
    sub redirection {
        my ($self, $controller, $action) = @_;
        my $url = ROOT_PATH . "index.pl?controller=$controller&action=$action";
        
        print redirect(        
            -cookie => [map ($_, values %{$self->cookies()})],
            -url => $url,
        );

    }
    
    sub set_cookies {
        my ($self, $name, $value) = @_;
        
        my $cookies = $self->cookies();
        $cookies->{$name} = cookie(-name => $name, -value => $value);
        $self->cookies($cookies);
    }
    
    sub add_template_params {
        my ($self, $params) = @_;
        my %_params = (defined $self->template_params()) ? (%{$self->template_params()}, %$params) : %$params;
        $self->template_params(\%_params);
    }
    
    sub add_template_scripts {
        my ($self, $scripts) = @_;
        my @_scripts = (defined $self->template_scripts()) ? (@{$self->template_scripts()}, @$scripts) : @$scripts;
        $self->template_scripts(\@_scripts);
    }
    
    sub template_settings {
        my($self, $type, $name, $params, $styles, $scripts) = @_;
        $self->template_type($type);
        $self->template_name($name);
        $self->template_params($params);
        $self->template_styles($styles);
        $self->template_scripts($scripts);
    }
}

1;