package controller_admin_login; {
    use base controller_base_admin;
    use auth;
    use strict;
    use utf8;
  
    sub new {
	my ($class, $args, $cookies) = @_;
	my $self = controller_base_admin::new($class, $args, $cookies);
	return $self;
    }
  
    sub action_index {
	my $self = shift;
	my $message;
	
	if ($self->request->{submit}) {
	    my $auth = auth->new($self->cookies(), $self->database_handler());
	    if ($auth->login_admin($self->request->{login}, $self->request->{password})) {
		$self->redirection('admin_main', 'stats');
	    }
	    else {
	        $message = 'Логин и пароль введены не верно';
	    }
        }
	
	$self->add_template_params({
	    main_menu => '',                            #пока залепил
	    page_title => 'Вход в админ. панель',
	    center_block => [
		fw_view->new('admin', 'login_index.tpl', {
		    message => $message,
		})->execute()
	    ]
	});
    }
}

1;