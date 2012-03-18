package folder_config;
use strict;
use warnings;
use File::Basename;
require Exporter;

our @ISA = qw(Exporter);

our @EXPORT = qw(
    FRAMEWORK_CONFIG_PATH
    FRAMEWORK_CLASSES_PATH
    APP_CONFIG_PATH
    APP_CLASSES_PATH
    APP_MEDIA_PATH
    APP_VIEWS_PATH
    APP_MODELS_PATH
    APP_CONTROLLERS_PATH
    APP_CONTROLLERS_INDEX_PATH
    APP_CONTROLLERS_ADMIN_PATH
    APP_WIDGETS_PATH
    APP_JSON_PATH
    APP_CSS_PATH
    APP_JS_PATH
    APP_IMG_PATH
    ROOT_PATH
    __DM
);

my $APP_ROOT_PATH = dirname(__FILE__);

my $WF_FOLDER_NAME = 'framework';
my $APP_FOLDER_NAME = 'application';

sub __DM(){"\\"};

sub FRAMEWORK_CONFIG_PATH() {$APP_ROOT_PATH . __DM . $WF_FOLDER_NAME . __DM . 'config'};
sub FRAMEWORK_CLASSES_PATH() {$APP_ROOT_PATH . __DM . $WF_FOLDER_NAME . __DM . 'classes'};

sub APP_CONFIG_PATH() {$APP_ROOT_PATH . __DM . $APP_FOLDER_NAME . __DM . 'config'};
sub APP_CLASSES_PATH() {$APP_ROOT_PATH . __DM . $APP_FOLDER_NAME . __DM . 'classes'};
sub APP_MEDIA_PATH() {$APP_ROOT_PATH . __DM . $APP_FOLDER_NAME . __DM . 'media'};
sub APP_VIEWS_PATH() {$APP_ROOT_PATH . __DM . $APP_FOLDER_NAME . __DM . 'views'};
sub APP_CONTROLLERS_PATH() {APP_CLASSES_PATH . __DM . 'controllers'};
sub APP_MODELS_PATH() {APP_CLASSES_PATH . __DM . 'models'};
sub APP_CONTROLLERS_INDEX_PATH() {APP_CONTROLLERS_PATH . __DM . 'index'};
sub APP_CONTROLLERS_ADMIN_PATH() {APP_CONTROLLERS_PATH . __DM . 'admin'};
sub APP_WIDGETS_PATH() {APP_CONTROLLERS_PATH . __DM . 'widgets'};
sub APP_JSON_PATH() {APP_CONTROLLERS_PATH . __DM . 'json'};
sub APP_CSS_PATH() {'./application/media/css'};
sub APP_JS_PATH() {'./application/media/js'};
sub APP_IMG_PATH() {'./application/media/img'};
sub ROOT_PATH() {'http://localhost/'};
1; # ok!