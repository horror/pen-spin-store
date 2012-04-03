package controller_cart; {
    use base controller_base_index;
    use folder_config;
    use strict;
    use model_orders;
    use auth;
    use 5.010;
    use utf8;
  
    sub new {
        my ($class, $args, $cookies) = @_;
        my $self = controller_base_index::new($class, $args, $cookies);
	
        return $self;
    }

    sub action_show {
        my $self = shift;
        
        $self->add_template_scripts([
	    APP_JS_PATH . __DM . 'cart_grid.js'
	]);
        
        $self->add_template_params({
            page_title => $self->lang->CART_PAGE_TITLE,
            center_block => [
                fw_view->new('index', 'cart_show.tpl')->execute()
            ]
        });
    }
    
    sub action_check_out {
        my $self = shift;
    
        my $auth = auth->new($self->cookies(), $self->database_handler());
	if (my $user_id = $auth->logged_authorized_user_id()) {
	     model_orders
		->new($self->database_handler(), $self->lang())
		->change_order_status_by_user_id($user_id, 1);
	    $self->add_template_params({
		page_title => $self->lang->CART_PAGE_TITLE,
		center_block => [
		    'Заказ оформлен'
		]
	    });
	}
	else {
	    $self->redirection('registration', 'index');
	}
    }
    
    sub action_erase_cart {
        my $self = shift;
	
        model_orders->new($self->database_handler(), $self->lang())
		->delete_order_by_user_id(
		    auth->new($self->cookies(), $self->database_handler())->logged_user_id()
		);
		
	$self->redirection('cart', 'show');
    }
    
    sub action_set {
        my $self = shift;
	
	given ($self->request->{'oper'}) {
	    when ("del") {$self->action_delete()}
	    when ("edit") {$self->action_edit()}
	    when ("add") {$self->action_add()}
	}
	
        $self->redirection('products', 'show');
    }
    
    sub action_add {
        my $self = shift;
	
	my $product_cnt = model_orders
	    ->new($self->database_handler(), $self->lang())
	    ->add_product_to_cart(
	        auth->new($self->cookies(), $self->database_handler())
		    ->logged_user_id(),
		$self->request->{'product_id'},
		$self->request->{'product_count'},
		$self->request->{'product_price'},
	    );
    }
    
    sub action_edit {
        my $self = shift;
	
    }
 
    sub action_import {
        my $self = shift;
	
    }
}

1;