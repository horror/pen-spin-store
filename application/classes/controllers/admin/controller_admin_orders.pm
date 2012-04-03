package controller_admin_orders; {
    use base controller_base_admin;
    use folder_config;
    use strict;
    use utf8;
  
    sub new {
        my ($class, $args, $cookies) = @_;
        my $self = controller_base_admin::new($class, $args, $cookies);
        return $self;
    }

    sub action_show {
        my $self = shift;
        
        $self->add_template_scripts([APP_JS_PATH . __DM . 'users_grid.js']);
        
        $self->add_template_params({
            page_title => $self->lang->USERS_PAGE_TITLE,
            center_block => [
                fw_view->new('admin', 'users_show.tpl')->execute()
            ]
        });
    }
 
}

1;