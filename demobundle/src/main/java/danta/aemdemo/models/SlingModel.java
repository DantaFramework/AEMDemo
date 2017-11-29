package danta.aemdemo.models;

import org.apache.sling.api.resource.Resource;
import org.apache.sling.models.annotations.Default;
import org.apache.sling.models.annotations.Model;

import javax.annotation.PostConstruct;
import javax.inject.Inject;
import javax.inject.Named;


/**
 * Created by jankowiak on 10/26/17.
 * danta.aemdemo.models
 */

@Model(adaptables=Resource.class)
public class SlingModel {

    @Inject
    @Named("sling:resourceType") @Default(values = "No resourceType")
    protected String resourceType;

    private String message;

    @PostConstruct
    protected void init(){
        message = "Hello From SlingModels for the Resource Type: " + resourceType;
    }

    public String getMessage(){
        return message;
    }

}