<%-- warning on using two times the same question should be added --%>
<form name="emailform" method="post" target="" onKeyPress="javascript:useEnterKey();" action="javascript:postIt('');"> 
<mm:list nodes="$page" path="pages,posrel,pools" orderby="posrel.pos" directions="UP"
	><mm:node element="pools"
	><table style="width:99%;"><tr><td style="padding-left:10px;">
		<mm:field name="name" jspvar="pools_name" vartype="String" write="false"
			><% if(pools_name.indexOf("#NZ")==-1) { %><h4><%= pools_name %></h4><% } %></mm:field>
		<mm:field name="description" jspvar="pools_description" vartype="String" write="false"
			><mm:isnotempty><%
			if(pools_description.toLowerCase().indexOf("<p>")==-1) { 
				%><p><%=pools_description %></p><% 
			} else { 
				%><%= pools_description %><% 
			} 
			%></mm:isnotempty
		></mm:field
		><mm:related path="posrel,questions" orderby="posrel.pos" directions="UP"
			><% String questions_type = ""; 
			%><mm:field name="questions.type" jspvar="dummy" vartype="String" write="false"
				><% questions_type = dummy; 
			%></mm:field
			><% boolean isRequired = false; 
			%><mm:field name="questions.required" jspvar="dummy" vartype="String" write="false"
				><% isRequired = dummy.equals("1"); 
			%></mm:field
			><% String questions_number = ""; 
			%><mm:field name="questions.number" jspvar="dummy" vartype="String" write="false"
				><% questions_number= dummy; 
			%></mm:field
			><% String questionWidth = "";
				boolean newLine = true;
			%><mm:field name="questions.layout" jspvar="dummy" vartype="String" write="false"><%
				if(dummy.equals("4")||dummy.equals("5")||dummy.equals("6")) { newLine = false; }
				if(dummy.equals("1")||dummy.equals("4")) { questionWidth = "54"; } 
				if(dummy.equals("2")||dummy.equals("5")) { questionWidth = "118"; } 
				if(dummy.equals("3")||dummy.equals("6")) { questionWidth = "246"; } 
			%></mm:field
			><mm:first><table cellspacing="0" cellpadding="0" border="0"><tr></mm:first
			><mm:first inverse="true"><%
				if(newLine) { 
						%></tr></table>
						<table cellspacing="0" cellpadding="0" border="0"><tr><%
				} 
			%></mm:first
			><td style="padding-bottom:10px;font-size:150%;">
			<mm:field name="questions.title" /><% if(isRequired) { %> (*) <% } %><br><%

			// *** radio buttons or checkboxes
			if(questions_type.equals("4")||questions_type.equals("5")) { 
				%><mm:list nodes="<%= questions_number %>" path="questions,posrel,answers"
						orderby="posrel.pos" directions="UP"><%
					if(questions_type.equals("4")) { 
						%><input type="radio" name="q<%= questions_number 
							%>" value="<mm:field name="answers.answer" />" ><%
					} else if(questions_type.equals("5")) {
						%><input type="checkbox" name="q<%= questions_number %>_<mm:field name="answers.number" 
							/>" value="<mm:field name="answers.answer" />" ><%
					} 
					%><mm:field name="answers.answer" 
					/><mm:field name="answers.layout"
						><mm:compare value="1"><br></mm:compare
						><mm:compare value="1" inverse="true"><img src="media/spacer.gif" alt="" border="0" width="30" height="1"></mm:compare
					></mm:field
				></mm:list><%
			} 

			// *** dropdown 
			if(questions_type.equals("3")) { 
				%><select name="q<%= questions_number %>" style="width:<%= questionWidth %>px;">
					<option>...
					<mm:list nodes="<%= questions_number %>" path="questions,posrel,answers"
							orderby="posrel.pos" directions="UP"
							><option value="<mm:field name="answers.answer" />"><mm:field name="answers.answer" 
					/></mm:list
				></select><%
			} 

			// *** textarea and textline
			if(questions_type.equals("1")||questions_type.equals("2")) {
				if(questions_type.equals("1")) { 
					%><textarea rows="4" name="q<%= questions_number %>" wrap="physical"></textarea><%
				} else {
					%><input type="text" name="q<%= questions_number %>" style="width:<%= questionWidth %>px;"><%
				}
				%><%
			}

			// *** date
			if(questions_type.equals("6")) { // *** create input fields for day, month and year
				%><table cellspacing="0" cellpadding="0" border="0"><tr>
					<td style="width:64px;">
						Day<br>
						<input type="text" name="q<%= questions_number %>_day" style="width:54px;"><br>
					</td><td style="width:128px;">
						Month<br>
						<select name="q<%= questions_number %>_month" style="width:118px;">
							<option>...<%
							for(int m=0; m<12; m++) { %><option value="<%= months_lcase[m] %>"><%= months_lcase[m] %><% } 
						%></select><br>
					</td><td>
						Year<br>
						<input type="text" name="q<%= questions_number %>_year" style="width:54px;"><br>
					</td>
				</tr></table><%
			} 

		%></td><td style="width:10px;"></td>
		<mm:last></tr></table></mm:last>
		</mm:related
		></td></tr></table>
		<mm:last
			>
			<table class="multidata" cellspacing="10" cellpadding="0" style="width:99%;"><tr>
				<td class="intro" style="width:80%;vertical-align:middle;font-size:130%;">Please fill in all fields marked with a (*)</td>
				<td style="vertical-align:middle;font-size:130%;"><b>Clear</b></td>
				<td style="padding:0px;"><a href="javascript:postIt('clear');"><img src="../mmbase/style/images/delete.gif" alt="" border="0"></a></td>
				<td style="vertical-align:middle;padding-left:30px;font-size:130%;"><b>Send&nbsp;Form</b></td>
				<td style="padding-right:10px;"><a href="javascript:postIt('');"><img src="../mmbase/style/images/next.gif" alt="" border="0"></a></td>
			</tr></table>
		</mm:last
	></mm:node
></mm:list>
</form>
