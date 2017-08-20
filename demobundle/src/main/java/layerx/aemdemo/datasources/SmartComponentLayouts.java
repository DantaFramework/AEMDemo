package layerx.aemdemo.datasources;

import com.adobe.cq.sightly.WCMUsePojo;
import com.adobe.granite.ui.components.ds.DataSource;
import com.adobe.granite.ui.components.ds.SimpleDataSource;
import com.adobe.granite.ui.components.ds.ValueMapResource;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceMetadata;
import org.apache.sling.api.resource.ValueMap;
import org.apache.sling.api.wrappers.ValueMapDecorator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

public class SmartComponentLayouts extends WCMUsePojo {

    protected final Logger log = LoggerFactory.getLogger(this.getClass());

    @Override
    public void activate() throws Exception {
        Resource datasource = getResource().getChild("datasource");
        if (datasource != null) {
            final List<Resource> fakeResourceList = new ArrayList<>();
            ValueMap vm;
            vm = new ValueMapDecorator(new HashMap());
            vm.put("value", "");
            vm.put("text", "Select one");
            fakeResourceList.add(new ValueMapResource(getResourceResolver(), new ResourceMetadata(), "nt:unstructured", vm));

            String path = getResource().getPath();
            path = path.split("/cq:dialog/")[0];
            path = path.split("/dialog/")[0];
            Resource resource = getResourceResolver().getResource(path);

            if (resource != null && resource.hasChildren()) {
                Iterator<Resource> resourceIterator = resource.listChildren();
                while (resourceIterator.hasNext()) {
                    String value = resourceIterator.next().getName().replaceAll(".html", "");
                    if (value.startsWith("layout_")) {
                        String text = value.replace("layout_", "").replace("_", " ");
                        vm = new ValueMapDecorator(new HashMap());
                        vm.put("value", value);
                        vm.put("text", text);
                        fakeResourceList.add(new ValueMapResource(getResourceResolver(), new ResourceMetadata(), "nt:unstructured", vm));
                    }
                }
            }

            //Create a DataSource that is used to populate the drop-down control
            DataSource ds = new SimpleDataSource(fakeResourceList.iterator());
            getRequest().setAttribute(DataSource.class.getName(), ds);
        }
    }
}