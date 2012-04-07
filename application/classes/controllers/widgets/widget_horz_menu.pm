package widget_horz_menu; {
    use base fw_controller;
    use Class::InsideOut qw/:std/;
    use strict;
    
    public menu_items => my %menu_items;
    
    sub new {
	my ($class, $args, $cookies, $dbh) = @_;
	my $self = fw_controller::new($class, $args, $cookies, {}, $dbh);
	$self->template_settings('widgets', 'widget_horz_menu.tpl');
	return $self;
    }
    
    sub set_items {
	my($self, $menu_items) = @_;
	
	$self->menu_items($menu_items);
    }
    
    sub add_items {
	my($self, $menu_items) = @_;
	my $items = (defined $self->menu_items()) ? [@{$self->menu_items()}, @$menu_items] : @$menu_items;
	$self->menu_items($items);
    }
    
    sub execute {
        my $self = shift;
	$self->add_template_params({menu_items => $self->menu_items()});
	
	return fw_controller::execute($self);
    }
}

1;