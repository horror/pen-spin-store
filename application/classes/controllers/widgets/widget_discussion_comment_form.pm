package widget_discussion_comment_form; {
    use base fw_controller;
    use model_discussion;
    use validation;
    use strict;
  
    sub new {
        my ($class, $args, $cookies, $dbh, $product_id) = @_;
        my $self = fw_controller::new($class, $args, $cookies, {}, $dbh);
        $self->template_settings('widgets', 'widget_discussion_comment_form.tpl', {
	    product_id => $product_id,
	});
        return $self;
    }
    
    sub	add_comment {
	my ($self, $user_id) = @_;
	my $comment = validation->new($self->request(), $self->lang())->validate_comment_form();
	$comment->{user_id} = $user_id;
	model_discussion->new($self->database_handler())->add_comment($comment);
	$self->redirection('products', 'detailes', {id => $self->request->{product_id}});
    }
    
    sub del_comment {
	my $self = shift;
	model_discussion->new($self->database_handler())->mark_removed_comment($self->request->{comment_id});
	$self->redirection('products', 'detailes', {id => $self->request->{id}});
    }
    
}

1;