<%
    for (Paragraph par: parSys.paragraphs())
    {
        if (par.getResourceType().equals(spanComponentResourceType))
        {
            if (editContext != null) {
                editContext.setAttribute("currentResource", par);
            }

            // include 'normal' paragraph
            IncludeOptions.getOptions(request, true).getCssClassNames().add("section");

            // draw anchor if needed
            if (currentStyle.get("drawAnchors", false)) {
                String path = par.getPath();
                path = path.substring(path.indexOf(JcrConstants.JCR_CONTENT)
                        + JcrConstants.JCR_CONTENT.length() + 1);
                String anchorID = path.replace("/", "_").replace(":", "_");
                %><a name="<%= anchorID %>" style="visibility:hidden"></a><%
            }

            spanComponentPath = par.getPath();

            %><sling:include resource="<%= par %>"/><%
            break;
        }
    }
%>