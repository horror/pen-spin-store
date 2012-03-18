package controller_products; {
    use base controller_base_index;
    use folder_config;
    use validation;
    use strict;
    use utf8;
  
    sub new {
        my ($class, $args, $cookies) = @_;
        my $self = controller_base_index::new($class, $args, $cookies);
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
 
}

1;