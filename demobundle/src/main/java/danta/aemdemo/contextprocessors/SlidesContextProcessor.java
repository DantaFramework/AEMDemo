/**
 * Danta AEM Demo Bundle
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

import com.day.cq.wcm.api.Page;
import com.google.common.collect.Sets;
import danta.api.ContentModel;
import danta.api.ExecutionContext;
import danta.api.exceptions.ProcessException;
import danta.core.contextprocessors.AbstractCheckComponentCategoryContextProcessor;
import net.minidev.json.JSONArray;
import net.minidev.json.JSONObject;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Service;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.api.resource.ValueMap;

import java.util.Collections;
import java.util.Set;
import java.util.Iterator;

import static danta.Constants.LOW_PRIORITY;
import static danta.aem.Constants.SLING_HTTP_REQUEST;

@Component
@Service
public class SlidesContextProcessor extends
        AbstractCheckComponentCategoryContextProcessor<ContentModel> {

    private static final Set<String> ANY_OF = Collections.unmodifiableSet(Sets.newHashSet("slides"));
    private JSONArray slides = null;
    private ValueMap properties = null;

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

        final SlingHttpServletRequest request = (SlingHttpServletRequest) executionContext.get(SLING_HTTP_REQUEST);
        JSONObject content = new JSONObject();
        Resource resource = request.getResource();
        properties = resource.getValueMap();

        String listFrom = properties.get("listFrom", String.class);

        if (listFrom != null)
        {
            slides = new JSONArray();
            fetchSlides(listFrom, request.getResourceResolver());
            String controlsType = properties.get("controlsType", "bc");
            boolean showControls = "pn".equals(controlsType);

            content.put("playDelay", properties.get("playSpeed", 6000));
            content.put("transTime", properties.get("transTime", 1000));
            content.put("showControls", showControls);
            content.put("controlsType", showControls ? "" : controlsType);

            content.put("slides", slides);
            contentModel.set("carousel", content);
        }
    }

    private void fetchSlides(String listFrom, ResourceResolver resolver)
    {
        switch (listFrom)
        {
            case "static":
                String[] pages = properties.get("pages", String[].class);
                for (String path : pages) {
                    Resource resource = resolver.getResource(path);
                    if (resource != null) {
                        slides.add(props(resource.adaptTo(Page.class)));
                    }
                }
                break;

            case "children":
                String parentPage = properties.get("parentPage", String.class);
                Page page = resolver.getResource(parentPage).adaptTo(Page.class);
                Iterator<Page> items = page.listChildren();
                while (items.hasNext()) {
                    Page child = items.next();
                    slides.add(props(child));

                }
                break;
        }
    }

    private JSONObject props(Page page)
    {
        JSONObject object = new JSONObject();
        if (page != null) {
            object.put("title", page.getTitle());
            object.put("desc", page.getDescription());
            object.put("path", page.getPath());
            object.put("name", page.getName());
            if (page.getContentResource() != null) {
                object.put("img", page.getContentResource().getValueMap().get("bgImage", String.class));
            }
        }

        return object;
    }
}