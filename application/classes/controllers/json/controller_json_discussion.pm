package controller_json_discussion; {
    use base fw_controller_json;
    use model_discussion;
    use strict;
    use auth;
    use 5.010;
    use utf8;
     
    sub new {
        my($class, $params, $cookies) = @_;
    
        my $self = fw_controller_json::new($class, $params, $cookies);
	
        return $self;
    }
    
    sub action_get_comments_branch {
	my $self = shift;
	
	my $comments = model_discussion->new($self->database_handler())
	    ->get_comments_branch($self->request->{product_id}, $self->request->{comment_path});
	    
	$self->data($comments);
    }
}

1;