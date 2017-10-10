/*******************************************************************************
 * Copyright 2016 Adobe Systems Incorporated
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ******************************************************************************/

"use strict";

/**
 * Image component JS Use-api script
 */
use(["/libs/wcm/foundation/components/utils/AuthoringUtils.js",
     "/libs/wcm/foundation/components/utils/Image.js",
     "/libs/sightly/js/3rd-party/q.js"], function (AuthoringUtils, Image, Q) {

    var image = new Image(granite.resource);
    var imageDefer = Q.defer();
    
    var CONST = {
        AUTHOR_IMAGE_CLASS: "cq-dd-image",
        PLACEHOLDER_SRC: "/etc/designs/default/0.gif",
        PLACEHOLDER_TOUCH_CLASS: "cq-placeholder file",
        PLACEHOLDER_CLASSIC_CLASS: "cq-image-placeholder"
    };
    
    // check if there's a local file image under the node
    granite.resource.resolve(granite.resource.path + "/file").then(function (localImageResource) {
        imageDefer.resolve(image);
    }, function() {
        // The drag & drop image CSS class name
        image.cssClass = CONST.AUTHOR_IMAGE_CLASS;

        // Modifying the image object to set the placeholder if the content is missing

        if (!image.fileReference()) {
            if(typeof wcmmode != "undefined" && wcmmode.isEdit()) {
                image.src = CONST.PLACEHOLDER_SRC;
                if (AuthoringUtils.isTouch) {
                    image.cssClass = image.cssClass + " " + CONST.PLACEHOLDER_TOUCH_CLASS;
                } else if (AuthoringUtils.isClassic) {
                    image.cssClass = image.cssClass + " " + CONST.PLACEHOLDER_CLASSIC_CLASS;
                }
            } else {
                image.src = "";
            }
        }
        
        imageDefer.resolve(image);
    });
    
    // Adding the constants to the exposed API
    image.CONST = CONST;
    
    // check for image available sizes
    if (image.width() <= 0) {
        image.width = "";
    }
    
    if (image.height() <= 0) {
        image.height = "";
    }
    
    return imageDefer.promise;
    
});
