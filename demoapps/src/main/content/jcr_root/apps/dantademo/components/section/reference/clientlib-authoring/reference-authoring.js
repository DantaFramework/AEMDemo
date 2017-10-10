/*
 * ADOBE CONFIDENTIAL
 *
 * Copyright 2015 Adobe Systems Incorporated
 * All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and may be covered by U.S. and Foreign Patents,
 * patents in process, and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 */
;(function ($, ns, channel, window) {
    "use strict";

    /**
     * The default Delete method defined for the Touch UI Editor
     */
    var defaultDelete = ns.edit.ToolbarActions.DELETE.execute;

    /**
     * Overrides the default Delete method with a custom message
     * (customized from edit.EditableActions.DELETE.js)
     */
    function customDelete(message, selected) {
        ns.ui.helpers.prompt({
            title: Granite.I18n.get("Delete"),
            message: Granite.I18n.get(message),
            actions: [
                {
                    id: "CANCEL",
                    text: Granite.I18n.get("Cancel", "Label for Cancel button"),
                    className: "cq-deletecancel"
                },
                {
                    id: "DELETE",
                    text: Granite.I18n.get("Delete", "Label for Confirm button"),
                    className: "coral-Button--warning cq-deleteconfirm"
                }
            ],
            callback: function (actionId) {
                if (actionId === "CANCEL") {
                    ns.selection.deselectAll();
                } else {
                    ns.selection.deselectAll(); // before the delete operation (get rid of refs)
                    ns.editableHelper.actions.DELETE.execute(selected);
                }
            }
        });
    }

    /**
     * Deletes the selected components.
     *
     * Displays a customized Delete message if the selected component is referenced,
     * otherwise it displays the default Delete message defined for the Touch UI Editor
     */
    function doDelete() {
        var selected = ns.selection.getAllSelected(),
            hasReferences = false,
            paths = [];
        for (var i=0; i < selected.length; i++){
            paths.push(selected[i].path);
        }
        // check for references
        $.ajax({
            type: 'GET',
            url: "/bin/wcm/references",
            data: {
                "_charset_": "utf-8",
                path: paths
            }
        }).done(function (data, textStatus, jqXHR) {
            if (_g.HTTP.isOkStatus(jqXHR.status)) {
                if (data.pages.length > 0) {
                    hasReferences = true;
                }
            }
            if (hasReferences) {
                var message = "One or more of the selected components are referenced. " +
                                    "Do you really want to delete them?";
                customDelete(message, selected);
            } else {
                defaultDelete();
            }
        });
    }

    // Override the default Delete method
    ns.edit.ToolbarActions.DELETE.execute = doDelete;
    ns.edit.ToolbarActions.DELETE.handler = doDelete;

}(jQuery, Granite.author, jQuery(document), this));
