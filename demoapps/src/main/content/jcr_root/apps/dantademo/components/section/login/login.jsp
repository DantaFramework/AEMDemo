<%@page session="false"%><%--
  Copyright 1997-2009 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================

  Login component

--%><%
%><%@ page import="java.util.HashMap,
                   java.util.Map,
                   org.apache.commons.lang.StringUtils,
                   com.day.cq.i18n.I18n,
                   com.day.cq.personalization.UserPropertiesUtil,
                   com.day.cq.wcm.api.WCMMode,
                   com.day.cq.wcm.foundation.forms.FormsHelper,
                   com.day.text.Text" %><%
%><%@include file="/libs/foundation/global.jsp"%><%
%><%@taglib prefix="personalization" uri="http://www.day.com/taglibs/cq/personalization/1.0" %><%!
    static final String PARAM_NAME_REASON = "j_reason";
    static final String REASON_KEY_INVALID_LOGIN = "invalid_login";
    static final String REASON_KEY_SESSION_TIMED_OUT = "session_timed_out";
%><%
    String id = Text.getName(resource.getPath());
    I18n i18n = new I18n(slingRequest);

    String action = currentPage.getPath() + "/j_security_check";

    String validationFunctionName = "cq5forms_validate_" + id;
    String alreadySignedInFunctionName = "cq5forms_already_signed_in_" + id;

    String sectionLabel = properties.get("./sectionLabel", String.class);
    if (sectionLabel != null) {
        sectionLabel = i18n.getVar(sectionLabel);
    }
    String usernameLabel = properties.get("./usernameLabel", String.class);
    if (usernameLabel == null) {
        usernameLabel = i18n.get("Username");
    } else {
        usernameLabel = i18n.getVar(usernameLabel);
    }
    String passwordLabel = properties.get("./passwordLabel", String.class);
    if (passwordLabel == null) {
        passwordLabel = i18n.get("Password");
    } else {
        passwordLabel = i18n.getVar(passwordLabel);
    }
    String loginLabel = properties.get("./loginLabel", String.class);
    if (loginLabel == null) {
        loginLabel = i18n.get("Sign In");
    } else {
        loginLabel = i18n.getVar(loginLabel);
    }
    String continueLabel = properties.get("./continueLabel", String.class);
    if (continueLabel == null) {
        continueLabel = i18n.get("Continue");
    } else {
        continueLabel = i18n.getVar(continueLabel);
    }

    String defaultRedirect = FormsHelper.getReferrer(request);
    if (defaultRedirect == null) {
        defaultRedirect = slingRequest.getResourceResolver().map(request, currentPage.getPath());
    }

    // managed URIs should respect sling mapping
    String redirectTo = properties.get("./redirectTo", "");
    if (!StringUtils.isBlank(redirectTo)) {
        redirectTo = slingRequest.getResourceResolver().map(request, redirectTo);
    } else {
        redirectTo = defaultRedirect;
    }

    if( !redirectTo.endsWith(".html")) {
        redirectTo += ".html";
    }


    // used to map readable reason codes to valid reason messages to avoid phishing attacks through j_reason param
    Map<String,String> validReasons = new HashMap<String, String>();
    validReasons.put(REASON_KEY_INVALID_LOGIN, properties.get("./invalidLoginText", i18n.get("User name and password do not match")));
    validReasons.put(REASON_KEY_SESSION_TIMED_OUT, properties.get("./sessionTimedOutText", i18n.get("Session timed out, please login again")));

    String reason = request.getParameter(PARAM_NAME_REASON) != null
            ? request.getParameter(PARAM_NAME_REASON)
            : "";

    if (!StringUtils.isEmpty(reason)) {
        if (validReasons.containsKey(reason)) {
            reason = validReasons.get(reason);
        } else {
            // a reason param value not matching a key in the validReasons map is considered bogus
            log.warn("{} param value '{}' cannot be mapped to a valid reason message: ignoring", PARAM_NAME_REASON, reason);
            reason = "";
        }
    }

    boolean isDisabled = WCMMode.fromRequest(request).equals(WCMMode.DISABLED);

    final boolean isAnonymous = UserPropertiesUtil.isAnonymous(slingRequest);

    if (!isAnonymous) {

%><script type="text/javascript">
    function <%= xssAPI.encodeForHTML(alreadySignedInFunctionName) %>() {
        var url = CQ.shared.HTTP.noCaching("<%= xssAPI.encodeForJSString(redirectTo) %>");
        CQ.shared.Util.load(url);
    }
</script>
<form id="<%= xssAPI.encodeForHTMLAttr(id) %>" name="<%= xssAPI.encodeForHTMLAttr(id) %>">
    <input class="form_button_submit" type="button" value="<%= xssAPI.encodeForHTMLAttr(continueLabel) %>" onclick="<%= xssAPI.encodeForHTMLAttr(alreadySignedInFunctionName) %>()">
</form>
<%
    } else {

%><script type="text/javascript">
    function <%= xssAPI.encodeForHTML(validationFunctionName) %>() {
        if (CQ_Analytics) {
            var u = document.forms['<%=xssAPI.encodeForJSString(id)%>']['j_username'].value;
            if (CQ_Analytics.Sitecatalyst) {
                CQ_Analytics.record({
                    event: "loginAttempt",
                    values: {
                        username:u,
                        loginPage:"<%= xssAPI.encodeForJSString(currentPage.getPath()) %>.html",
                        destinationPage:"<%= xssAPI.encodeForJSString(redirectTo) %>"
                    },
                    componentPath: '<%= xssAPI.encodeForJSString(resource.getResourceType()) %>'
                });
                if (CQ_Analytics.ClickstreamcloudUI && CQ_Analytics.ClickstreamcloudUI.isVisible()) {
                    return false;
                }
            }
        <% if ( !isDisabled ) { %>
            if (CQ_Analytics.ProfileDataMgr) {
                if (u) {
                    <%-- If we're on an Author instance and the ProfileDataMgr is available then simply have
                         the ProfileData impersonate the new user.  Don't actually change the logged in user
                         on the server.    AdobePatentID="B1393"
                    --%>
                    var loaded = CQ_Analytics.ProfileDataMgr.loadProfile(u);
                    if (loaded) {
                        var url = CQ.shared.HTTP.noCaching("<%= xssAPI.encodeForJSString(redirectTo) %>");
                        CQ.shared.Util.load(url);
                    } else {
                        alert("<%=i18n.get("The user could not be found.")%>");
                    }
                    return false;
                }
            }
            return true;    <%-- No client-side solution available; go back to the server. --%>
        <% } else { %>
            if (CQ_Analytics.ProfileDataMgr) {
                CQ_Analytics.ProfileDataMgr.clear();
            }
            return true;    <%-- Always go back to the server ona Publish instance. --%>
        <% } %>
        }
    }
</script>
<%
        if (null != sectionLabel) {
            %><div class="text section"><%= xssAPI.encodeForHTML(sectionLabel) %></div>
<%      }

        if (reason.length() > 0) {
            %><div class="loginerror"><%=xssAPI.encodeForHTML(i18n.getVar(reason))%></div>
<%      }

%><form id="<%= xssAPI.encodeForHTMLAttr(id) %>" name="<%= xssAPI.encodeForHTMLAttr(id) %>"
        method="POST" action="<%= xssAPI.getValidHref(action) %>" enctype="multipart/form-data"
        onsubmit="return <%= xssAPI.encodeForHTMLAttr(validationFunctionName) %>();">
    <input type="hidden" name="resource" value="<%= xssAPI.encodeForHTMLAttr(redirectTo) %>">
    <input type="hidden" name="_charset_" value="UTF-8"/>
    <table class="login-form">
        <tr>
            <td class="label"><label for="<%= xssAPI.encodeForHTMLAttr(id + "_username")%>"><%= xssAPI.encodeForHTML(usernameLabel) %></label></td>
            <td><input id="<%= xssAPI.encodeForHTMLAttr(id + "_username")%>"
                       class="<%= xssAPI.encodeForHTMLAttr(FormsHelper.getCss(properties, "form_field form_field_text form_" + id + "_username")) %>"
                       name="j_username"/></td>
        </tr>
        <tr>
            <td class="label"><label for="<%= xssAPI.encodeForHTMLAttr(id + "_password")%>"><%= xssAPI.encodeForHTML(passwordLabel) %></label></td>
            <td><input id="<%= xssAPI.encodeForHTMLAttr(id + "_password")%>"
                       class="<%= xssAPI.encodeForHTMLAttr(FormsHelper.getCss(properties, "form_field form_field_text form_" + id + "_password")) %>"
                       type="password" autocomplete="off" name="j_password"/></td>
        </tr>
        <tr>
            <td></td>
            <td><input class="form_button_submit" type="submit" value="<%= xssAPI.encodeForHTMLAttr(loginLabel) %>"></td>
        </tr>
    </table>
</form>
<%
    }
%>
