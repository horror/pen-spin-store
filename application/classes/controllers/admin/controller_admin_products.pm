package controller_admin_products; {
    use base controller_base_admin;
    use folder_config;
    use validation;
    use products_importer;
    use strict;
    use utf8;
  
    sub new {
        my ($class, $args, $cookies) = @_;
        my $self = controller_base_admin::new($class, $args, $cookies);
	
	my $widget_menu = widget_horz_menu->new($args, $cookies, $self->database_handler());
        
        my $uri_pattern = "index.pl?controller=admin_%s&action=%s";
    
        $widget_menu->set_items([
            {
                uri => sprintf($uri_pattern, 'products', 'show'),
                caption => 'Товары',
            },
            {
                uri => sprintf($uri_pattern, 'products', 'import'),
                caption => 'Импорт',
            },
        ]);
	
	$self->add_template_params({center_block_right_section => $widget_menu->execute()});
	
        return $self;
    }

    sub action_show {
        my $self = shift;
        
        $self->add_template_scripts([
	    APP_JS_PATH . __DM . 'products_grid.js',
	    APP_JS_PATH . __DM . 'category_tree.js'
	]);
        
        $self->add_template_params({
            page_title => 'Товары и категории',
            center_block => [
                fw_view->new('common', 'products_show.tpl')->execute()
            ]
        });
    }
 
    sub action_import {
        my $self = shift;
	
        if ($self->request->{submit}) {
	    products_importer->new($self->database_handler())->penwish_import();
	}
	
        $self->add_template_params({
            page_title => 'Импорт товаров и категорий',
            center_block => [
                fw_view->new('admin', 'products_import.tpl')->execute()
            ]
        });
        
    }
}

1;