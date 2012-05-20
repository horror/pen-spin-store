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
    
    sub get_card_item{
        my($self, $cond) = @_;
	
	my ($item_info) = @{$self->fw_database_handler->select_and_fetchall_arrayhashesref(
            'orders_products_href', '*', $cond
        )};
	
        return $item_info;
    }
    
    sub get_card_item_by_id {
        my($self, $item_id) = @_;
	
        return $self->get_card_item({id => $item_id});
    }
    
    sub get_card_item_by_prod_id {
        my($self, $order_id, $prod_id) = @_;
	
        return $self->get_card_item({order_id => $order_id, product_id => $prod_id});
    }
    
    sub get_orders_count {
        my ($self, $filter) = @_;
	
        return $self->fw_database_handler->select_num_rows('orders', $filter);
    }
    
    sub get_user_orders_count {
        my ($self, $user_id) = @_;
	
        return $self->get_orders_count({user_id => $user_id});
    }
    
    sub get_orders_jbgrid_format_calls {
        my($self, $user_id, $filter, $order, $limit, $start) = @_;
	
	@{$filter->{-and}} = (@{$filter->{-and}}, {user_id => $user_id}) if $user_id;
	
	my($stmt_w, @bind) = $self->fw_database_handler->get_where($filter, $order, $limit, $start);
	
	my $stmt = "SELECT o.id, u.login, o.products_cnt, o.total_price, o.status, o.address, o.geogr_coords
	    FROM ps_orders o
	    INNER JOIN ps_users u on o.user_id = u.id
	    $stmt_w";
	
        return $self->fw_database_handler->select_and_fetchall_array_for_jsGrid_without_abstract($stmt, \@bind); 
    }
    
    sub get_all_orders_jbgrid_format_calls {
        my($self, $filter, $order, $limit, $start) = @_;
	    
	return $self->get_orders_jbgrid_format_calls(0, $filter, $order, $limit, $start);
    }
    
    sub get_user_orders_jbgrid_format_calls {
        my($self, $user_id, $filter, $order, $limit, $start) = @_;
	    
	return $self->get_orders_jbgrid_format_calls($user_id, $filter, $order, $limit, $start);
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
	
	my $card_item_info = $self->get_card_item_by_prod_id($card_id, $prod_id);
	
	if(defined $card_item_info) {
	    $self->change_card_item_cnt($user_id, $card_item_info->{id}, $card_item_info->{products_count} + $prod_cnt);
	}
	else {
	    my $fields = {
		order_id => $card_id,
		product_id => $prod_id,
		products_count => $prod_cnt,
		price_per_one => $prod_price
	    };
	    
	    $self->fw_database_handler->insert('orders_products_href', $fields);
	
	    $self->change_order_total_and_prod_cnt(
		$card_id,
		($prod_price * $prod_cnt),
		$prod_cnt
	    );
	}
    }
    
    sub change_card_item_cnt {
        my($self, $user_id, $card_item_id, $card_item_cnt) = @_;
	
	my $card_item_info = $self->get_card_item_by_id($card_item_id);
	
	if ($self->get_card_id($user_id) != $card_item_info->{'order_id'}) {
	    return;
	}
	
	$self->fw_database_handler->update(
	    'orders_products_href',
	    {products_count => $card_item_cnt},
	    {id => $card_item_id}
	);
	
	$self->change_order_total_and_prod_cnt(
	    $card_item_info->{order_id},
	    $card_item_info->{price_per_one} * ($card_item_cnt - $card_item_info->{products_count}),
	    $card_item_cnt - $card_item_info->{products_count}
	);
    }
    
    sub delete_card_item {
        my($self, $user_id, $card_item_id) = @_;
	
	my $card_item_info = $self->get_card_item_by_id($card_item_id);
	
	if ($self->get_card_id($user_id) != $card_item_info->{'order_id'}) {
	    return;
	}
	
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
    
    sub get_order_items_count {
        my($self, $order_id) = @_;
	
        return $self->fw_database_handler
	    ->select_num_rows('orders_products_href', {order_id => $order_id});
    }
    
    sub get_order_items_jbgrid_format_calls {
        my($self, $order_id, $order, $limit, $start) = @_;
	
	my($stmt_w, @bind) = $self->fw_database_handler->get_where({order_id => $order_id}, $order, $limit, $start);
	
        my $stmt = "SELECT o.id, o.product_id, p.image, p.name, o.products_count, o.price_per_one
	    FROM ps_orders_products_href o
	    INNER JOIN ps_products p on o.product_id = p.id
	    $stmt_w";
	
        return $self->fw_database_handler
	    ->select_and_fetchall_array_for_jsGrid_without_abstract(
	        $stmt,
		\@bind
	    );   
    }
    
    sub change_order_status {
        my($self, $order_id, $status) = @_;
	
	$self->fw_database_handler->update('orders', {status => $status},{id => $order_id});
    }
    
    sub change_order_status_add_address_coords {
        my($self, $order_id, $status, $address, $geogr_coords) = @_;
	
	$self->fw_database_handler->update('orders', {status => $status, address => $address, geogr_coords => $geogr_coords}, {id => $order_id});
    }
    
    sub delete_order {
        my($self, $order_id) = @_;
	
	$self->fw_database_handler->delete('orders', {id => $order_id});
	
	#все товары относящиеся к этому заказу тоже стираем
	$self->fw_database_handler->delete(
	    'orders_products_href',
	    {order_id => $order_id}
	);
    }
    
    sub get_order_items_count_by_user_id {
        my($self, $user_id) = @_;
	return $self->get_order_items_count($self->get_card_id($user_id));
    }
    
    sub get_order_items_jbgrid_format_calls_by_user_id {
        my($self, $user_id, $order, $limit, $start) = @_;
	return $self->get_order_items_jbgrid_format_calls(
	    $self->get_card_id($user_id), $order, $limit, $start
	);
    }
    
    sub change_order_status_by_user_id {
        my($self, $user_id, $status) = @_;
	$self->change_order_status($self->get_card_id($user_id), $status);
    }
    
    sub change_order_status_add_address_coords_by_user_id {
        my($self, $user_id, $status, $address, $geogr_coords) = @_;
	$self->change_order_status_add_address_coords($self->get_card_id($user_id), $status, $address, $geogr_coords);
    }
    
    sub delete_order_by_user_id {
        my($self, $user_id) = @_;
	$self->delete_order($self->get_card_id($user_id));
    }
    
    sub merge_carts {
        my($self, $anon_id, $user_id) = @_;
	
	$self->delete_order_by_user_id($user_id);
	
	$self->fw_database_handler->update(
	    'orders',
	    {user_id => $user_id},
	    {user_id => $anon_id}
	);
    }
}

1;