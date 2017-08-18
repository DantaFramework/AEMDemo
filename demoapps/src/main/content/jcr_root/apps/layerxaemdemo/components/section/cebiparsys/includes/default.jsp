<%
    for (Paragraph par: parSys.paragraphs())
    {
        Resource r = (Resource) par;
        if (r.getResourceType().endsWith("/iparsys/par"))
        {
            hasFake = true;
            IncludeOptions.getOptions(request, true).forceCellName("");
            %><div class="iparys_inherited"><cq:include path="<%= r.getPath() %>" resourceType="<%= r.getResourceType() %>"/></div><%
        }
        else
        {
            switch (par.getType())
            {
                case START:

                    if (hasColumns) {
                        // close in case missing END
                        %></div></div><%
                    }
                    if (editContext != null) {
                        // draw 'edit' bar
                        Set<String> addedClasses = new HashSet<String>();
                        addedClasses.add("section");
                        addedClasses.add("colctrl-start");
                        IncludeOptions.getOptions(request, true).getCssClassNames().addAll(addedClasses);
                        %><sling:include resource="<%= par %>"/><%
                    }
                    // open outer div
                    %><div class="parsys_column <%= par.getBaseCssClass()%>"><%
                    // open column div
                    %><div class="parsys_column <%= par.getCssClass() %>"><%
                    hasColumns = true;
                    break;

                case BREAK:

                    if (editContext != null) {
                        // draw 'new' bar
                        IncludeOptions.getOptions(request, true).getCssClassNames().add("section");
                        %><sling:include resource="<%= par %>" resourceType="<%= newType %>"/><%
                    }
                    // open next column div
                    %></div><div class="parsys_column <%= par.getCssClass() %>"><%
                    break;

                case END:

                    if (editContext != null) {
                        // draw new bar
                        IncludeOptions.getOptions(request, true).getCssClassNames().add("section");
                        %><sling:include resource="<%= par %>" resourceType="<%= newType %>"/><%
                    }
                    if (hasColumns) {
                        // close divs and clear floating
                        %></div></div><div style="clear:both"></div><%
                            hasColumns = false;
                    }
                    if (editContext != null && WCMMode.fromRequest(request) == WCMMode.EDIT) {
                        // draw 'end' bar
                        IncludeOptions.getOptions(request, true).getCssClassNames().add("section");
                        %><sling:include resource="<%= par %>"/><%
                    }
                    break;

                case NORMAL:

                    // include 'normal' paragraph
                    IncludeOptions.getOptions(request, true).getCssClassNames().add("section");

                    // draw anchor if needed
                    if (currentStyle.get("drawAnchors", false)) {
                        String path = par.getPath();
                        path = path.substring(path.indexOf(JcrConstants.JCR_CONTENT) + JcrConstants.JCR_CONTENT.length() + 1);
                        String anchorID = path.replace("/", "_").replace(":", "_");
                        %><a name="<%= xssAPI.encodeForHTMLAttr(anchorID) %>" style="visibility:hidden"></a><%
                    }
                    %><sling:include resource="<%= par %>"/><%
                    break;
            }
        }
    }
%>