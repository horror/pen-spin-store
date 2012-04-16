package users_tests; {
    use Class::InsideOut qw/:std/;
    use Test::More 'no_plan';
    use Test::More::UTF8;
    use CGI qw(header cookie);
    use Digest::MD5 qw(md5_hex);
    use base fw_tests;
    use strict;
    use model_users;
    use auth;
    use russian;
  
    public mu => my %mu;
    
    sub new {
	my($class, $dbh) = @_;	
	my $self = fw_tests::new($class, $dbh);	
	return $self;
    }

    sub run {
        my $self = shift;
	
	my $sid_value = 999999999;
	my $cookies = {sid => cookie(-name => 'sid', -value => $sid_value)};

        my $model = model_users->new($self->db(), russian->new());
	ok(defined $model, 'model_users->new() вернула экземпляр класса' );
	my $auth = auth->new($cookies, $self->db());
	ok(defined $auth, 'auth->new() вернула экземпляр класса' );
	is($model->get_users_count(), 0, '$model->get_users_count() пустая таблица');
	
	$model->add_anonymous_user($sid_value);
	is($model->get_users_count(), 1, '$model->get_users_count() после добавления ананимного пользователя');
	my $user_id = $auth->logged_anonymous_user_id();
	is($user_id, $auth->logged_user_id(), 'Совпадение $auth->logged_user_id() и $auth->logged_anonymous_user_id()');
	is($auth->logged_authorized_user_id(), 0, '$auth->logged_authorized_user_id() для анонимного пользователя равен 0');
	
	my $user_info = {
	    login => 'new_user',
	    name => 'new_user_name',
	    email => 'new_user@mail.ru',
	    password => '123',
	};
	ok(!$model->not_allowed_login('new_user', 0), 'Логин new_user НЕ занят');
	ok($model->regist_user($user_id, $user_info), '$model->regist_user($user_id, $user_info) регистрация анонимного пользователя');
	is($auth->logged_anonymous_user_id(), 0, 'Теперь $auth->logged_anonymous_user_id() должна вернуть 0');
	ok($model->not_allowed_login('new_user', 0), 'Логин new_user теперь занят');
	
	ok($auth->login_user($user_info->{login}, $user_info->{password}), 'Логин');
	($sid_value) = @{$auth->get_cookie_sid()};
	is($auth->logged_authorized_user_id(), $auth->logged_user_id(), 'после логина $auth->logged_authorized_user_id() и $auth->logged_user_id() должны совпасть');
	
	my $expected_user_info = {
	    id => $user_id,
	    login => 'new_user',
	    name => 'new_user_name',
	    email => 'new_user@mail.ru',
	    password => md5_hex('123'),
	    sid => $sid_value,
	    role => 0,
	};
	my $got_user_info = $model->get_user_on_id($user_id);
	delete $got_user_info->{last_visit};
	is_deeply($got_user_info, $expected_user_info, '$model->get_user_on_id($user_id) Проверка профиля зарегистрированного пользователя');
	is($model->get_users_count(), 1, '$model->get_users_count() все также должна возращать 1');
	
	my $new_user_info = {
	    login => 'updated_user',
	    name => 'updated_user_name',
	    email => 'updated_user@mail.ru',
	};
	ok($model->update_user($new_user_info, $user_id), 'Обновление пользовательского профиля');
	$expected_user_info->{login} = $new_user_info->{login};
	$expected_user_info->{name} = $new_user_info->{name};
	$expected_user_info->{email} = $new_user_info->{email};
	$got_user_info = $model->get_user_on_id($user_id);
	delete $got_user_info->{last_visit};
	is_deeply($got_user_info, $expected_user_info, '$model->get_user_on_id($user_id) Проверка профиля после его изменения');
	
	#пользователь №2
	my $sid_value_2 = 'sdasdasdsa232144';
	$auth->set_cookie_sid($sid_value_2);
	$model->add_anonymous_user($sid_value_2);
	is($model->get_users_count(), 2, '$model->get_users_count() 2 пользователя');
	my $user_2_id = $auth->logged_anonymous_user_id();
	my $user_2_info = {
	    login => 'new_user_2',
	    name => 'new_user_2_name',
	    email => 'new_user_2@mail.ru',
	    password => '1234',
	};
	$model->regist_user($user_2_id, $user_2_info);
	my $expected_user_2_info = {
	    id => $user_2_id,
	    login => 'new_user_2',
	    name => 'new_user_2_name',
	    email => 'new_user_2@mail.ru',
	    password => md5_hex('1234'),
	    sid => $sid_value_2,
	    role => 0,
	};
	
	my $expected_result = [
	    {
	        id => $expected_user_info->{id},
		cell => [$expected_user_info->{id}, $expected_user_info->{name}, $expected_user_info->{login},
		    $expected_user_info->{email}, $expected_user_info->{password}, 'Юзер']
	    },
	    {
	        id => $expected_user_2_info->{id},
		cell => [$expected_user_2_info->{id}, $expected_user_2_info->{name}, $expected_user_2_info->{login},
		    $expected_user_2_info->{email}, $expected_user_2_info->{password}, 'Юзер']
	    },
	];
	my $got_users_jqgrid_format = $model->get_users_jbgrid_format_calls();
	
	is_deeply($got_users_jqgrid_format, $expected_result, '$model->get_users_jbgrid_format_calls() c 2мя пользователями');
	
	$model->delete_user($user_id);
	is($model->get_users_count(), 1, '$model->get_users_count() после удаления 1го пользователя');
	$model->delete_user($user_2_id);
	is($model->get_users_count(), 0, '$model->get_users_count() после удаления 2го(последнего) пользователя');
	
    }
}

1;