package controller_comparison; {
    use MIME::Base64 qw(decode_base64);
    use base controller_base_index;
    use folder_config;
    use model_products;
    use strict;
    use JSON;
    use utf8;
  
    sub new {
        my ($class, $args, $cookies) = @_;
        my $self = controller_base_index::new($class, $args, $cookies);
        return $self;
    }

    sub action_show {
        my $self = shift;
        
        $self->add_template_scripts([
	    APP_JS_PATH . __DM . 'comparison.js'
	]);
        
        my $products = 0;
        my $prods_id = $self->cookies->{comparison_prod_ids}->{value}->[0];
	if (defined $prods_id) {
	    $prods_id = decode_base64($prods_id);
	    $prods_id = JSON->new->utf8->decode($prods_id) if $prods_id;
            $products = model_products->new($self->database_handler(), $self->lang())
                    ->get_products_for_comparison($prods_id);
        }
        $self->add_template_params({
            page_title => $self->lang->COMPARISON_PAGE_TITLE,
            center_block => [
                fw_view->new('index', 'comparison_show.tpl', {
                    products => $products,
                })->execute()
            ]
        });
    }
    
 
}

1;