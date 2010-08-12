<%
	String responseText = "This email has been sent from www.mmbase.org.";
	String noAnswer = "-";
	
	String okTitle = "Thanks for your request!";
	String okMessage = "We will send you a response as soon as possible.";
	String okLink = "To the homepage";
	
	String warningTitle = "You forgot to fill in the following fields:";
	String warningMessage = "";
	String warningLink = "Back to the form";
	
	boolean isValidAnswer = true;
	String pages_title = "";
	String pages_menuname = "";

%><mm:node number="$page"
><mm:related path="posrel,articles" constraints="posrel.pos = '1'"
		><mm:field name="articles.title" jspvar="dummy" vartype="String" write="false"
				><% okTitle = dummy;
		%></mm:field
		><mm:field name="articles.intro" jspvar="dummy" vartype="String" write="false"
				><% okMessage = dummy;
		%></mm:field
></mm:related
><mm:field name="title" jspvar="dummy" vartype="String" write="false"
		><% pages_title = dummy; 
%></mm:field
><mm:field name="menuname" jspvar="dummy" vartype="String" write="false"
		><% pages_menuname = dummy; 
%></mm:field
><mm:related path="posrel,pools" orderby="posrel.pos" directions="UP"
		><mm:node element="pools"
			><mm:field name="name" jspvar="pools_name" vartype="String" write="false"><%
				responseText += "\n\n" + pools_name.toUpperCase() + "\n"; 
			%></mm:field
			>
			<mm:related path="posrel,questions" orderby="posrel.pos" directions="UP"

				><% String questions_title = ""; 
				%><mm:field name="questions.title" jspvar="dummy" vartype="String" write="false"
						><%  questions_title = dummy;
				%></mm:field

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
				%></mm:field><%

				responseText += "\n" + questions_title + ": "; 

				if(questions_type.equals("6")) { // *** date ***

					responseText += "(Day,Month,Year) ";
					String answerValue = getResponseVal("q" + questions_number + "_day",postingStr);
					if(answerValue.equals("")) {
						responseText += noAnswer;
						if(isRequired) {
							isValidAnswer = false;
							warningMessage += "- Day in " + questions_title + "<br/>";
						}
					} else {
						responseText += answerValue;
					}
					answerValue = getResponseVal("q" + questions_number + "_month",postingStr);
					if(answerValue.equals("")) {
						responseText += ", " + noAnswer;
						if(isRequired) {
							isValidAnswer = false;
							warningMessage += "- Month in " + questions_title + "<br/>";
						}
					} else {
						responseText +=  ", " + answerValue;
					}
					answerValue = getResponseVal("q" + questions_number + "_year",postingStr);
					if(answerValue.equals("")) {
						responseText +=  ", " + noAnswer;
						if(isRequired) {
							isValidAnswer = false;
							warningMessage += "- Year in " + questions_title + "<br/>";
						}
					} else {
						responseText +=  ", " + answerValue;
					}

				} else if(questions_type.equals("5")) { // *** check boxes ***
					boolean hasSelected = false; 
					%><mm:list nodes="<%= questions_number %>" path="questions,posrel,answers" orderby="posrel.pos" directions="UP"
					><mm:field name="answers.number" jspvar="answer_number" vartype="String" write="false"
						><%	String answerValue = getResponseVal("q" + questions_number + "_" + answer_number,postingStr);
							if(!answerValue.equals("")) { 
								hasSelected = true;
								responseText += "\n- " + answerValue;
							}
						%></mm:field
					></mm:list><%
					if(!hasSelected) {
						responseText += noAnswer;
						if(isRequired) {
							isValidAnswer = false;
							warningMessage += "- " + questions_title + "<br/>";
						}
					} 

				} else { // *** textarea, textline, dropdown, radio buttons ***
					String answerValue = getResponseVal("q" + questions_number,postingStr);
					if(answerValue.equals("")) {
						responseText += noAnswer;
						if(isRequired) {
							isValidAnswer = false;
							warningMessage += "- " + questions_title + "<br/>";
						}
					}
					responseText += answerValue;
				} 
			%></mm:related
		></mm:node
></mm:related
></mm:node><%

	if(isValidAnswer) {
	
		// *** 1.6 implementation ***
		String email_targets = pages_menuname.trim() + ";"; 
		int semicolonPos = email_targets.indexOf(";");
		while(semicolonPos>0){
			String target = email_targets.substring(0,semicolonPos);
			email_targets = email_targets.substring(semicolonPos+1);
			semicolonPos = email_targets.indexOf(";");
			%><mm:createnode type="email"
			><mm:setfield name="subject"><%= pages_title %></mm:setfield
			><mm:setfield name="from"><%= defaultEmailAddress %></mm:setfield
			><mm:setfield name="to"><%= target %></mm:setfield
			><mm:setfield name="replyto"><%= defaultEmailAddress %></mm:setfield
			><mm:setfield name="body"><%= responseText %></mm:setfield
			></mm:createnode><% 
		} 

		%><%-- // *** 1.7 implementation ***	
		<mm:createnode type="email" id="mail1"
				><mm:setfield name="from"><%= defaultEmailAddress %></mm:setfield
				><mm:setfield name="subject"><%= pages_title %></mm:setfield
				><mm:setfield name="replyto"><%= defaultEmailAddress %></mm:setfield
				><mm:setfield name="body">
					<multipart id="plaintext" type="text/plain" encoding="UTF-8">
					</multipart>
					<multipart id="htmltext" alt="plaintext" type="text/html" encoding="UTF-8">
						<%= "<html>" + responseText + "</html>" %>
					</multipart>
				</mm:setfield
		></mm:createnode><%

		String emailAdresses = pages_menuname.trim() + ";"; 
		int semicolon = emailAdresses.indexOf(";");
		while(semicolon>-1) { 
			String emailAdress = emailAdresses.substring(0,semicolon);
			emailAdresses = emailAdresses.substring(semicolon+1);
			semicolon = emailAdresses.indexOf(";");
			%><mm:node referid="mail1"
				><mm:setfield name="to"><%= emailAdress %></mm:setfield
				><mm:field name="mail(oneshot)" 
			/></mm:node><%
		}
		 --%><%
		String formTitle =  okTitle;
		String formMessage =  okMessage + "\n\nYour request has been sent to:  " + pages_menuname;
		String formMessageHref = "index.jsp";
		String formMessageLinktext = okLink;

		%><%@include file="../includes/formmessage.jsp" %><%
	} else { 
		String formTitle = warningTitle;
		String formMessage = warningMessage;
		String formMessageHref = "javascript:history.go(-1)";
		String formMessageLinktext = warningLink;
		%><%@include file="../includes/formmessage.jsp" %><% 
	} 
%>
