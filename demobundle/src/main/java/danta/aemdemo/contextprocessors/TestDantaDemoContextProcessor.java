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

import com.google.common.collect.Sets;
import danta.core.contextprocessors.AbstractCheckComponentCategoryContextProcessor;
import danta.api.ContentModel;
import danta.api.ExecutionContext;
import danta.api.exceptions.ProcessException;
import net.minidev.json.JSONArray;
import net.minidev.json.JSONObject;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Service;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.resource.ValueMap;

import java.util.Collections;
import java.util.Set;

import static danta.Constants.LOW_PRIORITY;
import static danta.aem.Constants.SLING_HTTP_REQUEST;


@Component
@Service
public class TestDantaDemoContextProcessor extends
        AbstractCheckComponentCategoryContextProcessor<ContentModel> {

    private static final Set<String> ANY_OF = Collections.unmodifiableSet(Sets.newHashSet("testdanta"));

    @Override
    public Set<String> anyOf() {
        return ANY_OF;
    }

    @Override
    public int priority() {
        return LOW_PRIORITY;
    }

    @Override
    public void process(ExecutionContext executionContext, ContentModel contentModel)
            throws ProcessException {

        try {
            final SlingHttpServletRequest request = (SlingHttpServletRequest) executionContext.get(SLING_HTTP_REQUEST);
            JSONArray list = new JSONArray();

            JSONObject jsonObject = new JSONObject();
            jsonObject.put("id", "ID 1");
            jsonObject.put("title", "value 1");
            list.add(jsonObject);

            jsonObject = new JSONObject();
            jsonObject.put("id", "ID 2");
            jsonObject.put("title", "value 2");
            list.add(jsonObject);

            contentModel.set("content.list", list);

            ValueMap valueMap = request.getResource().getValueMap();
            if (valueMap.containsKey("style")) {
                contentModel.set("content."+valueMap.get("style", String.class), true);
            }
            if ("test me".equals(valueMap.get("heading", String.class))) {
                contentModel.set("content.heading", "My test me heading: "+valueMap.get("heading", String.class) + " ...");
            }

        }
        catch (Exception e) {
            log.error(e.getMessage(), e);
        }
    }
}
