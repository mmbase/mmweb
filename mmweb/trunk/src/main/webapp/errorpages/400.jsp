<%@ page session="false" %><% response.setStatus(400); 
%><%@ taglib uri="http://www.mmbase.org/mmbase-taglib-2.0" prefix="mm"
%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "DTD/xhtml1-strict.dtd">
<html>
  <head>
    <title>400 Bad request</title>
    <%@include file="meta.jsp" %>
  </head>
  <body class="basic">
  
  <%@ include file="page-header.jsp" %>
  
    <h2>400 Bad request - <%= request.getAttribute("javax.servlet.error.message") %></h2>
    <h3><%=org.mmbase.Version.get()%></h3>
    <p>
      &nbsp;
      <% String mesg = (String) request.getAttribute("org.mmbase.servlet.error.message");     
         if (mesg != null) {
       %>
      <%=mesg%>
      <% } %>
    </p>

<%@ include file="page-footer.jsp" %>

  </body>
</html>

