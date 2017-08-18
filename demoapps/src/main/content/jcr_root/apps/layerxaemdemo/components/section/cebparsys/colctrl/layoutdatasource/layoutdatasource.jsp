    <%--
      ADOBE CONFIDENTIAL

      Copyright 2013 Adobe Systems Incorporated
      All Rights Reserved.

      NOTICE:  All information contained herein is, and remains
      the property of Adobe Systems Incorporated and its suppliers,
      if any.  The intellectual and technical concepts contained
      herein are proprietary to Adobe Systems Incorporated and its
      suppliers and may be covered by U.S. and Foreign Patents,
      patents in process, and are protected by trade secret or copyright law.
      Dissemination of this information or reproduction of this material
      is strictly forbidden unless prior written permission is obtained
      from Adobe Systems Incorporated.
    --%><%@page session="false"
                import="java.util.ArrayList,
                  com.day.cq.wcm.api.designer.Designer,
                  java.util.Iterator,
                  java.util.HashMap,
                  java.util.Map,
                  com.day.cq.commons.jcr.JcrConstants,
                  com.adobe.granite.ui.components.Config,
                  org.apache.sling.api.resource.ResourceResolver,
                  org.apache.sling.api.wrappers.ValueMapDecorator,
                  com.adobe.granite.ui.components.ds.DataSource,
                  com.adobe.granite.ui.components.ds.AbstractDataSource,
                  com.adobe.granite.ui.components.ds.EmptyDataSource,
                  com.adobe.granite.ui.components.ds.SimpleDataSource,
                  com.adobe.granite.ui.components.ds.ValueMapResource,
				  org.apache.sling.api.resource.ResourceMetadata,
				  org.apache.sling.api.resource.Resource,
				  org.apache.sling.api.resource.SyntheticResource" %><%
        %><%@include file="/libs/foundation/global.jsp"%><%
    // get the styles for this content resource
    Style contentStyle = designer.getStyle(resourceResolver.getResource(slingRequest.getRequestPathInfo().getSuffix()));
    // get the column options
    String layouts = contentStyle.get("layouts",String.class);
    // if no layout are set
    if (layouts == null || layouts.equals("")){
        // return empty data source
        request.setAttribute(DataSource.class.getName(), EmptyDataSource.instance());
        return;
    }

    // contains final list of synthetic resources
    ArrayList<Resource> resourceList = new ArrayList<Resource>();

    // the options are stored with line feed separation
    String[] options = layouts.split("\n");
    for (int i = 0; i < options.length;i++){
        // text and value are separated by tab
        String[] option = options[i].split("\t");
        // create a ValueMap
        HashMap map = new HashMap();
        map.put("value",option[0]);
        map.put("text",option[1]);
        // create a synthetic resource
        ValueMapResource valMapResource = new ValueMapResource(resourceResolver,new ResourceMetadata(),"",
            new ValueMapDecorator(map));
        // add resource to list
        resourceList.add(valMapResource);
    }

    // create a new data source object, place it in request for consumption by data source mechanism
    request.setAttribute(DataSource.class.getName(), new SimpleDataSource(resourceList.iterator()));
%>