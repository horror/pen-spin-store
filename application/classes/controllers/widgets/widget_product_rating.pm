package widget_product_rating; {
    use base fw_controller;
    use model_products;
    use strict;
    
    sub new {
        my ($class, $args, $cookies, $dbh, $product_id) = @_;	
        my $self = fw_controller::new($class, $args, $cookies, {}, $dbh);
	$self->template_settings('widgets', 'widget_product_rating.tpl', {product_id => $product_id});

        return $self;
    }
    
    sub class_prod {
	my ($self, $user_id) = @_;
	
	my %rate_info;
        my @rate_values = @{$self->request()}{qw/product_id rating/};
        push @rate_values, $user_id;
        @rate_info{qw/product_id rating user_id/} = @rate_values;
	
	model_products->new($self->database_handler())->add_rating(\%rate_info);
	
	$self->redirection('products', 'detailes', {id => $self->request->{product_id}});
    }
    
}

1;