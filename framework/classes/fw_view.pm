package fw_view; {
  use Class::InsideOut qw/:std/;
  use Template;
  use folder_config;
  
  public template_handler => my %template_handler;
  public template_name => my %template_name;
  public template_params => my %template_params;
  public template_styles => my %template_styles;
  public template_scripts => my %template_scripts;
  
  sub new {
    my($class, $type, $name, $params, $styles, $scripts) = @_;
    my $self = bless {}, $class;

    register($self); 
    $self->template_handler(
        new Template({
            INCLUDE_PATH => (APP_VIEWS_PATH . __DM . $type), #Путь к каталогу с шаблонами
            DEFAULT_ENCODING => 'utf-8'
        })
    );
    
    $self->template_name($name);
    $self->template_params($params);
    $self->template_styles($styles);
    $self->template_scripts($scripts);
    
    return $self;
  }
  
  sub execute {
    my $self = shift;
     
    my %tpl_params = %{$self->template_params()} if $self->template_params();
    $tpl_params{styles} = $self->template_styles();
    $tpl_params{scripts} = $self->template_scripts();
    my $output = '';
    $self->template_handler->process($self->template_name(), \%tpl_params, \$output);
    
    return $output;
  }
}

1;