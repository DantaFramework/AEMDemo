package layerx.aemdemo.sightly;

import com.adobe.cq.sightly.WCMUsePojo;
import net.minidev.json.JSONArray;
import net.minidev.json.JSONObject;
import org.apache.sling.api.resource.ValueMap;

public class TestSightlyDemo extends WCMUsePojo {

    private JSONArray list;
    private String heading, blurb;

    @Override
    public void activate() throws Exception {

        final ValueMap valueMap = getResource().getValueMap();
        list = new JSONArray();
        JSONObject jsonObject = new JSONObject();

        jsonObject.put("id", "ID 1");
        jsonObject.put("title", "value 1");
        list.add(jsonObject);

        jsonObject = new JSONObject();
        jsonObject.put("id", "ID 2");
        jsonObject.put("title", "value 2");
        list.add(jsonObject);
    }

    public String getHeading() {
        return heading;
    }
    public String getBlurb() {
        return blurb;
    }
    public JSONArray getList() { return list; }
}