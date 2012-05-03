package widget_discussion_displayer; {
    use base fw_controller;
    use Class::InsideOut qw/:std/;
    use model_discussion;
    use widget_discussion_comment_form;
    use strict;
    
    public comment_form_need => my %comment_form_need;
    public prod_id => my %prod_id;
    public form => my %form;
    
    sub new {
        my ($class, $args, $cookies, $dbh, $product_id, $comment_form_need) = @_;
        my $self = fw_controller::new($class, $args, $cookies, {}, $dbh);
	
        $self->template_settings('widgets', 'widget_discussion_displayer.tpl', {
	    product_id => $product_id,
	});
	
	$self->prod_id($product_id);
	$self->comment_form_need($comment_form_need);
	$self->form(widget_discussion_comment_form->new($args, $cookies, $dbh, $product_id)) if $comment_form_need;
	
        return $self;
    }
    
    sub	extract_comments {
	my ($self, $comment_id, $comment_path, $admin_role, $expand_lvl) = @_;
	
	$self->form->add_template_params({
	    comment_id => $comment_id,
	    comment_path => $comment_path
	}) if $self->comment_form_need();
	
	$comment_path = -1 if $comment_id || !$comment_path;
	my $comments = ($expand_lvl) ? model_discussion->new($self->database_handler())
	    ->get_prod_coments($self->prod_id(), $expand_lvl, $comment_path, $comment_id) : [];
	
	$self->add_template_params({
	    comments => $comments,
	    comment_cnt => scalar(@$comments),
	    admin_role => $admin_role,
	    expand_level => $expand_lvl,
	});
	
    }
    
    
    sub after {
	my $self = shift;
	$self->add_template_params({comment_form => $self->form->execute()}) if $self->comment_form_need();
    }
}

1;