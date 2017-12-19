/**
 * Danta AEM Demo Bunlde
 *
 * Copyright (C) 2017 Tikal Technologies, Inc. All rights reserved.
 *
 * Licensed under GNU Affero General Public License, Version v3.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.gnu.org/licenses/agpl-3.0.txt
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied;
 * without even the implied warranty of MERCHANTABILITY.
 * See the License for more details.
 */

package danta.aemdemo.contextprocessors;

import danta.aem.Constants;
import danta.api.ContentModel;
import danta.api.ExecutionContext;
import danta.api.exceptions.ProcessException;
import danta.core.contextprocessors.AbstractContextProcessor;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Service;
import org.apache.jackrabbit.api.security.user.User;
import org.apache.sling.api.SlingHttpServletRequest;

import static danta.aem.Constants.SLING_HTTP_REQUEST;

@Component
@Service
public class UserContextProcessor extends AbstractContextProcessor {

    @Override
    public boolean accepts (final ExecutionContext executionContext) {
        final SlingHttpServletRequest request=(SlingHttpServletRequest) executionContext.get(Constants.SLING_HTTP_REQUEST);
        if (request.getResource() != null) {
            final String resourceType = request.getResource().getResourceType();
            if (resourceType != null) {
                return resourceType.startsWith("dantademo/components/section/footer");
            }
        }
        return false;
    }

    @Override
    public void process(final ExecutionContext executionContext, final ContentModel contentModel)
            throws ProcessException {

        try {
            final SlingHttpServletRequest request = (SlingHttpServletRequest) executionContext.get(SLING_HTTP_REQUEST);
            final User user = request.getResource().getResourceResolver().adaptTo(User.class);

            final String userId=user.getID();
            final String lastName=user.getProperty("./profile/familyName")!=null?user.getProperty("./profile/familyName")[0].getString():"";
            final String givenName=user.getProperty("./profile/givenName")!=null?user.getProperty("./profile/givenName")[0].getString():"";


            contentModel.set("user.id", userId);
            contentModel.set("user.last-name", lastName);
            contentModel.set("user.given-name", givenName);

        } catch (Exception e) {
            throw new ProcessException(e);
        }
    }
}