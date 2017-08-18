$(document).ready(function() {
    $('#site-global-button').click(function(event) {
        event.preventDefault();
        LayerX.site.GlobalButton.openDialog(this);
    });

});