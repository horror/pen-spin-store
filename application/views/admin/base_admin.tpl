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
            
            <!--заглавие-->
            <hgroup>
                <h1><a href="#">[% page_title %]</a></h1>
            </hgroup>
            <!--/заглавие-->
            
            <!--главное меню-->
            [% IF main_menu %]
            <nav id="main_menu">
                [% main_menu %]
            </nav>
            [% END %]
            <!--/главное меню-->
            
        </header>    
        <!--/шапка-->
        
        <!--центральный блок-->
            <section id="center_block">
                
            [% IF center_block_right_section %]
                <section class="center_block_right_section">
                    [% center_block_right_section %] 
                </section>
            [% END %]
                
            [% IF center_block_menu %]
                <aside class="center_block_menu">
                    [% center_block_menu %]
                </aside>
            [% END %]

            [% IF center_block %]
                [% FOREACH block = center_block %]
                    <section class="block">
                        [% block %]
                    </section>
                [% END %]
            [% END %]
            
            </section>
        <!--/центральный блок-->
        
        <!--подвал-->
        <footer>

        </footer>
        <!--/подвал-->
        
    </body>
</html>
