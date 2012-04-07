package controller_registration; {
  use base controller_base_index;
  use Class::InsideOut qw/:std/;
  use model_users;
  use strict;
  use utf8;
  use fw_view;
  use mailer;
  use validation;
  use auth;

  sub new {
    my ($class, $args, $cookies) = @_;
    my $self = controller_base_index::new($class, \%$args, \%$cookies);
    return $self;
  }

  sub action_index {
    my $self = shift;
    my @messages;
    if ($self->request->{submit}) {
	my $result = validation->new($self->request(), $self->lang())->validate_registration_user_form();
	
	if (ref $result eq "HASH") {
	    if (model_users->new($self->database_handler(), $self->lang())
	        ->regist_user($self->request->{anonymous_id}, $result))
	    {
		mailer->new($self->request->{email},
		    $self->lang->REG_MAIL_HEADER,
		    sprintf($self->lang->REG_MAIL_TEXT_FORMAT,
			$self->request->{name},
			$self->request->{login},
			$self->request->{password}
		    )
		)->send_mail();
		push @messages, $self->lang->REG_SUCCESS_MESSAGE;
		
		#Логинем
		my $auth = auth->new($self->cookies(), $self->database_handler());
                $auth->login_user($self->request->{login}, $self->request->{password});
		
		#Отправляем в корзину
		$self->redirection('cart', 'show');
		return;
	    }
	    else {
	        push @messages, $self->lang->REG_FAIL_DUBLICATE_LOGIN;
	    }
	}
	else {
	    @messages = @$result;
	}
    }
    
    my $auth = auth->new($self->cookies(), $self->database_handler());
    $self->add_template_params({
        page_title => $self->lang->INDEX_REG_PAGE_TITLE,
	center_block => [
	    fw_view->new('common', 'user_form.tpl', {
	        anonymous_id => $auth->logged_anonymous_user_id(),
		messages => \@messages,
                submit_caption => $self->lang->SUBMIT_REG_CAPTION,
	    })->execute()
	]
    });
  }
}

1;