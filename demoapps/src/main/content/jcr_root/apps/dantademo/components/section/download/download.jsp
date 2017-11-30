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

  Download component

  Draws a download link with icons.

--%><%@ page import="com.day.cq.wcm.api.WCMMode,
                     com.day.cq.wcm.api.components.DropTarget,
                     com.day.cq.wcm.foundation.Download,
                     com.day.cq.wcm.foundation.Placeholder,
                     com.day.cq.xss.ProtectionContext,
                     com.day.cq.xss.XSSProtectionException,
                     com.day.cq.xss.XSSProtectionService,
                     com.day.text.Text,
                     org.apache.commons.lang3.StringEscapeUtils,
                     java.util.Map" %><%
%><%@include file="/libs/foundation/global.jsp"%><%
    //drop target css class = dd prefix + name of the drop target in the edit config
    String ddClassName = DropTarget.CSS_CLASS_PREFIX + "file";

    Download dld = new Download(resource);
    if (dld.hasContent()) {
        dld.addCssClass(ddClassName);
        String title = dld.getTitle(true);
        String href = Text.escape(dld.getHref(), '%', true);
        String displayText = dld.getInnerHtml() == null ? dld.getFileName() : dld.getInnerHtml().toString();
        String description = dld.getDescription();
        XSSProtectionService xss = sling.getService(XSSProtectionService.class);
        if (xss != null) {
            try {
                displayText = xss.protectForContext(ProtectionContext.PLAIN_HTML_CONTENT, displayText);
            } catch (XSSProtectionException e) {
                log.warn("Unable to protect link display text from XSS: {}", displayText);
            }
            try {
                description = xss.protectForContext(ProtectionContext.PLAIN_HTML_CONTENT, description);
            } catch (XSSProtectionException e) {
                log.warn("Unable to protect link description from XSS: {}", description);
            }
        }

        %><div>
            <span class="icon type_<%= dld.getIconType() %>"><img src="/etc/designs/default/0.gif" alt="*"></span>
            <a href="<%= href%>" title="<%=StringEscapeUtils.escapeHtml4(title)%>" 
               onclick="CQ_Analytics.record({event: 'startDownload', values: { downloadLink: '<%=href%>' }, collect:  false, options: { obj: this, defaultLinkType: 'd' }, componentPath: '<%=xssAPI.encodeForJSString(resource.getResourceType())%>'})"<%
                Map<String,String> attrs = dld.getAttributes();
            if ( attrs!= null) {
                for (Map.Entry e : attrs.entrySet()) {
                    out.print(StringEscapeUtils.escapeHtml4(e.getKey().toString()));
                    out.print("=\"");
                    out.print(StringEscapeUtils.escapeHtml4(e.getValue().toString()));
                    out.print("\"");
                }
            }%>
        ><%= StringEscapeUtils.escapeHtml4(displayText) %></a><br>
            <small><%= StringEscapeUtils.escapeHtml4(description) %></small>
        </div><div class="clear"></div><%
        
    } else {
        if (Placeholder.isAuthoringUIModeTouch(slingRequest) || WCMMode.fromRequest(request) == WCMMode.EDIT) {
            String classicPlaceholder =
                    "<img src=\"/libs/cq/ui/resources/0.gif\" class=\"cq-file-placeholder " + ddClassName + "\" alt=\"\">";
            String placeholder = Placeholder.getDefaultPlaceholder(slingRequest, component, classicPlaceholder,
                    ddClassName, null);
        %><%= placeholder %><%
        } else {
            String showAltComponentName = request.getParameter("showAltComponentName");
            if(showAltComponentName!=null && showAltComponentName.equalsIgnoreCase("true")) { %>
                <h2 class="cq-paragraphreference-thumbnail-text"><%= xssAPI.encodeForHTML(resource.getName()) %></h2>
            <%}
        }
    }
%>
