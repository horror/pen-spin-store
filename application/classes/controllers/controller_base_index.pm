package controller_base_index; {
  use base fw_controller;
  use folder_config;
  use widget_login;
  use widget_horz_menu;
  use widget_cart;
  use model_users;
  use auth;
  use utf8;

  
  sub new {
    my ($class, $args, $cookies, $files) = @_;
    my $self = fw_controller::new($class, $args, $cookies, $files);

    my $auth = auth->new($self->cookies(), $self->database_handler());
    my $widget_login = widget_login->new($args, $cookies, $self->database_handler());
    
    my $widget_menu = widget_horz_menu->new($args, $cookies, $self->database_handler());
    
    my $uri_pattern = "index.pl?controller=%s&action=%s";

    $widget_menu->set_items([
        {
            uri => sprintf($uri_pattern, 'main', 'index'),
            caption => $self->lang->MAIN_MENU_ITEM,
        },
        {
            uri => sprintf($uri_pattern, 'products', 'show'),
            caption => $self->lang->PRODUCTS_MENU_ITEM,
        },
    ]);
    
    my $logged_authorized_user_id= $auth->logged_authorized_user_id();
    if (!$logged_authorized_user_id) {
        my $logged_anonymous_id = $auth->logged_anonymous_user_id();
        if(!$logged_anonymous_id) {
            my $new_sid = $auth->gen_sid();
            model_users->new($self->database_handler(), $self->lang())
	        ->add_anonymous_user($new_sid);
            $auth->set_cookie_sid($new_sid);
        }
    }
    
    my $widget_cart = widget_cart->new($args, $cookies, $self->database_handler());
    
    $self->template_settings('index', 'base_index.tpl', {
        site_name => $self->lang->INDEX_TITLE,
        main_menu => $widget_menu->execute(),
        cart => $widget_cart->execute(),
        site_description => $self->lang->INDEX_DESCR,
        c_rights => $self->lang->COPY_RIGHTS,
        login_form => ((!$logged_authorized_user_id) ? $widget_login->execute() : '<a id="logout" href="#">Выход</a>')
    }, [
        APP_CSS_PATH . __DM . 'style.css', 
        APP_CSS_PATH . __DM . 'style_index.css',
        APP_CSS_PATH . __DM . 'jquery-ui-1.8.18.custom.css',
        APP_CSS_PATH . __DM . 'ui.jqgrid.css',
        APP_CSS_PATH . __DM . 'ui.multiselect.css',     
    ],[
        APP_JS_PATH . __DM . 'jquery-1.7.1.min.js',
        APP_JS_PATH . __DM . 'jquery-ui-1.8.18.custom.min.js',
        APP_JS_PATH . __DM . 'i18n' . __DM . 'grid.locale-ru.js',
        APP_JS_PATH . __DM . 'jquery.jqGrid.src.js',
        APP_JS_PATH . __DM . 'products_edit_forms.js',
        APP_JS_PATH . __DM . 'jcookies.js',
        APP_JS_PATH . __DM . 'logout.js',
    ]);
    return $self;
  }
  
}

1;