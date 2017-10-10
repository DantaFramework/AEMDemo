<%@page session="false"%><%@ page import="com.day.cq.wcm.foundation.Placeholder" %>
<%--
  Copyright 1997-2008 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================

  Table component

  Draws a HTML table

--%><%@include file="/libs/foundation/global.jsp"%><%
    String classicPlaceholder = "<img src=\"/libs/cq/ui/resources/0.gif\" class=\"cq-table-placeholder\" alt=\"\">";
    String placeholder = Placeholder.getDefaultPlaceholder(slingRequest, component, classicPlaceholder);

    if (properties.get("tableData",null) == null ){
        String showAltComponentName = request.getParameter("showAltComponentName");
        if(showAltComponentName!=null && showAltComponentName.equalsIgnoreCase("true")) { %>
            <h2 class="cq-paragraphreference-thumbnail-text"><%= xssAPI.encodeForHTML(resource.getName()) %></h2>
        <%}
    }
    %><cq:text property="tableData"
               escapeXml="false"
               placeholder="<%= placeholder %>"
    />
