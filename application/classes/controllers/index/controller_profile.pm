package controller_profile; {
    use base controller_base_index;
    use folder_config;
    use strict;
    use model_users;
    use widget_horz_menu;
    use auth;
    use validation;
    use utf8;
  
    sub new {
        my ($class, $args, $cookies) = @_;
	
        my $self = controller_base_index::new($class, $args, $cookies);
	
	my $widget_menu = widget_horz_menu->new($args, $cookies, $self->database_handler());
	
	my $uri_pattern = "index.pl?controller=%s&action=%s";
	
	$widget_menu->set_items([
	    {
		uri => sprintf($uri_pattern, 'profile', 'orders'),
		caption => $self->lang->ORDERS_MENU_ITEM,
	    },
	    {
		uri => sprintf($uri_pattern, 'profile', 'settings'),
		caption => $self->lang->SETTINGS_MENU_ITEM,
	    },
	]);
	
	$self->add_template_params({
	    sub_menu => $widget_menu->execute()
	});
	
        return $self;
    }

    sub action_show {
        my $self = shift;
        
        $self->action_orders();
    }
    
    sub action_settings {
        my $self = shift;
	
	my $messages;
	
	my $user_id = auth->new($self->cookies(), $self->database_handler())->logged_user_id();
	if ($self->request->{submit}) {
	    my $result = validation->new($self->request(), $self->lang())->validate_profile_user_form();

	    if (ref $result eq "HASH") {
		model_users->new($self->database_handler())->update_user($result, $user_id);
		$messages = ['Настройки сохранены'];
	    }
	    else {
		$messages = $result;
	    }
	}
	my $user_info = model_users->new($self->database_handler())->get_user_on_id($user_id);
	
	$self->add_template_params({
            page_title => $self->lang->PROFILE_PAGE_TITLE,
            center_block => [
                fw_view->new('common', 'user_form.tpl', {
                    user_info => $user_info,
		    messages => $messages,
		    submit_caption => $self->lang->SUBMIT_SAVE_PROFILE_CAPTION,
		    pass_block_class => 'hidden_block',
		})->execute()
            ]
        });
    }
    
    sub action_orders {
        my $self = shift;
        
        $self->add_template_scripts([
	    APP_JS_PATH . __DM . 'orders_grid.js',
	    APP_JS_PATH . __DM . 'orders_index_pager.js'
	]);
	
        $self->add_template_params({
            page_title => $self->lang->ORDERS_PAGE_TITLE,
            center_block => [
                fw_view->new('common', 'orders_show.tpl')->execute()
            ]
        });
    }
    
}

1;