package model_orders; {
    use base fw_model;
    use utf8;
    
    sub new {
        my($class, $dbh, $lang) = @_;
        
        my $self = fw_model::new($class, $dbh, $lang);
            
        return $self;
    }
    
    sub get_card_id {
        my($self, $user_id) = @_;
	
        my ($not_completed_order) = @{$self->fw_database_handler->select_and_fetchall_arrayhashesref(
            'orders', 'id', {user_id => $user_id, status => 0}
        )};
	
	return $not_completed_order->{id};
    }
    
    sub get_products_cart_cnt {
        my($self, $user_id) = @_;

	my ($not_completed_order) = @{$self->fw_database_handler->select_and_fetchall_arrayhashesref(
            'orders', 'products_cnt', {user_id => $user_id, status => 0}
        )};

	return ($not_completed_order) ? $not_completed_order->{products_cnt} : 0;
    }
    
    sub get_card_item_by_id {
        my($self, $item_id) = @_;
	
	my ($item_info) = @{$self->fw_database_handler->select_and_fetchall_arrayhashesref(
            'orders_products_href', '*', {id => $item_id}
        )};
	
        return $item_info;
    }
    
    sub get_card_items_count {
        my($self, $user_id) = @_;
	
	my $card_id = $self->get_card_id($user_id);
	
        return $self->fw_database_handler
	    ->select_num_rows('orders', {id => $card_id});
    }
    
    sub get_card_items_jbgrid_format_calls {
        my($self, $user_id, $order_direction, $order_field, $limit, $start) = @_;
	
	my $card_id = $self->get_card_id($user_id);
	
        my $stmt = "SELECT o.id, o.product_id, p.image, p.name, o.products_count, o.total_price
	    FROM ps_orders_products_href o
	    INNER JOIN ps_products p on o.product_id = p.id
	    WHERE order_id = $card_id
            ORDER BY $order_field $order_direction LIMIT $start, $limit";
	    
        return $self->fw_database_handler
	    ->select_and_fetchall_array_for_jsGrid_without_abstract(
	        $stmt
	    );   
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
    
    sub change_order_total_and_prod_cnt {
        my($self, $order_id, $inc_total, $inc_cnt) = @_;
	
	my $fields = {
	    products_cnt => \["products_cnt + ?", $inc_cnt],
	    total_price => \["total_price + ?", $inc_total],
	};
	
	$self->fw_database_handler->update('orders', $fields, { id => $order_id });
    }
    
    sub add_product_to_cart {
        my($self, $user_id, $prod_id, $prod_cnt, $prod_price) = @_;
	
	my $card_id = $self->get_card_id($user_id);
	
	if (!$card_id) {
	    $card_id = $self->add_cart_and_get_id($user_id);
	};
	
	my $fields = {
	    order_id => $card_id,
	    product_id => $prod_id,
	    products_count => $prod_cnt,
	    total_price => ($prod_price * $prod_cnt)
	};
	
	$self->fw_database_handler->insert('orders_products_href', $fields);
	$self->change_order_total_and_prod_cnt(
	    $card_id,
	    ($prod_price * $prod_cnt),
	    $prod_cnt
	);
    }
    
    sub change_card_item_cnt {
        my($self, $card_item_id, $card_item_cnt) = @_;
	
	my $card_item_info = $self->get_card_item_by_id($card_item_id);
	
	my $price_one_prod = $card_item_info->{total_price} / $card_item_info->{products_count};
	
	$self->fw_database_handler->update(
	    'orders_products_href',
	    {
	        products_count => $card_item_cnt,
	        total_price => ($price_one_prod * $card_item_cnt)
	    },
	    {id => $card_item_id}
	);
	
	
	
	$self->change_order_total_and_prod_cnt(
	    $card_item_info->{order_id},
	    $price_one_prod * $card_item_cnt - $card_item_info->{total_price},
	    $card_item_cnt - $card_item_info->{products_count}
	);
    }
    
    sub delete_card_item {
        my($self, $card_item_id) = @_;
	
	my $card_item_info = $self->get_card_item_by_id($card_item_id);
	
	$self->fw_database_handler->delete(
	    'orders_products_href',
	    {id => $card_item_id}
	);
	
	$self->change_order_total_and_prod_cnt(
	    $card_item_info->{order_id},
	    -$card_item_info->{total_price},
	    -$card_item_info->{products_count}
	);
    }
}

1;