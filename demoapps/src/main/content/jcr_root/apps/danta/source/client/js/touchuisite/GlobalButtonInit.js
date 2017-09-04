$(document).ready(function() {
	setTimeout(function() {
    	if (Danta.site.GlobalButton.isDantaPage() === true) {
            var currentLayer = Danta.site.GlobalButton.getEditorLayerFromCookies();
            var currentLayerTemplate = Danta.site.GlobalButton.getEditorLayerTemplateFromCookies();
            if ( currentLayer === 'Design' || currentLayer === 'Edit' ) {
                if (window.location.href.search('.scaffolding.') != -1 ) {
                    //The scaffolding mode does not change the cookie value
                    Danta.site.GlobalButton.removeGlobalButton();
                } else {
                    var globalButtonElement = document.getElementById('site-global-button-touch-ui');
                    if ( null === globalButtonElement ) {
                        Danta.site.GlobalButton.addGlobalButton();
                    }
                }
            } else if (currentLayer === null) {
                if (currentLayerTemplate === 'structure' || currentLayerTemplate === 'initial') {
                    var globalButtonElement = document.getElementById('site-global-button-touch-ui');
                    if ( null === globalButtonElement ) {
                        Danta.site.GlobalButton.addGlobalButton();
                    }
                }
            }
        }

	}, 1000);

     // Changed redirect page after open dialog in mobile devices
    if (window.location.href.indexOf("cq:global_dialog.html") != -1) {
    	Danta.site.GlobalButton.changePageEditorAttribute();
    }
});

;(function ($, ns, channel, window, undefined) {
    /**
     * Listens to layer selection on popover element and wait 1 second to add the global button
     * to ensure and validated that the mode was changed.
     */
    channel.on("click", ".js-editor-LayerSwitcherTrigger", function (event) {
        event.preventDefault();
		if (Danta.site.GlobalButton.isDantaPage() === true) {
            var currentDataLayerAtt = event.currentTarget.getAttribute('data-layer');
            if (currentDataLayerAtt === 'Design' || currentDataLayerAtt === 'Edit' || currentDataLayerAtt === 'structure' || currentDataLayerAtt === 'initial') {
                setTimeout(function() {
                    var currentDataLayer = Danta.site.GlobalButton.getEditorLayerFromCookies();

                    if (currentDataLayer === 'Design' || currentDataLayer === 'Edit') {
                        var $globalDesignButtonElement = $('#site-global-button-touch-ui');
                        if ( $globalDesignButtonElement.length === 0 ) {
                            Danta.site.GlobalButton.addGlobalButton();
                            Danta.site.GlobalButton.addButtonAttributes();
                        }
                    } else if (currentDataLayer === null) {
                        var currentDataLayerTemplate = Danta.site.GlobalButton.getEditorLayerTemplateFromCookies();
                        if (currentDataLayerTemplate === 'structure' || currentDataLayerTemplate === 'initial'){
                            var $globalDesignButtonElement = $('#site-global-button-touch-ui');
                            if ( $globalDesignButtonElement.length === 0 ) {
                                Danta.site.GlobalButton.addGlobalButton();
                                Danta.site.GlobalButton.addButtonAttributes();
                            }
                        }
                    } else if (Danta.site.GlobalButton.getEditorLayerFromCookies() === 'Annotate') {
                        $('#site-global-button-touch-ui').hide();
                    }
                }, 1000);
            } else if (event.currentTarget.getAttribute('data-layer') === 'Annotate') {
                if (Danta.site.GlobalButton.getEditorLayerFromCookies() === 'Design') {
                    var isGlobalButtonHidden = $('#site-global-button-touch-ui').is(':hidden');
                    if (isGlobalButtonHidden) {
                        $('#site-global-button-touch-ui').show();
                    }
                }
            } else {
                Danta.site.GlobalButton.removeGlobalButton();
            }
        }

    });

    channel.on("click", ".globalPropertiesButton", function (event) {
        event.preventDefault();
        if (Danta.site.GlobalButton.isDantaPage() === true) {
            Danta.site.GlobalButton.addButtonAttributes();

            //get attributes
            var dialogContentPath = event.currentTarget.getAttribute('data-path');
            var dialogSrcPath = event.currentTarget.getAttribute('data-dialog-src');
            var touchUiDialogSrcPath = event.currentTarget.getAttribute('data-src-path');

            var classicDialogSrcPath = touchUiDialogSrcPath.replace("cq:global_dialog","dialog");
            var dialogHtmlbaseType = touchUiDialogSrcPath.replace("/cq:global_dialog","");
            dialogHtmlbaseType = dialogHtmlbaseType.replace("/apps/","");

            var editable = new ns.Editable({
                csp: "contentpage|htmlbase|page/title|base|parbase",
                dialog: touchUiDialogSrcPath,
                dialogClassic: classicDialogSrcPath,
                dialogLayout: "auto",
                dialogLoadingMode: "auto",
                dialogSrc: dialogSrcPath,
                editConfig: {
                    listeners: {
                        afteredit: "REFRESH_PAGE"
                    }
                },
                ipeConfig: {},
                isResponsiveGrid: false,
                path: dialogContentPath,
                slingPath: dialogContentPath + ".html",
                type: ""
            });

            var dantaGlobalDialog = new ns.edit.Dialog(editable);
            ns.DialogFrame.openDialog(dantaGlobalDialog);
        } else {
            $('#site-global-button-touch-ui').prop('disabled', true);
        }
    });
}(jQuery, Granite.author, jQuery(document), this));

;(function(window, document, $) {
    /**
     * Hide global properties button when the dialog is in fullscreen
     */
    var currentLayerOnFSD = Danta.site.GlobalButton.getEditorLayerFromCookies();
    var currentLayerTemplateOnFSD = Danta.site.GlobalButton.getEditorLayerTemplateFromCookies();
    if ( currentLayerOnFSD === 'Design' || currentLayerOnFSD === 'Edit' || currentLayerTemplateOnFSD === 'structure' || currentLayerTemplateOnFSD === 'initial') {
        $(document).on("click", ".cq-dialog-layouttoggle", function(e) {
            e.preventDefault();
            $('#site-global-button-touch-ui').hide();
        });

        $(document).on("click", ".cq-dialog-cancel", function(e) {
            e.preventDefault();
            var isGlobalButtonHidden = $('#site-global-button-touch-ui').is(':hidden');
            if (isGlobalButtonHidden) {
                $('#site-global-button-touch-ui').show();
            }
        });
        $(document).on("click", ".cq-dialog-submit", function(e) {
            var isGlobalButtonHidden = $('#site-global-button-touch-ui').is(':hidden');
            if (isGlobalButtonHidden) {
                $('#site-global-button-touch-ui').show();
            }
        });
    }
})(window, document, Granite.$);
