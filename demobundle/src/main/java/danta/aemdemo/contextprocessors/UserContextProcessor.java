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