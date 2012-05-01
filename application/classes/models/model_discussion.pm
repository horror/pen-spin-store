package model_discussion; {
    use base fw_model;
    use Class::InsideOut qw/:std/;
    use utf8;
    
    public db => my %db;
    
    sub new {
        my($class, $dbh, $lang) = @_;
        
        my $self = fw_model::new($class, $dbh, $lang);
        $self->db($self->fw_database_handler());   
        return $self;
    }
    
    sub get_prod_coments {
	my ($self, $prod_id, $show_level, $comment_path, $comment_id) = @_;
	
	my $bind = [$show_level - 1, $comment_path];
	my $where = ($comment_id) ? "d.id = $comment_id" : "d.product_id = ? and (d.level < ? or d.path LIKE ?)";
	
	@$bind = (@$bind, $prod_id, $show_level, $comment_path . '%') unless $comment_id;
	my $stmt = "SELECT DISTINCT d.id, u.name as user_name, d.content, d.time, d.path, d.level, (d1.id and d.level = ? and d.path <> ?) as has_child, d.deleted
	    FROM ps_discussion d
	    INNER JOIN ps_users u on u.id = d.user_id
	    LEFT JOIN ps_discussion d1 on d.id = d1.parent_id
	    WHERE $where
	    ORDER BY concat(d.path, LPAD(d.id, 6, '0'))";
	
	my $response = $self->db->select_and_fetchall_arrayhashesref_without_abstract($stmt, $bind);
	return [map {$_->{content} = 'Коментарий удален' if $_->{deleted}; $_;} @$response];
    }
    
    sub add_comment {
	my ($self, $comment) = @_;
	$comment->{path} = '000000.' unless $comment->{path};
	$comment->{level} = ($comment->{path} =~ tr/\.//) - 1;
	$comment->{parent_id} = 0 unless $comment->{parent_id};
	$self->db->insert('discussion', $comment);
    }
    
    sub mark_removed_comment {
	my ($self, $comment_id) = @_;

	$self->db->update('discussion', {deleted => 1}, {id => $comment_id});
    }
}

1;