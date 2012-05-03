package model_products; {
    use base fw_model;
    use utf8;
    
    sub new {
        my($class, $dbh, $lang) = @_;
        
        my $self = fw_model::new($class, $dbh, $lang);
            
        return $self;
    }
    
    sub maintain_category_path_consistency {
        my($self, $category_not_full_path) = @_;
        my $category_id = $self->fw_database_handler->last_inserted_id('categories');
        $self->fw_database_handler->update('categories', {path => "$category_not_full_path$category_id."}, { id => $category_id });
    }
    
    sub get_path_by_category_id {
        my($self, $category_id) = @_;
        my($category) = @{$self->fw_database_handler->select_and_fetchall_arrayhashesref(
            'categories', 'path', {id => $category_id}
        )};
        return $category->{path};
    }
    
    sub get_products_cnt_by_category_id {
        my ($self, $category_id) = @_;
        
        my $stmt = "SELECT count(*) FROM ps_products WHERE
            path like concat((SELECT path FROM ps_categories WHERE id = ?), '%')";
        return $self->fw_database_handler->select_num_rows_without_abstract($stmt, [$category_id]); 
    }
    
    sub get_products_by_category_id {
        my($self, $category_id, $order_direction, $order_field, $limit, $start) = @_;
        my $stmt = "SELECT id, image, name, description, price FROM ps_products WHERE
           path like concat((SELECT path FROM ps_categories WHERE id = ?), '%')
           ORDER BY $order_field $order_direction LIMIT $start, $limit";
        return $self->fw_database_handler->select_and_fetchall_array_for_jsGrid_without_abstract($stmt, [$category_id]);   
    }
    
    sub get_products {
        my($self, $filters, $order, $limit, $start) = @_;
        my @fields = qw[id image name description price];
        return $self->fw_database_handler->select_and_fetchall_array_for_jsGrid(
            'products', \@fields, $filters, $order, $limit, $start
        );
    }
    
    sub get_products_for_comparison {
        my($self, $products_id) = @_;
        my @fields = qw[id image name description price];
        return $self->fw_database_handler->select_and_fetchall_arrayhashesref(
            'products', \@fields, {id => { -in => $products_id }}
        );
    }
    
    sub get_products_cnt {
        my($self, $filters) = @_;
        my @fields = qw[id image name description price];
        return $self->fw_database_handler->select_num_rows (
            'products', $filters
        );
    }
    
    sub get_category_tree_jbgrid_format_calls {
        my $self = shift;
        my $categories = $self->fw_database_handler->select_and_fetchall_arrayhashesref (
		    'categories', '*', {}, {-asc => 'path'} #Вот попробуй догадайся!!
		);
        my @result;
        my $cnt = 0;
        my $old_lvl;
        my $level;
        foreach (@$categories) {
            $level = (($_->{path} =~ tr/\.//) - 1);
            if ($cnt > 0 && $level <= $old_lvl) {
                $result[-1]->{cell}->[4] = 'true';
            }
            push @result, {cell => [$_->{id}, $_->{name}, $level, $_->{parent_id}, 'false', 'false', 'true'],
                id => $_->{id}};
            $old_lvl = $level;
            $cnt++;
	}
        
        if ($cnt > 0 && $level <= $old_lvl) {
            $result[-1]->{cell}->[4] = 'true';
        }
        
        return \@result;
    }
    
    sub get_product_info_by_id {
        my($self, $product_id) = @_;
        
        return $self->fw_database_handler->select_and_fetchrow_hashref(
                'products', 'id', '*', {id => $product_id});
    }
    
    sub add_product_and_get_id {
        my($self, $fields, $category_id, $path) = @_;
        if(!defined $path) {
            $path = $self->get_path_by_category_id($category_id); 
        }
        $fields->{path} = $path;
        $fields->{category_id} = $category_id;
        
        $self->fw_database_handler->insert('products', $fields);
        
        return $self->fw_database_handler->last_inserted_id('products');
    }
    
    sub get_product_images_by_id {
        my($self, $product_id) = @_;
        my $result = $self->
            fw_database_handler->select_and_fetchall_arrayhashesref(
                'product_images', ['name'], {product_id => $product_id});
        my @arr = map $_->{name}, @$result;
            
        return \@arr;
        
    }
    
    sub add_product_images_by_id {
        my($self, $product_id, $images) = @_;
        my $fields = {};
        for my $img (@$images) {
            $fields = {product_id => $product_id, name => $img};
            $self->fw_database_handler->insert('product_images', $fields);
        }
    }
    
    sub delete_product_images_by_id {
        my($self, $product_id) = @_;
        $self->fw_database_handler->delete('product_images', {product_id => $product_id});
    }
    
    sub edit_product {
        my($self, $fields, $product_id) = @_;
        delete $fields->{image} if $fields->{image} eq '';
        $self->fw_database_handler->update('products', $fields, { id => $product_id });
    }
    
    sub delete_product {
        my($self, $product_id) = @_;
        $self->fw_database_handler->delete('products', { id => $product_id });
    }
    
    sub add_category {
        my($self, $parent_id, $name, $path, $id) = @_;
        if(!defined $path) {
            $path = $self->get_path_by_category_id($parent_id);      
        }
        $fields->{path} = $path;
        $fields->{parent_id} = $parent_id;
        $fields->{name} = $name;
        $fields->{id} = $id;
        $self->fw_database_handler->insert('categories', $fields);
        $self->maintain_category_path_consistency($path) if !defined $path;
    }
    
    sub edit_category {
        my($self, $id, $name) = @_;
        $fields->{name} = $name;
        $self->fw_database_handler->update('categories', $fields, { id => $id });
    }
    
    sub delete_category {
        my($self, $id) = @_;
        $self->fw_database_handler->delete('categories', { id => $product_id });
    }
    
    sub add_rating {
        my($self, $rate_info) = @_;
        
        $self->fw_database_handler->insert('product_rating', $rate_info);
    }
    
    sub show_rating {
        my($self, $product_id) = @_;
        
        return $self->fw_database_handler->select_and_fetchrow_hashref('product_rating', 'product_id', ['product_id', 'AVG(rating)'], {product_id => $product_id, });
    }
}

1;