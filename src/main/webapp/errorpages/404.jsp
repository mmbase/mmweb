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

<%@ include file="page-footer.jsp" %>
      
  </body>
</html>

