package auth; {
    use fw_database;
    use Class::InsideOut qw/:std/;
    use Digest::MD5 qw(md5_hex);
    use CGI qw(cookie);
    use strict;
    use utf8;
    use config_session;
  
    public fw_database_handler => my %database_handler;
    public cookies => my %cookies;
  
    sub new {
        my($class, $cookies, $dbh) = @_;
        my $self = bless {}, $class;
        
        register($self); 
            
        $self->fw_database_handler(fw_database->new($dbh)); #dbh всегда не пуст.
        $self->cookies($cookies);
        return $self;
    }
    
    sub gen_sid {
        my $self = shift;
        my @alph = ('a'..'z', 'A'..'Z');
        return join('', map($alph[rand(@alph)], 1..40));
    }

    sub login {
        my($self, $params) = @_;
        my $db = $self->fw_database_handler();
        my ($user) = @{$db->select_and_fetchall_arrayhashesref('users', 'id', $params)};
        if(defined $user) {
            $self->change_user_sid($user->{id}, my $sid = $self->gen_sid());          #Как нормально переписать?
            $self->set_cookie_sid($sid);
            return 1;
        }
        return 0;
    }
    
    sub login_user {
        my($self, $login, $pass) = @_;
        return $self->login({login => $login, password =>  md5_hex($pass)});
    }
    
    sub login_admin {
        my($self, $login, $pass) = @_;
        return $self->login({login => $login, password =>  md5_hex($pass), role => 1});
    }
    
    sub logged_id {
        my($self, $perams) = @_;
        my $db = $self->fw_database_handler();
        my ($user) = @{$db->select_and_fetchall_arrayhashesref('users', 'id', $perams)};
        
        return defined $user ? $user->{id} : 0;
    }

    sub logged_user_id {
        my $self = shift;
        return $self->logged_id({
            sid => $self->get_cookie_sid(),
            last_visit => { '>' => \["UNIX_TIMESTAMP() - ?", SESSION_TIME_SECONDS]}
        });
    }
    
    sub logged_admin_id {
        my $self = shift;
        return $self->logged_id({
            sid => $self->get_cookie_sid(),
            role => 1,
            last_visit => { '>' => \["UNIX_TIMESTAMP() - ?", SESSION_TIME_SECONDS]}
        });
    }
    
    sub change_user_sid {
        my ($self, $user_id, $sid) = @_;
        my $db = $self->fw_database_handler();
        $db->update('users', {sid => $sid, last_visit => \"UNIX_TIMESTAMP()"}, {id => $user_id});
    }
    
    sub logout {
        my $self = shift;
        my $db = $self->fw_database_handler();
        $db->update('users', {last_visit => 0}, {sid => $self->get_cookie_sid()});
    }
    
    sub set_cookie_sid {
        my ($self, $value) = @_;
        $self->cookies->{sid} = cookie(-name => 'sid', -value => $value);
    }
    
    sub get_cookie_sid {
        my ($self) = @_;
        return $self->cookies->{sid}->{value};
    }
}

1;