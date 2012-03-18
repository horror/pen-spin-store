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
    
    my $user = model_users->new($self->database_handler())->get_user_on_id($user_id);
    
    my $title = ($user_id) ? "Вы залогинены, " . $user->{name} : 'PenSpinStore';
    $self->add_template_params({
        site_name => $title,
        page_title => 'Главная страница',
        center_block => [
            '<p>Добро пожаловать в наш магазин.</p>',
        ]
    });
  }
}

1;