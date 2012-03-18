package controller_base_index; {
  use base fw_controller;
  use folder_config;
  use widget_login;
  use widget_horz_menu;
  use auth;
  use utf8;

  
  sub new {
    my ($class, $args, $cookies) = @_;
    my $self = fw_controller::new($class, $args, $cookies);

    my $auth = auth->new($self->cookies(), $self->database_handler());
    my $widget_login = widget_login->new($args, $cookies, $self->database_handler());
    
    my $widget_menu = widget_horz_menu->new($args, $cookies, $self->database_handler());
    
    my $uri_pattern = "index.pl?controller=%s&action=%s";

    $widget_menu->set_items([
        {
            uri => sprintf($uri_pattern, 'main', 'index'),
            caption => 'Главная',
        },
        {
            uri => sprintf($uri_pattern, 'products', 'show'),
            caption => 'Каталог',
        },
    ]);
    
    
    $self->template_settings('index', 'base_index.tpl', {
        site_name => 'PenSpinStore',
        main_menu => $widget_menu->execute(),
        site_description => 'магазин ручек для пен спиннинга',
        c_rights => 'все права защищены (с) 2012',
        login_form => ((!$auth->logged_user_id()) ? $widget_login->execute() : '')
    }, [
        APP_CSS_PATH . __DM . 'style.css', 
        APP_CSS_PATH . __DM . 'style_index.css',
        APP_CSS_PATH . __DM . 'jquery-ui-1.8.18.custom.css',
        APP_CSS_PATH . __DM . 'ui.jqgrid.css',
        APP_CSS_PATH . __DM . 'ui.multiselect.css',
    ],[
        APP_JS_PATH . __DM . 'jquery-1.7.1.min.js',
        APP_JS_PATH . __DM . 'i18n' . __DM . 'grid.locale-ru.js',
        APP_JS_PATH . __DM . 'jquery.jqGrid.min.js', 
    ]);
    return $self;
  }
  
}

1;