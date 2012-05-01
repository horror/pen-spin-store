package controller_admin_reports; {
    use base controller_base_admin;
    use folder_config;
    use strict;
    use JSON;
    use Win32::Pipe;
    use utf8;
  
    sub new {
        my ($class, $args, $cookies) = @_;
        my $self = controller_base_admin::new($class, $args, $cookies);
        return $self;
    }
  
    sub action_index {
        my $self = shift;
        
        $self->add_template_scripts([APP_JS_PATH . __DM . 'report_form.js']);
        my $message ='';
        
        if ($self->request->{submit}) {
            my $report_name = $self->gen_report_name();
            my $report_params = $self->get_report_params();
            $report_params->{name} = $report_name; 
            
            $self->push_report_to_queue(JSON->new->utf8->encode($report_params));
            
            my $report_link = sprintf('<a href="\reports\%s.pdf">ссылке</a>', $report_name);
            $message = "Запрашеваемый отчет добавлен в очередь, он будет доступен по $report_link";
        }
        
        $self->add_template_params({
            page_title => $self->lang->REPORTS_PAGE_TITLE,
            center_block => [
                fw_view->new('admin', 'reports_index.tpl', {
                    message => $message,
                })->execute()
            ],
        });
    }
    
    sub gen_report_name() {
        my $self = shift;
        
        my @alph = ('a'..'z', 'A'..'Z');
        return join('', map($alph[rand(@alph)], 1..40));
    }
    
    sub get_report_params() {
        my $self = shift;
        
        my @param_k = qw(x_axis y_axis x_detalisation y_detalisation x_filter_cond y_filter_cond x_filter y_filter analyze aggregation);
        my @param_v = @{$self->request()}{@param_k};
        my %report_params;
        @report_params{@param_k} = @param_v;
        return \%report_params;
    }
    
    sub push_report_to_queue() {
        my($self, $json_params) = @_;
        
        my $PipeName = "\\\\.\\pipe\\pdf_gen";
        
        if (my $Pipe = Win32::Pipe->new($PipeName)) {
            $Pipe->Write($json_params);
            $Pipe->Close();
        }
        else {
            my($Error, $ErrorText) = Win32::Pipe::Error();
            print "Error:$Error \"$ErrorText\"\n";
        }
    }
}

1;