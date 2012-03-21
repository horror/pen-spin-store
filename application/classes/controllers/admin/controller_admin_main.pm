package controller_admin_main; {
    use base controller_base_admin;
    use model_stats;
    use strict;
    use utf8;
  
    sub new {
	my ($class, $args, $cookies) = @_;
	my $self = controller_base_admin::new($class, $args, $cookies);
	return $self;
    }
  
    sub action_stats {
	my $self = shift;
	my @stats = model_stats->new($self->database_handler(), $self->lang())->get_stats();
	
	$self->add_template_params({
	    page_title => $self->lang->ADMIN_STATS_PAGE_TITLE,
	    center_block => [
		fw_view->new('admin', 'main_stat.tpl', {
		    stats => @stats
		})->execute()
	    ]
	});
    }
}

1;