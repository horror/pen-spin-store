package model_orders; {
    use base fw_model;
    use utf8;
    
    sub new {
        my($class, $dbh, $lang) = @_;
        
        my $self = fw_model::new($class, $dbh, $lang);
            
        return $self;
    }
    
    sub get_products_cart_cnt {
        my($self, $user_id) = @_;
	
	my ($not_completed_order) = @{$self->fw_database_handler->select_and_fetchall_arrayhashesref(
            'orders', 'products_cnt', {user_id => $user_id, status => 0}
        )};
	
	return ($not_completed_order) ? $not_completed_order->{products_cnt} : 0;
    }
    
    sub add_cart_and_get_id {
        my($self, $user_id) = @_;
	
	my $fields = {
	    user_id => $user_id,
	    status => 0,
	    total_price => 0,
	};
	
	$self->fw_database_handler->insert('orders', $fields);
	
	return $self->fw_database_handler->last_inserted_id('orders');
    }
    
    sub incrase_order_total_and_prod_cnt {
        my($self, $order_id, $inc_total, $inc_cnt) = @_;
	
	my $fields = {
	    products_cnt => \["products_cnt + ?", $inc_cnt],
	    total_price => \["total_price + ?", $inc_total],
	};
	
	$self->fw_database_handler->update('orders', $fields, { id => $order_id });
    }
    
    sub add_product_to_cart {
        my($self, $user_id, $prod_id, $prod_cnt, $prod_price) = @_;
	
	my ($not_completed_order) = @{$self->fw_database_handler->select_and_fetchall_arrayhashesref(
            'orders', 'id', {user_id => $user_id, status => 0}
        )};
	
	if (!$not_completed_order->{id}) {
	    $not_completed_order->{id} = $self->add_cart_and_get_id($user_id);
	};
	
	my $fields = {
	    order_id => $not_completed_order->{id},
	    product_id => $prod_id,
	    product_count => $prod_cnt,
	    total_price => ($prod_price * $prod_cnt)
	};
	
	$self->fw_database_handler->insert('orders_products_href', $fields);
	$self->incrase_order_total_and_prod_cnt(
	    $not_completed_order->{id},
	    ($prod_price * $prod_cnt),
	    $prod_cnt
	);
    }
}

1;