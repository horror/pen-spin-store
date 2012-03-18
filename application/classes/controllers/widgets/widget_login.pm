package widget_login; {
    use base fw_controller;
    use auth;
    use strict;
  
    sub new {
        my ($class, $args, $cookies, $dbh) = @_;
        my $self = fw_controller::new($class, \%$args, \%$cookies, $dbh);
        $self->template_settings('widgets', 'widget_login.tpl');
        $self->before();
        return $self;
    }
    
    sub before {
        my $self = shift;
        if ($self->request->{submit}) {
            my $auth = auth->new($self->cookies(), $self->database_handler());
            $auth->login_user($self->request->{login}, $self->request->{password});
        }
    }
}

1;