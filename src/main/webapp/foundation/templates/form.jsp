<%@ taglib uri="http://www.mmbase.org/mmbase-taglib-1.0" prefix="mm" 
%><%@ page language="java" contentType="text/html; charset=utf-8"
%><mm:cloud logon="karien" pwd="foun%guru" method="pagelogon">
<%@ include file="/includes/getids.jsp" 
%><%@ include file="/includes/alterheader.jsp"
%>
<div id="pagecontent">
<%@ include file="../includes/calendar.jsp" 
%><%@ include file="../includes/getresponse.jsp" %><%

String postingStr = request.getParameter("pst");
if(postingStr==null) postingStr = "";
String defaultEmailAddress = "website@mmbase.org";

%><table cellspacing="0" cellpadding="2" border="0">
<tr><td>
<%
        
// See the question_types.xml in the editwizard definition

if(!postingStr.equals("")){
    postingStr += "|";
    %><%@include file="../includes/formresult.jsp" %><% 
} else {
    %><mm:list nodes="$page" path="pages,intro,articles" max="1"
   	 ><mm:node element="articles"><%@include file="/includes/article.jsp" %></mm:node
    ></mm:list
    ><%@include file="../includes/formtable.jsp" 
    %><%@include file="../includes/formscript.jsp" %><%
} %></td></tr>
</table>
</div>
<%@include file="/includes/alterfooter.jsp"
%></mm:cloud>
