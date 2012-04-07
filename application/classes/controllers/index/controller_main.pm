package controller_main; {
  use base controller_base_index;
  use Class::InsideOut qw/:std/;
  use model_users;
  use strict;
  use utf8;
  use auth;

  sub new {
    my ($class, $args, $cookies) = @_;
    my $self = controller_base_index::new($class, $args, $cookies);
    return $self;
  }

  sub action_index {
    my $self = shift;
    
    my $auth = auth->new($self->cookies(), $self->database_handler()); 
    my $user_id = $auth->logged_user_id();

    $self->add_template_params({
        page_title => $self->lang->INDEX_MAIN_PAGE_TITLE,
    });
  }
}

1;