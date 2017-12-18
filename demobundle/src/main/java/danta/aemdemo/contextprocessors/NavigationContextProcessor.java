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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.*;

import static danta.Constants.GLOBAL_PROPERTIES_KEY;
import static danta.Constants.LOW_PRIORITY;
import static danta.aem.Constants.SLING_HTTP_REQUEST;

@Component
@Service
public class NavigationContextProcessor extends
        AbstractCheckComponentCategoryContextProcessor<ContentModel> {

    //
    private static final Set<String> ANY_OF = Collections.unmodifiableSet(Sets.newHashSet("navigation"));
    private final Logger log = LoggerFactory.getLogger(getClass());

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
        try {
            Map<String, Object> objectMap = contentModel.getAs(GLOBAL_PROPERTIES_KEY, Map.class);
            final String navigationPath = String.valueOf(objectMap.get("navigationPath"));

            /*
             * Opinionated navigation builder (creates a list of pages based on a path, adds the parent page and the
             * children to the navigation
             */
            if (navigationPath != null) {
                JSONArray pages = new JSONArray();
                ResourceResolver resolver = request.getResourceResolver();
                Page page = resolver.getResource(navigationPath).adaptTo(Page.class);
                pages.add(props(page));
                Iterator<Page> items = page.listChildren();
                while (items.hasNext()) {
                    Page child = items.next();
                    pages.add(props(child));

                }

                content.put("pages", pages);
                contentModel.set("navigation", content);


            }
        } catch (Exception e) {
            log.info(e.getMessage());
        }
    }

    private JSONObject props(Page page)
    {
        JSONObject object = new JSONObject();

        // If a page doesn't have a navigation title it will default to the page title.
        if (page != null) {
            String title = page.getNavigationTitle();
            if(null == title){
                title = page.getTitle();
            }
            object.put("title", title);
            object.put("path", page.getPath());
        }

        return object;
    }
}