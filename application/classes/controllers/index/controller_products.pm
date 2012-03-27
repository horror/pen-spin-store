package controller_products; {
    use base controller_base_index;
    use folder_config;
    use model_products;
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
            page_title => $self->lang->PRODUCTS_PAGE_TITLE,
            center_block => [
                fw_view->new('common', 'products_show.tpl')->execute()
            ]
        });
    }
    
    sub action_detailes {
        my $self = shift;
        
	my $prod_images = model_products->new($self->database_handler(), $self->lang())
	        ->get_product_images_by_id($self->request->{'id'});
	my $prod_info = model_products->new($self->database_handler(), $self->lang())
	        ->get_product_info_by_id($self->request->{'id'});
        $self->add_template_params({
            page_title => $self->lang->PRODUCTS_DETAILES_PAGE_TITLE,
            center_block => [
                fw_view->new('index', 'product_detailes.tpl', {
		    product_info => $prod_info,
		    product_images => $prod_images,
		})->execute()
            ]
        });
    }
    
 
}

1;