<%@page session="false"%><%--
  Copyright 1997-2010 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================

  HTML5 video component
  Render <source> elements

  ==============================================================================

--%><%@ include file="/libs/foundation/global.jsp" %><%
%><%@ page import="com.day.cq.dam.video.VideoProfile,
                   com.day.cq.dam.api.Asset,
                   com.day.cq.dam.api.Rendition" %><%

    Asset asset = (Asset) request.getAttribute("video_asset"); // set by video.jsp
    
    // render each profiles as a <source> element
    for (String profile : currentStyle.get("profiles", new String[0])) {
        VideoProfile videoProfile = VideoProfile.get(resourceResolver, profile);
        
        if (videoProfile != null) {
            Rendition rendition = videoProfile.getRendition(asset);
            if (rendition != null) {

%><source src="<%= xssAPI.getValidHref(request.getContextPath() + videoProfile.getHtmlSource(rendition)) %>" type='<%= xssAPI.encodeForHTMLAttr(videoProfile.getHtmlType()) %>' /><%

            }
            
        }
    }
%>
