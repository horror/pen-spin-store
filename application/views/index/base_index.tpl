<!DOCTYPE html>
<html>
    <head>
        <title>[% site_name %] | [% page_title %]</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        [% FOREACH style = styles %]
            <link rel='stylesheet' href='[% style %]' type='text/css'>
        [% END %]
        [% FOREACH script = scripts %]
            <script type='text/javascript' src='[% script %]'></script>
        [% END %]
    </head>
    <body>
        <!--шапка-->
        <header>
            <hgroup> 
                <h1><a href="/">[% site_name %]</a></h1> 
                [% IF  site_description %]
                    <h2>[% site_description %]</h2>
                [% END %]
            </hgroup>
            
            <!--корзина-->
            [% IF cart %]
                <section id="cart">
                    [% cart %]
                </section>
            [% END %]
            
            [% IF login_form %]
                <section id="login_form">
                    [% login_form %]
                </section>
            [% END %]
            <!--/корзина-->

            <!--главное меню-->
            [% IF main_menu %]
                <aside id="main_menu">
                    [% main_menu %]
                </aside>
            [% END %]
            <!--/главное меню-->
            
        </header>    
        <!--/шапка-->
        
        <!--левый блок-->
        [% IF left_block %]
            <aside id="left_block">
            [% FOREACH block = left_block %]
                <atrticle>
                    [% block %]
                </atrticle>
            [% END %]
            </aside>
        [% END %]
        <!--/левый блок-->
        
        <!--правый блок-->
        [% IF right_block %]
            <aside id="right_block">
            [% FOREACH block = right_block %]
                <atrticle>
                    [% block %]
                </atrticle>
            [% END %]
            </aside>
        [% END %]
        <!--/правый блок-->
        
        <!--центральный блок-->
        [% IF center_block %]
            <section id="center_block">
            <h3 class="page_title">[% page_title %]</h3>
            [% FOREACH block = center_block %]
                <atrticle>
                    [% block %]
                </atrticle>
            [% END %]
            </section>
        [% END %]
        <!--/центральный блок-->
        
        <!--подвал-->
        <footer>
            <small>[% c_rights %]</small>
        </footer>
        <!--/подвал-->
        
    </body>
</html>
