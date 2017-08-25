
Danta.site.GlobalButton = {
    
	/**
     * returns the name of the node given its path
     **/
    openDialog : function(button){
		var globalDialogPath = $(button).data("globaldialogpath");
        var globalPath = $(button).data("globalpath");
        var dialog = CQ.WCM.getDialog(globalDialogPath);
		dialog.loadContent(globalPath);
		dialog.show(); //show the dialog

    }
}
