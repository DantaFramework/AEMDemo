<%
    for (Paragraph par: paras)
    {
        switch (par.getType())
        {
            case START:

                if (hasColumns) {
                    // close in case missing END
                %></div></div><%
                }
                // open outer div
                %><div class="parsys_column <%= par.getBaseCssClass()%>"><%
                // open column div
                %><div class="parsys_column <%= par.getCssClass() %>"><%
                hasColumns = true;
                break;

            case BREAK:

                // open next column div
                %></div><div class="parsys_column <%= par.getCssClass() %>"><%
                break;

            case END:

                if (hasColumns) {
                    // close divs and clear floating
                    %></div></div><div style="clear:both"></div><%
                    hasColumns = false;
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
                    %><a name="<%= anchorID %>" style="visibility:hidden"></a><%
                }
                %><sling:include resource="<%= par %>"/><%
                break;
        }
    }
%>