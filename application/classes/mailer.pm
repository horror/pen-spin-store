package mailer; {
    use Class::InsideOut qw/:std/;
    use strict;
    use utf8;
    use Net::SMTP_auth;
    use config_mail;
  
    public mail_to => my %mail_to;
    public mail_subject => my %mail_subject;
    public mail_text => my %mail_text;
  
    sub new {
        my($class, $to, $subject, $text) = @_;
        my $self = bless {}, $class;
        
        register($self); 
            
        $self->mail_to($to);
        $self->mail_subject($subject);
        $self->mail_text($text);
        
        return $self;
    }

    sub send_mail {
        my $self = shift;
        
        my $smtp = Net::SMTP_auth->new(SMTP_SERVER);
    
        $smtp->auth('PLAIN', MAIL_ADRESS, MAIL_PASSWORD);
        $smtp->mail(MAIL_ADRESS);
        $smtp->to($self->mail_to());
    
        $smtp->data();
        
        $smtp->datasend("To: " . $self->mail_to() . "\n");
        $smtp->datasend("From: ".MAIL_ADRESS."\n");
        $smtp->datasend("Subject: " . $self->mail_subject() . "\n");
        $smtp->datasend("Content-Type: text/plain; charset=\"utf-8\"\n\n");
        $smtp->datasend($self->mail_text() . ".\n");
        
        $smtp->dataend();
    
        $smtp->quit;
    }
}

1;