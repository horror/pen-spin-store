﻿#! C:\strawberry\perl\bin\perl.exe -w
use File::Basename;
use lib (dirname(__FILE__)); #Корень сайта.
use folder_config;
use lib (APP_CONTROLLERS_PATH, APP_CONTROLLERS_INDEX_PATH,
         APP_CONTROLLERS_ADMIN_PATH, FRAMEWORK_CLASSES_PATH,
         APP_CONFIG_PATH, APP_MODELS_PATH, APP_CLASSES_PATH,
         APP_WIDGETS_PATH, APP_JSON_PATH, APP_I10N_PATH);

use config_route;
use CGI 3.47;
use CGI::Cookie;
#use strict;

my $q = CGI->new;
my %_params = $q->Vars;
my @_files = $q->upload('multiple_files');
my %_cookies = CGI::Cookie->fetch;

my $controller_name = 'controller_'
    . ($q->url_param('controller') ?
          ($q->url_param('panel') ? $q->url_param('panel') . '_' : '') . $q->url_param('controller') :
           DEFAULT_ROUTE_CONTROLLER
    );
my $action = $q->url_param('action') ? $q->url_param('action') : DEFAULT_ROUTE_ACTION;

eval {
    require "$controller_name.pm";
};

if ($@) {
    print $q->header(-status=>'404',-type=>'text/html');
    print $@;
}

my $controller = $controller_name->new(\%_params, \%_cookies, \@_files);

eval {
    {no warnings 'once';
    "${controller_name}::action_$action"->($controller);};
};

if ($@) {
    print $q->header(-status=>'404',-type=>'text/html');
    print $@;
}
else {
    $controller->render();
}

#if (*{"${controller_name}::action_$action"}{CODE}) {
