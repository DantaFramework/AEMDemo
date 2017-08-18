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

  Inheritance Paragraph System - Par

--%><%@ page import="com.day.text.Text,
            java.util.Iterator,
            java.util.LinkedList, java.util.List,
            org.apache.sling.api.SlingHttpServletRequest,
            com.day.cq.commons.jcr.JcrConstants,
            com.day.cq.wcm.api.WCMMode,
            com.day.cq.wcm.api.components.Toolbar,
            com.day.cq.wcm.api.components.IncludeOptions,
            com.day.cq.wcm.foundation.Paragraph,
            com.day.cq.wcm.foundation.ParagraphSystem,
            com.day.cq.wcm.foundation.Placeholder,
            com.day.cq.wcm.api.Page" %><%
%><%@include file="/libs/foundation/global.jsp"%><%

    // if inheritance is canceled, do nothing
    if (properties != null && properties.get("inheritance", "").equals("cancel")) {
        if (editContext != null && WCMMode.fromRequest(request) == WCMMode.EDIT) {
            String text = "Inheritance disabled";
            editContext.getEditConfig().getToolbar().set(0, new Toolbar.Label(text));
            %><%= Placeholder.getDefaultPlaceholder(slingRequest, text, "", "cq-marker-start") %><%
        }
        return;
    }

    // get page content relative path to the parsys
    String parSysPath = Text.getRelativeParent(resource.getPath(), 1);
    //resource page can be null for pages like /content/dam/geometrixx/documents/GeoMetrixx_Banking.indd/jcr:content/renditions/page
    if (resourcePage != null) {
        parSysPath = parSysPath.substring(resourcePage.getContentResource().getPath().length() + 1);
    } else {
        parSysPath = parSysPath.substring(currentPage.getContentResource().getPath().length() + 1);
    }

    // Note the resourcePage vs currentPage inheritance https://issues.adobe.com/browse/CQ5-3910
    Page parent = currentPage.getParent();
    LinkedList<Paragraph> paras = new LinkedList<Paragraph>();
    if (!addParas(paras, parent, parSysPath, slingRequest))
    {
        if (editContext != null && WCMMode.fromRequest(request) == WCMMode.EDIT) {
            String text = "Parent canceled inheritance";
            editContext.getEditConfig().getToolbar().set(0, new Toolbar.Label(text));
            %><%= Placeholder.getDefaultPlaceholder(slingRequest, text, "", "cq-marker-start") %><%
        }
        return;
    }
    else
    {
        %><%= Placeholder.getDefaultPlaceholder(slingRequest, "Inherited Paragraph System", "", "cq-marker-start") %><%
    }

    // disable WCM for inherited components
    WCMMode mode = WCMMode.DISABLED.toRequest(request);
    boolean hasColumns = false;

    try {

        // START: FETCH & INCLUDE LAYOUT BY SPAN COMPONENT SETTING
        String spanComponentResourceType = "layerxaemdemo/components/section/spancomponent";
        String spanComponentPath = null;
        String layout = "default";
        for (Paragraph par: paras)
        {
            if (par.getResourceType().equals(spanComponentResourceType)) {
                spanComponentPath = par.getPath();
                break;
            }
        }
        if (spanComponentPath != null) {
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
        }

        if (layout.equals("top-left")) {
            %><%@include file="inheritance-includes/top-left.jsp"%><%
        }
        else if (layout.equals("top-right")) {
            %><%@include file="inheritance-includes/top-right.jsp"%><%
        }
        else {
            %><%@include file="inheritance-includes/default.jsp"%><%
        }
        // END: FETCH & INCLUDE LAYOUT BY SPAN COMPONENT SETTING
    }
    finally {
        mode.toRequest(request);
    }

    if (hasColumns) {
        // close divs in case END missing. and clear floating
        %></div></div><div style="clear:both"></div><%
    }

%><%!

    private boolean addParas(List<Paragraph> paras, Page parent, String parSysPath, SlingHttpServletRequest req) {

        if (parent == null) {
            return true;
        }
        // get the parent parsys
        Resource parSysRes = parent.getContentResource(parSysPath);

        // check if parent parsys canceled inheritance to its children
        if (parSysRes != null && parSysRes.adaptTo(ValueMap.class).get("inheritance", "").equals("cancel")) {
            return false;
        }

        // iterate over paras
        boolean hasFake = false;
        if (parSysRes != null) {
            ParagraphSystem parSys = ParagraphSystem.create(parSysRes, req);
            for (Paragraph par: parSys.paragraphs()) {
                Resource r = (Resource) par;
                if (r.getResourceType().endsWith("/iparsys/par")) {
                    hasFake = true;
                    // if inheritance is canceled, do nothing
                    ValueMap properties = r.adaptTo(ValueMap.class);
                    if (!properties.get("inheritance", "").equals("cancel")) {
                        addParas(paras, parent.getParent(), parSysPath, req);
                    }
                } else {
                    paras.add(par);
                }
            }
        }
        if (!hasFake) {
            // if not fake paragraph is initialized, try to inherit anyways.
            addParas(paras, parent.getParent(), parSysPath, req);
        }
        return true;
    }
%>