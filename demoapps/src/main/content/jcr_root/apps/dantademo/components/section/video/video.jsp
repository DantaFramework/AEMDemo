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

  ==============================================================================

--%><%@ include file="/libs/foundation/global.jsp" %><%
%><%@ page import="com.day.cq.dam.api.Asset,
                   com.day.cq.wcm.api.WCMMode, 
                   com.day.cq.wcm.api.components.DropTarget,
                   com.day.cq.wcm.foundation.Placeholder" %><%

    // try find referenced asset
    Asset asset = null;
    Resource assetRes = resourceResolver.getResource(properties.get("asset", ""));
    String altContentId="";
    if (assetRes != null) {
        asset = assetRes.adaptTo(Asset.class);
    }
    if (asset != null) {
        request.setAttribute("video_asset", asset);

       // allow both pixel & percentage values
        String width = properties.get("width", currentStyle.get("width", String.class));
        String height = properties.get("height", currentStyle.get("height", String.class));
        
        // allow either just a width or a height to be set (letting the browser handle it)
        // but give a default if nothing is set
        if (width == null && height == null) {
            width = "480";
            height = "320";
        }
        String wh = (width != null ? "width=\"" + xssAPI.encodeForHTMLAttr(width) + "\"" : "") + " " + (height != null ? "height=\"" + xssAPI.encodeForHTMLAttr(height) + "\"" : "");
        StringBuilder attributes = new StringBuilder();

        String videoClass = currentStyle.get("videoClass", "");
        if (videoClass.length() > 0) {
            attributes.append(" class=\"").append(xssAPI.encodeForHTMLAttr(videoClass)).append("\"");
        }
        if (!currentStyle.get("noControls", false)) {
            attributes.append(" controls=\"controls\"");
        }
        if (currentStyle.get("autoplay", false)) {
            attributes.append(" autoplay=\"autoplay\"");
        }
        if (currentStyle.get("loop", false)) {
            attributes.append(" loop=\"loop\"");
        }
        String preload = currentStyle.get("preload", "");
        if (preload.length() > 0) {
            attributes.append(" preload=\"").append(xssAPI.encodeForHTMLAttr(preload)).append("\"");
        }
        String id = "cq-video-html5-" + System.currentTimeMillis();
%> 
<cq:includeClientLib js="cq.video" />

<%

    if ( request.getParameter("strobe")!=null && request.getParameter("strobe").equals("true")) {
%>
        <cq:include script="flash.jsp"/>
<%
    } else {
%>
        <video id="<%= id %>" <%= wh %><%= attributes %> >
            <cq:include script="sources.jsp"/>
            <cq:include script="flash.jsp"/>
        </video>
<%
    }
%>

<script type="text/javascript">
(function() {

    //get video file name,fileName and path
    var mediaName = '<%= xssAPI.encodeForJSString(asset.getMetadataValue("dc:title")!= "" ? asset.getMetadataValue("dc:title") : asset.getName()) %>';
    var mediaFile = '<%= xssAPI.encodeForJSString(asset.getName()) %>';
    var mediaPath = '<%= xssAPI.encodeForJSString(asset.getPath()) %>';

    var video = document.getElementById("<%= id %>");
    var videoOpen = false;
    // delay (in ms) due to buggy player implementation
    // when seeking, video.currentTime is not updated correctly so we need to delay
    // retreiving currentTime by an offset
    var delay = 250;
    //mouse up flag
    var isMouseUp = true;
    //store currentTime for 1 second
    var pauseTime = 0;
    // clickstream cloud data to be send based on context mapping
     var CQ_data = new Object();

    if (video && video.addEventListener) {
        video.addEventListener("playing", play, false);
    }

    function open() {
        video.addEventListener("pause", pause, false);
        video.addEventListener("ended", ended, false);
        video.addEventListener("seeking", pause, false);
        video.addEventListener("seeked", play, false);
         
        //store flag for mouse events in order to play only if the mouse is up
        video.addEventListener("mousedown", mouseDown, false);
        video.addEventListener("mouseup", mouseUp, false);
        function mouseDown(){ 
            isMouseUp=false;
        } 
        function mouseUp(){ 
            isMouseUp = true;
        }

        CQ_data = new Object();          
        CQ_data["length"] = Math.floor(video.duration);
        CQ_data["playerType"] = "HTML5 video";
        CQ_data["source"] = mediaName;
        CQ_data["playhead"] = Math.floor(video.currentTime);
        
        CQ_data["videoName"] = mediaName;
        CQ_data["videoFileName"] = mediaFile;
        CQ_data["videoFilePath"] = mediaPath;

        if (window.CQ_Analytics) {
            CQ_Analytics.record({
                event: 'videoinitialize',
                values: CQ_data,
                componentPath: '<%= xssAPI.getValidHref(resource.getResourceType()) %>'
            });
        }

        storeVideoCurrentTime();
    }

    function play() {
        if (window.CQ_Analytics && CQ_Analytics.Sitecatalyst) {
            // open video call
            if (!videoOpen) {
                open();
                videoOpen = true; 
            } else {
                //send pause event before play for scrub events
                pause();
                // register play
                setTimeout(playDelayed, delay);
            }
        }
    }

    function playDelayed() {
        if (isMouseUp){
            CQ_data = new Object(); 
            CQ_data["playhead"] = Math.floor(video.currentTime-delay/1000);
            CQ_data["source"] = mediaName;
            if (window.CQ_Analytics) {
                CQ_Analytics.record({
                    event: 'videoplay',
                    values: CQ_data,
                    componentPath: '<%= xssAPI.getValidHref(resource.getResourceType()) %>'
                });
            }
        }
    }

    function pause() {
        CQ_data = new Object(); 
        CQ_data["playhead"] = pauseTime;
        CQ_data["source"] = mediaName;
        if (window.CQ_Analytics) {
            CQ_Analytics.record({
                event: 'videopause',
                values: CQ_data,
                componentPath: '<%= xssAPI.getValidHref(resource.getResourceType()) %>'
            });
        }

    }

    function ended() {
        CQ_data = new Object(); 
        CQ_data["playhead"] = Math.floor(video.currentTime);
        CQ_data["source"] = mediaName;
        if (window.CQ_Analytics) {
            CQ_Analytics.record({event: 'videoend', values: CQ_data, componentPath: '<%= xssAPI.getValidHref(resource.getResourceType()) %>'});
        }
        //reset temp variables
        videoOpen = false;
        pauseTime = 0;
    }
    
    //store current time for one second that will be use for pause
    function storeVideoCurrentTime() {
        timer = window.setInterval(function() {
            if (video.ended != true) {
                pauseTime = Math.floor(video.currentTime); 
            } else { 
                window.clearInterval(timer);
            }
        },1000);
    }
    
    
})();
</script>

<%
        request.removeAttribute("video_asset");
    } else {
        String ddClassName = DropTarget.CSS_CLASS_PREFIX + "video";
        if(Placeholder.isAuthoringUIModeTouch(slingRequest) || WCMMode.fromRequest(request) ==  WCMMode.EDIT){
            String classicPlaceholder =
                    "<div class=\"" + ddClassName +
                            (WCMMode.fromRequest(request) == WCMMode.EDIT ? " cq-video-placeholder" : "")  +
                            "\"></div>";
            String placeholder = Placeholder.getDefaultPlaceholder(slingRequest, component, classicPlaceholder, ddClassName);
            %><%= placeholder %><%
        } else {
            String showAltComponentName = request.getParameter("showAltComponentName");
            if(showAltComponentName!=null && showAltComponentName.equalsIgnoreCase("true")) { %>
                <div class="<%= ddClassName %>">
                    <div id="<%= altContentId %>">
                        <h2 class="cq-paragraphreference-thumbnail-text"><%= xssAPI.encodeForHTML(resource.getName()) %></h2>
                    </div>
                </div>
            <%}
        }
    }
%>
