package danta.aemdemo.datasources;

import com.adobe.cq.sightly.WCMUsePojo;
import com.adobe.granite.ui.components.ds.DataSource;
import com.adobe.granite.ui.components.ds.SimpleDataSource;
import com.adobe.granite.ui.components.ds.ValueMapResource;
import com.google.common.collect.Sets;
import danta.api.ExecutionContext;
import danta.api.TemplateContentModel;
import danta.api.exceptions.ProcessException;
import danta.core.contextprocessors.AbstractCheckComponentCategoryContextProcessor;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Service;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceMetadata;
import org.apache.sling.api.resource.ValueMap;
import org.apache.sling.api.wrappers.ValueMapDecorator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.*;

import static danta.Constants.LOW_PRIORITY;
import static danta.aem.Constants.JCR_CONTENT;
import static danta.aem.Constants.SLING_HTTP_REQUEST;

@Component
@Service
public class DantaSmartComponentLayouts
        extends AbstractCheckComponentCategoryContextProcessor<TemplateContentModel> {

    @Override
    public Set<String> anyOf() {
        return Sets.newHashSet("testdanta-smartcomponentlayouts");
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
            final Resource resource = request.getResource();
            Resource datasource = resource.getChild("datasource");
            contentModel.set("datasource", datasource.getPath());
        }
        catch (Exception e) {
            log.error(e.getMessage(), e);
        }
    }
}