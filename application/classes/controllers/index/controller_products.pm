package controller_products; {
    use base controller_base_index;
    use folder_config;
    use model_products;
    use widget_discussion_displayer;
    use widget_product_rating;
    use strict;
    use auth;
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
	    APP_JS_PATH . __DM . 'category_tree.js',
	    APP_JS_PATH . __DM . 'comparison.js'
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
	
	$self->add_template_scripts([
	    APP_JS_TEXT_EDITOR_PATH . __DM . 'jquery.markitup.js',
	    APP_JS_TEXT_EDITOR_PATH . __DM . 'set.js',
	    APP_JS_PATH . __DM . 'comment_form.js',
	    APP_JS_PATH . __DM . 'jquery.tmpl.js',
	    APP_JS_PATH . __DM . 'comment_display.js',
	    APP_JS_PATH . __DM . 'jquery.rating.js',
	    APP_JS_PATH . __DM . 'product_rating.js',
	]);
	
	$self->add_template_styles([
	    APP_CSS_PATH . __DM . 'style_markitup_skins.css',
	    APP_CSS_PATH . __DM . 'style_murkitup!.css',
	    APP_CSS_PATH . __DM . 'style_rating.css',
	]);
	
	my $auth = auth->new($self->cookies(), $self->database_handler());
	
	my $m_products = model_products->new($self->database_handler(), $self->lang());
	
	my $prod_images = $m_products->get_product_images_by_id($self->request->{'id'});
	my $prod_info = $m_products->get_product_info_by_id($self->request->{'id'});
	my $prod_rating = $m_products->show_rating($self->request->{'id'});
	my $already_rated = $m_products->user_already_rate($auth->logged_authorized_user_id());
	    
	my $w_discuss = widget_discussion_displayer->new(
	    $self->request(), $self->cookies(), $self->database_handler(),
	    $self->request->{'id'}, $auth->logged_authorized_user_id()
	);
	
	my $path = ($self->request->{'comment_id'}) ?
	    $self->request->{'comment_path'}.
	    add_leading_zeros($self->request->{'comment_id'}).'.'
	    : $self->request->{'comment_path'};
	    
	my $expand_lvl = ($self->request->{'expand_radical'} eq 'manual') ? $self->request->{'expand_level'} :
	    ((defined $self->request->{'expand_radical'}) ? $self->request->{'expand_radical'} : 3);
	
	$w_discuss->extract_comments(
	    $self->request->{'comment_id'},
	    $path,
	    $auth->logged_admin_id(),
	    $expand_lvl,
	);
	
	my $w_product_rating_exec;
	if ($auth->logged_authorized_user_id() && !$already_rated) {
	    my $w_product_rating = widget_product_rating->new($self->request(), $self->cookies(), $self->database_handler(), $self->request->{'id'});
	    $w_product_rating_exec = $w_product_rating->execute();
	}
	
        $self->add_template_params({
            page_title => $self->lang->PRODUCTS_DETAILES_PAGE_TITLE,
            center_block => [
                fw_view->new('index', 'product_detailes.tpl', {
		    product_info => $prod_info,
		    product_images => $prod_images,
		    product_rating => $prod_rating->{'AVG(rating)'},
		})->execute(),
		$w_product_rating_exec,
		$w_discuss->execute(),
            ]
        });
    }
    
    sub action_add_comment {
	my $self = shift;
	
	my $user_id = auth->new($self->cookies(), $self->database_handler())
	    ->logged_authorized_user_id();
	    
	widget_discussion_comment_form->new(
	    $self->request(), $self->cookies(), $self->database_handler()
	)->add_comment($user_id)
	if $user_id;
    }
    
    sub action_del_comment {
	my $self = shift;

	widget_discussion_comment_form->new(
	    $self->request(), $self->cookies(), $self->database_handler()
	)->del_comment() if auth->new($self->cookies(), $self->database_handler())
	    ->logged_admin_id();
    }
 
    sub add_leading_zeros {
	my $x = shift;
	return sprintf "%06d", $x
    }
    
    sub action_class {
	my $self = shift;
    
	widget_product_rating->new($self->request(), $self->cookies(), $self->database_handler())
	    ->class_prod(
		auth->new($self->cookies(), $self->database_handler())
		    ->logged_user_id()
	    );
    }
}

1;