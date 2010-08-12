<%-- ********************* create the javascript for posting the values *******************
--%><% if(true) { 
%><script>
<%= "<!--" %>
function postIt(searchtype) {
var href = "index.jsp?page=<mm:write referid="page" />&pst=";
if(searchtype != 'clear' ) {
<mm:list nodes="$page" path="pages,posrel,pools" 
	orderby="posrel.pos" directions="UP"
	><mm:node element="pools"
	><mm:related path="posrel,questions"
			orderby="posrel.pos" directions="UP"
			><mm:node element="questions"
				><% String questions_type = ""; 
				%><mm:field name="type" jspvar="dummy" vartype="String" write="false"
					><% questions_type = dummy; 
				%></mm:field
				><% String questions_number = ""; 
				%><mm:field name="number" jspvar="dummy" vartype="String" write="false"
					><% questions_number= dummy; 
				%></mm:field
				><% 

				if(questions_type.equals("6")) { // *** date ***
				%>	var answer = escape(document.emailform.elements["q<%= questions_number %>_day"].value);
					if(answer != '') {
						href += "|q<%= questions_number %>_day=" + answer;
					}
					var answer = escape(document.emailform.elements["q<%= questions_number %>_month"].value);
					if(answer != '') {
						href += "|q<%= questions_number %>_month=" + answer;
					}
					var answer = escape(document.emailform.elements["q<%= questions_number %>_year"].value);
					if(answer != '') {
						href += "|q<%= questions_number %>_year=" + answer;
					}
				<% 
				} else if(questions_type.equals("5")) { // *** check boxes ***
					%><mm:related path="posrel,answers" orderby="posrel.pos" directions="UP">
						var answer = document.emailform.q<%= questions_number %>_<mm:field name="answers.number" />;
						if(answer.checked) {
							href += "|q<%= questions_number %>_<mm:field name="answers.number" />=" + answer.value;
						}
					</mm:related><% 
				} else if(questions_type.equals("4")) { // *** radio buttons ***
				%>	var answer = document.emailform.q<%= questions_number %>;
					for (var i=0; i < answer.length; i++){
						if (answer[i].checked) {
							var rad_val = answer[i].value;
							if(rad_val != '') {
								href += "|q<%= questions_number %>=" + rad_val;
							}
						}
					}
				<% }

				else if(questions_type.equals("1")||questions_type.equals("2")||questions_type.equals("3")) { 
				// *** textarea, textline, dropdown ***
				%>
					var answer = escape(document.emailform.elements["q<%= questions_number %>"].value);
					if(answer != '') {
						href += "|q<%= questions_number %>=" + answer;
					}
				<% } 
			%></mm:node
		></mm:related
		></mm:node
></mm:list>
}
top.location = href;
return false; 
}
function useEnterKey() {
	if (window.event.keyCode == 13) postIt('');
}
<%= "//-->" %>
</script><%
} %>
