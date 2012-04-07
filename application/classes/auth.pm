package auth; {
    use fw_database;
    use Class::InsideOut qw/:std/;
    use Digest::MD5 qw(md5_hex);
    use CGI qw(cookie);
    use strict;
    use utf8;
    use config_session;
    use model_orders;
    use model_users;
  
    public fw_database_handler => my %fw_database_handler;
    public database_handler => my %database_handler;
    public cookies => my %cookies;
  
    sub new {
        my($class, $cookies, $dbh) = @_;
        my $self = bless {}, $class;
        
        register($self); 
            
        $self->fw_database_handler(fw_database->new($dbh)); #dbh всегда не пуст.
        $self->database_handler($dbh);
        
        $self->cookies($cookies);
        return $self;
    }
    
    sub gen_sid {
        my $self = shift;
        my @alph = ('a'..'z', 'A'..'Z');
        return join('', map($alph[rand(@alph)], 1..40));
    }

    sub login {
        my($self, $params, $need_merge) = @_;
        my $db = $self->fw_database_handler();
        my ($user) = @{$db->select_and_fetchall_arrayhashesref('users', 'id', $params)};
        if(defined $user) {
            if ($need_merge) {
                model_orders->new($self->database_handler())
                    ->merge_carts($self->logged_anonymous_user_id(), $user->{id});
                model_users->new($self->database_handler())
                    ->delete_user($self->logged_anonymous_user_id());
            }
            $self->change_user_sid($user->{id}, my $sid = $self->gen_sid());          #Как нормально переписать?
            $self->set_cookie_sid($sid);
            return $user->{id};
        }
        return 0;
    }
    
    sub login_user {
        my($self, $login, $pass, $need_merge) = @_;
        return $self->login({login => $login, password =>  md5_hex($pass)}, $need_merge);
    }
    
    sub login_user_with_merge {
        my($self, $login, $pass) = @_;
        return $self->login_user($login, $pass, 1);
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
        });
    }
    
    sub logged_authorized_user_id {
        my $self = shift;
        return $self->logged_id({
            sid => $self->get_cookie_sid(),
            last_visit => { '>' => \["UNIX_TIMESTAMP() - ?", SESSION_TIME_SECONDS]},
            login => { '!=', 'Anonymous' }
        });
    }
    
    sub logged_anonymous_user_id {
        my $self = shift;
        return $self->logged_id({
            sid => $self->get_cookie_sid(),
            login => 'Anonymous',
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
        $self->cookies->{sid} = cookie(-name => 'sid', -value => $value, -expires => '+6M');
    }
    
    sub get_cookie_sid {
        my ($self) = @_;
        return $self->cookies->{sid}->{value};
    }
}

1;