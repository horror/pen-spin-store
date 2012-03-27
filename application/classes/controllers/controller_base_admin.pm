package controller_base_admin; {
    use base fw_controller;
    use folder_config;
    use widget_horz_menu;
    use utf8;
    use auth;
    
    use strict;
    
    sub new {
        my ($class, $args, $cookies, $files) = @_;
        my $self = fw_controller::new($class, $args, $cookies, $files);
        
        my $widget_menu = widget_horz_menu->new($args, $cookies, $self->database_handler());
        
        my $uri_pattern = "index.pl?controller=admin_%s&action=%s";
    
        $widget_menu->set_items([
            {
                uri => sprintf($uri_pattern, 'main', 'stats'),
                caption => $self->lang->STATS_MENU_ITEM,
            },
            {
                uri => sprintf($uri_pattern, 'users', 'show'),
                caption => $self->lang->USERS_MENU_ITEM,
            },
            {
                uri => sprintf($uri_pattern, 'products', 'show'),
                caption => $self->lang->PRODUCTS_MENU_ITEM,
            },
        ]);
    
        $self->template_settings('admin', 'base_admin.tpl', {
            site_name => $self->lang->ADMIN_TITLE,
            main_menu => $widget_menu->execute(),
        }, [
            APP_CSS_PATH . __DM . 'style.css',    
            APP_CSS_PATH . __DM . 'style_admin.css',
            APP_CSS_PATH . __DM . 'jquery-ui-1.8.18.custom.css',
            APP_CSS_PATH . __DM . 'ui.jqgrid.css',
            APP_CSS_PATH . __DM . 'ui.multiselect.css',
        ],[
            APP_JS_PATH . __DM . 'jquery-1.7.1.min.js',
            APP_JS_PATH . __DM . 'jquery-ui-1.8.18.custom.min.js',
            APP_JS_PATH . __DM . 'i18n' . __DM . 'grid.locale-ru.js',
            APP_JS_PATH . __DM . 'jquery.jqGrid.src.js',
            APP_JS_PATH . __DM . 'products_edit_forms.js', 
        ]);
        
        $self->before();
        
        return $self;
    }
    
    sub before {
        my $self = shift;
        
        my $auth = auth->new($self->cookies(), $self->database_handler());
        if ( not $auth->logged_admin_id() and not (ref($self) eq 'controller_admin_login')) {
            $self->redirection('admin_login', 'index');
        }
    }
    
}

1;