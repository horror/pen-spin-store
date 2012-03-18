package widget_horz_menu; {
    use base fw_controller;
    use strict;
    
    sub new {
	my ($class, $args, $cookies, $dbh) = @_;
	my $self = fw_controller::new($class, $args, $cookies, $dbh);
	$self->template_settings('widgets', 'widget_horz_menu.tpl');
	return $self;
    }
    
    sub set_items {
	my($self, $menu_items) = @_;
	
	$self->add_template_params({menu_items => $menu_items});
    }
}

1;