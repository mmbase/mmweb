<%@ page language="java" contentType="text/html" session="false"
%><%@ taglib uri="http://www.mmbase.org/mmbase-taglib-2.0" prefix="mm" 
%><%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x" 
%><%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" 
%><%@ taglib uri="http://www.opensymphony.com/oscache" prefix="cache" 
%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
      "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="nl">
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<title>Twitter</title>
</head>
<body>

  <ul>
  <mm:formatter escape="none">
    <mm:include page="http://twitter.com/statuses/user_timeline/mmbase.xml?callback=twitterCallback2&count=5" cite="true" />
    <mm:xslt>
  
      <xsl:stylesheet version="1.0" 
          xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
          xmlns:java="http://xml.apache.org/xalan/java"
          exclude-result-prefixes="java">
      
        <xsl:template match="statuses">
          
          <xsl:for-each select="status">
            <li class="tw">
              <mm:import id="text" reset="true"><xsl:value-of select="text" /></mm:import>
              ${mm:escape('links',text)}
              <em><xsl:value-of select="created_at" /></em>
            </li>
          </xsl:for-each>
          
        </xsl:template>
      </xsl:stylesheet>
  
    </mm:xslt>
  </mm:formatter>
  </ul>
  <p><a href="http://twitter.com/mmbase">Follow us on twitter</a></p>
  
  
</body>
</html>
