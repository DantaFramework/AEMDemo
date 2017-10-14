package danta.aemdemo.contextprocessors;

import com.google.common.collect.Sets;
import danta.api.ContentModel;
import danta.api.ExecutionContext;
import danta.api.exceptions.ProcessException;
import danta.core.contextprocessors.AbstractCheckComponentCategoryContextProcessor;
import net.minidev.json.JSONValue;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Service;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ValueMap;
import org.apache.sling.commons.json.JSONArray;
import org.apache.sling.commons.json.JSONException;
import org.apache.sling.commons.json.JSONObject;

import java.util.Collections;
import java.util.Map;
import java.util.Set;

import static danta.Constants.LOW_PRIORITY;
import static danta.Constants.RESOURCE_CONTENT_KEY;
import static danta.aem.Constants.SLING_HTTP_REQUEST;

@Component
@Service
public class ColumnControlCtxtProcessor extends
        AbstractCheckComponentCategoryContextProcessor<ContentModel> {

    private static final String PROP_NAME_NUMCOLS = "numcols";
    private static final String PROP_NAME_COL_PFX = "col";
    private static final String NUM = "num";
    private static final String COLS = "cols";

    private static final Set<String> ANY_OF = Collections.unmodifiableSet(Sets.newHashSet("xkcolumncontrol"));

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
        Map<String, Object> contentObject =  (Map<String, Object>)contentModel.get(RESOURCE_CONTENT_KEY);
        final Resource resource = request.getResource();
        if (resource != null) {
            final ValueMap valueMap = resource.getValueMap();
            if (valueMap != null && valueMap.containsKey(PROP_NAME_NUMCOLS)) {
                int numCols = valueMap.get(PROP_NAME_NUMCOLS, 0);
                if (numCols > 0) {
                    JSONArray jsonArray = new JSONArray();
                    for (int i = 1; i <= numCols; i++) {
                        String num = valueMap.get(PROP_NAME_COL_PFX+i, String.class);
                        if (num != null) {
                            try {
                                JSONObject jsonObject = new JSONObject();
                                jsonObject.put(PROP_NAME_COL_PFX+i, true);
                                jsonObject.put(NUM, num);
                                jsonArray.put(jsonObject);
                            }
                            catch (JSONException e) {
                                log.error(e.getMessage(), e);
                            }
                        }
                    }
                    if (jsonArray.length() > 0) {
                        Object value = JSONValue.parse(jsonArray.toString());
                        contentObject.put(COLS, value);
                    }
                }
            }
        }
    }
}