<%@ page session="false" %><% response.setStatus(404); 
%><%@ taglib uri="http://www.mmbase.org/mmbase-taglib-2.0"  prefix="mm"
%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "DTD/xhtml1-strict.dtd">
<html>
  <head>
    <title>404 The requested resource is unavailable</title>
    <%@ include file="meta.jsp" %>
  </head>
  <body class="basic">
  
<%@ include file="page-header.jsp" %>
      
        <h2>404 The requested resource is unavailable</h2>
        <h3><%=org.mmbase.Version.get()%></h3>
        <p>
          <% String mesg = (String) request.getAttribute("org.mmbase.servlet.error.message");
             if (mesg == null) {
           %>
          The current URL (<%=request.getAttribute("javax.servlet.error.message")%>) does not
          point to an existing resource in this web-application.
          <% } else { %>
          <%=mesg%>
          <% } %>
        </p>
        
        <mm:import externid="news" />
        <mm:present referid="news">
          <mm:listnodescontainer type="syncnodes">
          <mm:constraint field="exportnumber" value="$news" operator="EQUAL" />
          <mm:listnodes>
            <mm:field name="localnumber" id="local" write="false" />
            <mm:node number="$news" notfound="skip">

            <mm:link page="article" referids="_node@n">
              <mm:frameworkparam name="component">mynews</mm:frameworkparam>
              <p>The article '<a href="${_}"><mm:field name="title" /></a>' may may have been moved to <a href="${_}">${_}</a>.</p>
            </mm:link>

            </mm:node>
          </mm:listnodes>
          </mm:listnodescontainer>
        </mm:present>
        
        <mm:import externid="project" />
        <mm:present referid="project">
          <mm:listnodescontainer type="syncnodes">
          <mm:constraint field="exportnumber" value="$project" operator="EQUAL" />
          <mm:listnodes>
            <mm:field name="localnumber" id="local" write="false" />
            <mm:node number="$project" notfound="skip">

              <mm:link page="project">
                <mm:frameworkparam name="component">mmweb</mm:frameworkparam>
                <mm:frameworkparam name="node">${_node}</mm:frameworkparam>
                <p>The project '<a href="${_}"><mm:field name="title" /></a>' may have been moved to <a href="${_}">${_}</a>.</p>
              </mm:link>

            </mm:node>
          </mm:listnodes>
          </mm:listnodescontainer>
        </mm:present>

        <mm:import externid="page" />
        <mm:present referid="page">
          <mm:listnodescontainer type="syncnodes">
          <mm:constraint field="exportnumber" value="$page" operator="EQUAL" />
          <mm:listnodes>
            <mm:field name="localnumber" id="local" write="false" />
            <mm:node number="$local" notfound="skip">
              <mm:link page="page" referids="_node@n">
                <mm:frameworkparam name="component">mmsite</mm:frameworkparam>
                <p>The page '<mm:field name="title" />' may have been moved to <a href="${_}">${_}</a>.</p>
              </mm:link>
            </mm:node>
          </mm:listnodes>
          </mm:listnodescontainer>
        </mm:present>

<%@ include file="page-footer.jsp" %>
      
  </body>
</html>

