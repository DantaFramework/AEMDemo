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
 * Text and Image component JS Use-api script
 */
use(["/libs/wcm/foundation/components/utils/AuthoringUtils.js",
     "/libs/sightly/js/3rd-party/q.js"], function (AuthoringUtils, Q) {
    
    var textimage = {};
    
    var CONST = {
        PROP_ALIGNMENT: "alignment",
        PROP_TEXT: "text"
    };
    
    // The container CSS class name is what defines the alignment
    textimage.alignment = granite.resource.properties[CONST.PROP_ALIGNMENT]
            || currentStyle.get(CONST.PROP_ALIGNMENT, "");

    var hasContentDeferred = Q.defer();

    textimage.hasText = granite.resource.properties[CONST.PROP_TEXT] ? true : false;

    granite.resource.resolve(granite.resource.path + "/image").then(function (imageResource) {
        if (imageResource.properties["fileReference"]) {
            hasContentDeferred.resolve(true);
        } else {
            granite.resource.resolve(granite.resource.path + "/image/file").then(function (localImage) {
                hasContentDeferred.resolve(true);
            }, function () {
                hasContentDeferred.resolve(false);
            });
        }
    }, function () {
        hasContentDeferred.resolve(false);
    });

    // TODO: change currentStyle to wcm.currentStyle
    // Adding the constants to the exposed API
    textimage.CONST = CONST;

    textimage.isTouch = AuthoringUtils.isTouch;

    textimage.hasContent = hasContentDeferred.promise;

    return textimage;

});
