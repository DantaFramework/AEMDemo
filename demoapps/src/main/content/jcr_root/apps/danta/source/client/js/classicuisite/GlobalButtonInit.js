$(document).ready(function() {
    $('#site-global-button').click(function(event) {
        event.preventDefault();
        Danta.site.GlobalButton.openDialog(this);
    });

});