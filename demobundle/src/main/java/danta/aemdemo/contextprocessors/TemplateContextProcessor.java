package danta.aemdemo.contextprocessors;

import com.google.common.collect.Sets;
import danta.api.ExecutionContext;
import danta.api.TemplateContentModel;
import danta.api.exceptions.ProcessException;
import danta.core.contextprocessors.AbstractCheckComponentCategoryContextProcessor;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Service;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ValueMap;
import java.util.Set;

import static danta.Constants.*;
import static danta.aem.Constants.*;

@Component
@Service
public class TemplateContextProcessor
        extends AbstractCheckComponentCategoryContextProcessor<TemplateContentModel> {

    @Override
    public Set<String> anyOf() {
        return Sets.newHashSet("dantaaemdemo");
    }

    @Override
    public int priority() {
        return LOW_PRIORITY;
    }

    @Override
    public void process(final ExecutionContext executionContext, final TemplateContentModel contentModel)
            throws ProcessException {
        try {
            final SlingHttpServletRequest request = (SlingHttpServletRequest) executionContext.get(SLING_HTTP_REQUEST);
            contentModel.set("page.bgImage", getInheritanceProperty(request.getResource().getParent(), "bgImage"));
            contentModel.set("page.bgposition", getInheritanceProperty(request.getResource().getParent(), "bgposition"));
            contentModel.set("page.siteID", getInheritanceProperty(request.getResource().getParent(), "jcr:siteID"));
        }
        catch (Exception e) {
            log.error(e.getMessage(), e);
        }
    }

    private String getInheritanceProperty(Resource res, String prop) {

        ValueMap valueMap = res.getChild(JCR_CONTENT).getValueMap();
        if (valueMap.containsKey(prop)) {
            return valueMap.get(prop, String.class);
        }
        else if (res.getParent() != null && res.getParent().getChild(JCR_CONTENT) != null) {
            return getInheritanceProperty(res.getParent(), prop);
        }
        else {
            return null;
        }
    }

}
