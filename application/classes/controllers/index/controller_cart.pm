package controller_cart; {
    use base controller_base_index;
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
        
#        $self->add_template_scripts([
#	    APP_JS_PATH . __DM . 'products_grid.js',
#	    APP_JS_PATH . __DM . 'category_tree.js'
#	]);
#        
#        $self->add_template_params({
#            page_title => $self->lang->PRODUCTS_PAGE_TITLE,
#            center_block => [
#                fw_view->new('common', 'products_show.tpl')->execute()
#            ]
#        });
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