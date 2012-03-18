package validation; {
    use Class::InsideOut qw/:std/;
    use strict;
    use utf8;
  
    public data => my %data;
  
    sub new {
        my($class, $data) = @_;
        my $self = bless {}, $class;
        
        register($self); 
            
        $self->data($data);
        
        return $self;
    }
    
    sub validate_user_form {
        my ($self, $sign_fields) = @_;
        
        my %user_info;
        my @user_values = @{$self->data()}{@$sign_fields};
        
        @user_info{@$sign_fields} = @user_values;
	
	my @messages;
	push @messages, 'Заполнены не все поля' if grep /^$/, values %user_info;
        push @messages, 'Пароли не совпадают' if defined $user_info{confim_password} && ($user_info{confim_password} ne $user_info{password});

        delete($user_info{confim_password});
	
	return (@messages) ? \@messages : \%user_info;
    }
    
    sub validate_registration_user_form {
        my $self = shift;
        my @sign_fields  = qw\name login email password confim_password\;
        return $self->validate_user_form(\@sign_fields);
    }
    
    sub validate_user_card_form {
        my $self = shift;
        my @sign_fields  = qw\name login email password role\;
        return $self->validate_user_form(\@sign_fields);
    }
    
    sub validate_product_form {
        my $self = shift;
	my @sign_fields  = qw\image name description price\;
	
	my %product_info;
        my @product_values = @{$self->data()}{@sign_fields};
        
        @product_info{@sign_fields} = @product_values;
	
	my @messages;
	push @messages, 'Заполнены не все поля' if grep /^$/, values %product_info;
	
	return (@messages) ? \@messages : \%product_info;
    }
    

}

1;