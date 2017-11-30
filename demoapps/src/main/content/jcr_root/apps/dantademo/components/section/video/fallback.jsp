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
  Final Fallback after Flash

  ==============================================================================

--%><%@ include file="/libs/foundation/global.jsp" %><%
%><%= currentStyle.get("fallbackMessage", "No video available.") %>
