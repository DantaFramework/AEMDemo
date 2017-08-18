<%@page session="false"%><%--
  Copyright 1997-2008 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================

  Inheritance Paragraph System

--%><%@ page import="java.util.HashSet,
                     java.util.Set,
                     com.day.cq.commons.jcr.JcrConstants,
                     com.day.cq.wcm.api.WCMMode,
                     com.day.cq.wcm.api.components.IncludeOptions,
                     com.day.cq.wcm.foundation.Paragraph,
                     com.day.cq.wcm.foundation.ParagraphSystem" %><%

%><%@include file="/libs/foundation/global.jsp"%><%

    if(editContext!=null && WCMMode.fromRequest(request) == WCMMode.EDIT) {
        editContext.getEditConfig().setOrderable(false);
    }

    String newType = resource.getResourceType() + "/new";
    boolean hasColumns = false;
    boolean hasFake = false;
    ParagraphSystem parSys = ParagraphSystem.create(resource, slingRequest);

    // START: FETCH & INCLUDE LAYOUT BY SPAN COMPONENT SETTING
    String spanComponentResourceType = "layerxaemdemo/components/section/spancomponent";
    String layout = "default";
    String spanComponentPath = resource.getPath() + "/spancomponent";
    Resource spanComponentResource = slingRequest.getResourceResolver().getResource(spanComponentPath);
    if (spanComponentResource != null) {
        ValueMap spanCompResVM = spanComponentResource.getValueMap();
        if (spanCompResVM.containsKey("style")) {
            String[] arr = spanComponentResource.getPath().split("/jcr:content/");
            String[] arr2 = arr[1].split("/");
            String parsysPos = arr2[0].replace("fwpar", "").replace("fwipar", "");
            if (parsysPos.equals("1")) {
                layout = spanCompResVM.get("style", String.class);
            }
        }
    }

    if (layout.equals("top-left")) {
        %><%@include file="includes/top-left.jsp"%><%
    }
    else if (layout.equals("top-right")) {
        %><%@include file="includes/top-right.jsp"%><%
    }
    else {
        %><%@include file="includes/default.jsp"%><%
    }
    // END: FETCH & INCLUDE LAYOUT BY SPAN COMPONENT SETTING

    if (hasColumns)
    {
        // close divs in case END missing. and clear floating
        %></div></div><div style="clear:both"></div><%
    }

    // include fake inheritance if not present in the content
    if (!hasFake)
    {
        // draw new bar before inherited ones
        %><div class="section"><cq:include path="*" resourceType="<%= newType %>"/></div><%

        IncludeOptions.getOptions(request, true).forceCellName("");
        //String path = resource.getPath() + "/iparsys_fake_par";
        String path = resource.getPath() + "/iparsys_fake_par";
        String resType = resource.getResourceType() + "/par";
        %><div class="iparys_inherited"><cq:include path="<%= path %>" resourceType="<%= resType %>"/></div><%
    }
    else
    {
        // new bar
        if (editContext != null) {
            editContext.setAttribute("currentResource", null);
            // draw 'new' bar
            IncludeOptions.getOptions(request, true).getCssClassNames().add("section");
            %><cq:include path="*" resourceType="<%= newType %>"/><%
        }
    }
%>