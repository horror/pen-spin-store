package validation; {
    use Class::InsideOut qw/:std/;
    use strict;
    use utf8;
  
    public data => my %data;
    public lang => my %lang;
  
    sub new {
        my($class, $data, $lang) = @_;
        my $self = bless {}, $class;
        
        register($self); 
            
        $self->data($data);
	$self->lang($lang);
        
        return $self;
    }
    
    sub validate_user_form {
        my ($self, $sign_fields) = @_;
        
        my %user_info;
        my @user_values = @{$self->data()}{@$sign_fields};
        
        @user_info{@$sign_fields} = @user_values;
	
	my @messages;
	push @messages, $self->lang->EMPTY_FORM_FIELDS_EXISTS_MESSAGE if grep /^$/, values %user_info;
        push @messages, $self->lang->PASS_CONFIRM_ERROR_MESSAGE if defined $user_info{confim_password} && ($user_info{confim_password} ne $user_info{password});

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
	push @messages, $self->lang->EMPTY_FORM_FIELDS_EXISTS_MESSAGE if grep /^$/, values %product_info;
	
	return (@messages) ? \@messages : \%product_info;
    }
    

}

1;