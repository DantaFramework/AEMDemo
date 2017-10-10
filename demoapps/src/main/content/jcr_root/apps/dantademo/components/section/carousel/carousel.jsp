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

  Carousel component

--%><%@include file="/libs/foundation/global.jsp"%><%
%><%@ page import="com.day.cq.commons.Doctype,
                   com.day.cq.wcm.api.WCMMode,
                   com.day.cq.wcm.api.components.DropTarget,
                   com.day.cq.wcm.foundation.Image,
                   com.day.cq.wcm.foundation.List,
                   com.day.cq.wcm.foundation.Placeholder,
                   com.day.text.Text,
                   java.util.Iterator,
                   java.util.LinkedHashMap, java.util.Map"
%><%@include file="/libs/foundation/global.jsp"%><%
    %><cq:includeClientLib js="cq.jquery"/><%
    String xs = Doctype.isXHTML(request) ? "/" : "";

    if (WCMMode.fromRequest(request) == WCMMode.EDIT) {
        //drop target css class = dd prefix + name of the drop target in the edit config
        String ddClassName = DropTarget.CSS_CLASS_PREFIX + "pages";
        %><div class="<%= ddClassName %>"><%
    }

    // initialize the list
    %><cq:include script="init.jsp"/><%
    List list = (List)request.getAttribute("list");
    if (!list.isEmpty()) {
        // config options
        int playDelay = properties.get("playSpeed", 6000);
        int transTime = properties.get("transTime", 1000);

        // todo: make default designeable
        String controlsType = properties.get("controlsType", "bc");
        boolean showControls = "pn".equals(controlsType);
        if (showControls) {
            controlsType = "";
        } else {
            controlsType = "-" + controlsType; 
        }

        // first shove all slides into a map in order to calculate distinct ids
        Map<String, Slide> slides = new LinkedHashMap<String, Slide>();
        Iterator<Page> items = list.getPages();
        String pfx = "cqc-" + Text.getName(resource.getPath()) + "-";
        while (items.hasNext()) {
            Slide slide = new Slide(items.next());
            String name = pfx + slide.name;
            int idx = 0;
            while (slides.containsKey(name)) {
                name = pfx + slide.name + (idx++);
            }
            slide.name = name;
            // prepend context path to img
            slide.img = request.getContextPath() + slide.img;
            slides.put(name, slide);
        }

        %><div class="cq-carousel">
            <var title="play-delay"><%= playDelay %></var>
            <var title="transition-time"><%= transTime %></var>

            <%-- write the actual slides --%>
            <div class="cq-carousel-banners" >
                <c:forEach var="slide" varStatus="loop" items="<%= slides.values() %>">
                <% Slide slide = (Slide) pageContext.getAttribute("slide"); %>
                <div style="${loop.first ? "left: 0px; opacity: 1;" : "left: -1000px; opacity: 0;"}" id="<%= xssAPI.encodeForHTMLAttr(slide.name) %>" class="cq-carousel-banner-item">
                    <c:if test="${!empty slide.img}">
                        <a href="<%= xssAPI.getValidHref(slide.path) %>.html" title="<%= xssAPI.encodeForHTMLAttr(slide.title) %>">
                            <img src="/etc/designs/default/0.gif" style="background-image:url(<%= xssAPI.getValidHref(slide.img) %>)" alt="<%= xssAPI.encodeForHTMLAttr(slide.title) %>"<%= xs %>>
                        </a>
                    </c:if>
                    <h3><%= xssAPI.encodeForHTML(slide.title) %></h3>
                    <p><%= xssAPI.encodeForHTML(slide.desc) %><br<%= xs %>>
                        <a href="<%= xssAPI.getValidHref(slide.path) %>.html">Read More</a>
                    </p>
                </div>
                </c:forEach>
            </div>

            <%-- defines the controls --%>
            <c:if test="<%= showControls %>">
                <div class="cq-carousel-controls">
                    <a class="cq-carousel-control-prev" href="#" style="display:none"></a>
                    <a class="cq-carousel-control-next" href="#" style="display:none"></a>
                </div>
            </c:if>

            <%-- write the switches, also needed when disabled --%>
            <div class="cq-carousel-banner-switches<%= xssAPI.encodeForHTMLAttr(controlsType) %>">
                <ul class="cq-carousel-banner-switch">
                    <c:forEach var="slide" varStatus="loop" items="<%= slides.values() %>">
                        <% Slide slide = (Slide) pageContext.getAttribute("slide"); %>
                        <li><a class="${loop.first ? "cq-carousel-active" : ""}" title="<%= xssAPI.encodeForHTMLAttr(slide.title) %>" href="#<%= xssAPI.encodeForHTMLAttr(slide.name) %>"><img src="/etc/designs/default/0.gif" alt="0"<%= xs %>></a></li>
                    </c:forEach>
                </ul>
            </div>

        </div><%
    } else {
        if (Placeholder.isAuthoringUIModeTouch(slingRequest) || WCMMode.fromRequest(request) == WCMMode.EDIT){
            String classicPlaceholder =
                    "<img src=\"/libs/cq/ui/resources/0.gif\" class=\"cq-carousel-placeholder\" alt=\"\">";
            String placeholder = Placeholder.getDefaultPlaceholder(slingRequest, component, classicPlaceholder);
            %><%= placeholder %><%
        } else {
            String showAltComponentName = request.getParameter("showAltComponentName");
            if(showAltComponentName!=null && showAltComponentName.equalsIgnoreCase("true")) { %>
                <h2 class="cq-paragraphreference-thumbnail-text"><%= resource.getName() %></h2>
            <%}
        }

    }

    if (WCMMode.fromRequest(request) == WCMMode.EDIT) {
        %></div><%
    }

%><%!

    /**
     * Container class for slides
     */
    public static final class Slide {
        private final Page page;
        private String img = "";
        private String title = "";
        private String name = "";
        private String desc = "";
        private String path = "";

        private Slide(Page page) {
            this.page = page;
            title = page.getTitle();
            desc = page.getDescription();
            if (desc == null) {
                desc = "";
            }
            path = page.getPath();
            // currently we just check if "image" resource is present
            Resource r = page.getContentResource("image");
            if (r != null) {
                Image image = new Image(r);
                img = page.getPath() + ".img.png" + image.getSuffix();
            }
            name = page.getName();
        }

        public Page getPage() {
            return page;
        }

        public String getImg() {
            return img;
        }

        public String getTitle() {
            return title;
        }

        public String getName() {
            return name;
        }

        public String getDesc() {
            return desc;
        }

        public String getPath() {
            return path;
        }
    }
%>

