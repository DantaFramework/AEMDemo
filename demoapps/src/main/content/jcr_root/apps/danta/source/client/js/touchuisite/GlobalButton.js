Danta.site.GlobalButton = {

    /**
     * add global button
     **/
    addGlobalButton : function() {
        var globalButton = $('<button/>');
        globalButton.attr('id', 'site-global-button-touch-ui');
        globalButton.attr('class', 'coral-MinimalButton globalPropertiesButton');
        globalButton.attr('text', 'Global Properties');
        globalButton.attr('title', 'Global Properties');
        globalButton.attr('test','test');
        $('#Content').append(globalButton);
        $('#site-global-button-touch-ui').append("<span>Open Global Properties</span>");
    },
    /**
     * remove global button
     **/
    removeGlobalButton : function() {
        $('#site-global-button-touch-ui').remove();
    },
    /**
     * add attributes in global button
     **/
    addButtonAttributes : function() {
        //get global data path
        var iframeElement = document.getElementById("ContentFrame");
        var iframeDoc = iframeElement.contentDocument || iframeElement.contentWindow.document;

        if (null != iframeDoc) {
            var globalDataElement = iframeDoc.getElementById("xk-global-path");

            if (null != globalDataElement) {
                var globalDataPath = globalDataElement.getAttribute("xk-content-global-path");
                var globalDialogPath = globalDataElement.getAttribute("xk-dialog-global-path");

                //get global button element
                var globalButtonElement = document.getElementById("site-global-button-touch-ui");

                //set global data path
                globalButtonElement.setAttribute("data-path", globalDataPath);

                //set data dialog src
                var globalDialogSrcBase = "/mnt/override";
                var globalDataDialogSrc = globalDialogSrcBase + globalDialogPath + ".html" + globalDataPath;
                globalButtonElement.setAttribute("data-dialog-src", globalDataDialogSrc);

                //set
                globalButtonElement.setAttribute("data-src-path",globalDialogPath);

            }
        }
    },
    /**
     * change redirect page after open dialog in mobile devices
     **/
    changePageEditorAttribute : function() {
        var previousPage = document.referrer;
        var formElement = $('form');

        if (formElement != null && previousPage != null) {
            formElement.attr("data-cq-dialog-pageeditor", previousPage);
        }
    },
    /**
     * get editor layer, It use the cookie 'cq-editor-layer' for AEM 6.1 and 'cq-editor-layer.page' for AEM 6.2
     **/
    getEditorLayerFromCookies : function() {
       var editorLayer = null;
        if ( $.cookie('cq-editor-layer.page') != null ) {
            editorLayer = $.cookie('cq-editor-layer.page');
        } else if ( $.cookie('cq-editor-layer') ) {
            editorLayer = $.cookie('cq-editor-layer');
        }
        return editorLayer;

    },
	/**
     * get editor layer template, It use the cookie 'cq-editor-layer.template'
     **/
	getEditorLayerTemplateFromCookies : function() {
       var editorLayerTemplate = null;
        if ( $.cookie('cq-editor-layer.template') != null ) {
            editorLayerTemplate = $.cookie('cq-editor-layer.template');
        }
        return editorLayerTemplate;

    },
    isLayerxPage : function() {
        var isLayerxPage = false;
        var iframeElement = document.getElementById("ContentFrame");
        var iframeDoc = iframeElement.contentDocument || iframeElement.contentWindow.document;

        if (null != iframeDoc) {
            var globalDataElement = iframeDoc.getElementById("xk-global-path");
            if (null != globalDataElement) {
                isLayerxPage = true;
            }
        }
        return isLayerxPage;
    }

}
