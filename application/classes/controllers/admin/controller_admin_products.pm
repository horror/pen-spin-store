package controller_admin_products; {
    use base controller_base_admin;
    use folder_config;
    use products_importer;
    use strict;
    use model_products;
    use validation;
    use auth;
    use 5.010;
    use utf8;
  
    sub new {
        my ($class, $args, $cookies, $files) = @_;
        my $self = controller_base_admin::new($class, $args, $cookies, $files);
	
	my $widget_menu = widget_horz_menu->new($args, $cookies, $self->database_handler());
        
        my $uri_pattern = "index.pl?controller=admin_%s&action=%s";
    
        $widget_menu->set_items([
            {
                uri => sprintf($uri_pattern, 'products', 'show'),
                caption => $self->lang->PRODUCTS_MENU_ITEM,
            },
            {
                uri => sprintf($uri_pattern, 'products', 'import'),
                caption => $self->lang->IMPORT_MENU_ITEM,
            },
        ]);
	
	$self->add_template_params({center_block_right_section => $widget_menu->execute()});
	
        return $self;
    }

    sub action_show {
        my $self = shift;
        
        $self->add_template_scripts([
	    APP_JS_PATH . __DM . 'products_grid.js',
	    APP_JS_PATH . __DM . 'products_grid_hide_cart_functions.js',
	    APP_JS_PATH . __DM . 'category_tree.js',
	]);
        
        $self->add_template_params({
            page_title => $self->lang->PRODUCTS_PAGE_TITLE,
            center_block => [
                fw_view->new('common', 'products_show.tpl')->execute()
            ]
        });
    }
    
    sub action_set {
        my $self = shift;
	
        my $auth = auth->new($self->cookies(), $self->database_handler());
	if (not $auth->logged_admin_id()) {
	    return;
	}
	
	given ($self->request->{'oper'}) {
	    when ("del") {$self->action_delete()}
	    when ("edit") {$self->action_edit()}
	    when ("add") {$self->action_add()}
	}
	
        $self->redirection('admin_products', 'show');
    }
    
    sub action_add {
        my $self = shift;
	
	my $product_info = validation->new($self->request(), $self->lang())
	    ->validate_product_form();
	    
        unless (ref $product_info eq "HASH") {
	    return;
	}
	$product_info->{image} = '';
	my $file_names = [];
        if (@{$self->files()}) {
	    $file_names = $self->store_files_and_get_names(
		$self->files(), APP_PRODUCTS_IMG_PATH, '.jpg');
			
	    $product_info->{image} = $file_names->[0];
	}
	
	my $prod_id = model_products->new($self->database_handler(), $self->lang())
	    ->add_product_and_get_id($product_info, $self->request->{'cat_id'});
	    
	if (@$file_names) {
	    model_products->new($self->database_handler(), $self->lang())
		->add_product_images_by_id($prod_id, $file_names);
	}
	    
	
    }
    
    sub action_edit {
        my $self = shift;
	
	my $product_info = validation->new($self->request(), $self->lang())
	    ->validate_product_form();
	    
        unless (ref $product_info eq "HASH") {
	    return;
	}
	
	$product_info->{image} = '';
	my $file_names = [];
	
        if (@{$self->files()}) {
	    my $prod_images = model_products->new($self->database_handler(), $self->lang())
	        ->get_product_images_by_id($self->request->{'id'});
		
	    $self->restore_files($prod_images, APP_PRODUCTS_IMG_PATH);
	    
	    model_products->new($self->database_handler(), $self->lang())
		->delete_product_images_by_id($self->request->{'id'});
	    
	    $file_names = $self->store_files_and_get_names(
		$self->files(), APP_PRODUCTS_IMG_PATH, '.jpg');
			
	    $product_info->{image} = $file_names->[0];
	}
	
	model_products->new($self->database_handler(), $self->lang())
	    ->edit_product($product_info, $self->request->{'id'});
	    
	if (@$file_names) {
	    model_products->new($self->database_handler(), $self->lang())
		->add_product_images_by_id($self->request->{'id'}, $file_names);
	}
    }
    
    sub action_delete {
        my $self = shift;
        
	model_products->new($self->database_handler(), $self->lang())
	    ->delete_product($self->request->{'id'});
	    
	my $prod_images = model_products->new($self->database_handler(), $self->lang())
	        ->get_product_images_by_id($self->request->{'id'});
		
        $self->restore_files($prod_images, APP_PRODUCTS_IMG_PATH);
	
	model_products->new($self->database_handler(), $self->lang())
	    ->delete_product_images_by_id($self->request->{'id'});
    }
 
    sub action_import {
        my $self = shift;
	
        if ($self->request->{submit}) {
	    products_importer->new($self->database_handler())->penwish_import();
	}
	
        $self->add_template_params({
            page_title => $self->lang->IMPORT_PAGE_TITLE,
            center_block => [
                fw_view->new('admin', 'products_import.tpl')->execute()
            ]
        });
        
    }
}

1;