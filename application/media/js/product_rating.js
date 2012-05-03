$(document).ready(function () {
    $('.rating').rating('/index.pl?controller=products&action=class', {maxvalue:5, increment:.5});
});