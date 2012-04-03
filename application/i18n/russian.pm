package russian;
use strict;
use utf8;

sub new {
    my $class = shift;  
    my $self = {} ;  
    bless $self, $class; 
    return $self;
} 

#mesaages
sub LOGIN_ERROR_MESSAGE() {'Логин и пароль введены не верно'};
sub REG_SUCCESS_MESSAGE() {'Вы успешно зарегистрировались'};
sub REG_FAIL_DUBLICATE_LOGIN() {'Пользователь с таким логином уже зарегистрирован'};
sub EMPTY_FORM_FIELDS_EXISTS_MESSAGE() {'Заполнены не все поля'};
sub PASS_CONFIRM_ERROR_MESSAGE() {'Заполнены не все поля'};
sub LOST_PRODUCT_NAME() {'Не заполенно поле название'};

#mail
sub REG_MAIL_HEADER() {'Вы зарегистрировались на сайте Localhost'};
sub REG_MAIL_TEXT_FORMAT() {
    "%s! Поздравляем вас с успешной регистрацией на ".
    "нашем сайте.\n Ваш логин: %s.\n Пароль: %s"
};

#site_lables
sub ADMIN_TITLE() {'Панель управления'};
sub INDEX_TITLE() {'Pen Spin Store'};
sub INDEX_DESCR() {'магазин ручек для пен спиннинга'};
sub COPY_RIGHTS() {'все права защищены (с) 2012'};

#pages_names
sub ADMIN_LOGIN_PAGE_TITLE() {'Вход в админ. панель'};
sub ADMIN_STATS_PAGE_TITLE() {'Статистика'};
sub PRODUCTS_PAGE_TITLE() {'Товары и категории'};
sub PRODUCTS_DETAILES_PAGE_TITLE() {'Страница товара'};
sub IMPORT_PAGE_TITLE() {'Импорт товаров и категорий'};
sub USERS_PAGE_TITLE() {'Пользователи'};
sub INDEX_MAIN_PAGE_TITLE() {'Главная страница'};
sub INDEX_REG_PAGE_TITLE() {'Регистрация'};
sub CART_PAGE_TITLE() {'Корзина'};

#menu_items
sub PRODUCTS_MENU_ITEM() {'Товары'};
sub IMPORT_MENU_ITEM() {'Импорт'};
sub STATS_MENU_ITEM() {'Статистика'};
sub USERS_MENU_ITEM() {'Пользователи'};
sub MAIN_MENU_ITEM() {'Главная'};
sub ORDERS_MENU_ITEM() {'Заказы'};

#form_elements
sub SUBMIT_REG_CAPTION() {'Зарегистрироваться'};
sub SELECT_ADMIN_ROLE() {'Админ'};
sub SELECT_USER_ROLE() {'Юзер'};

#tables_aliases
sub USERS_TABLE_ALIAS() {'Пользователи'};
1; # ok!