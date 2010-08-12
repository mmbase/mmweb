<%
Calendar cal = Calendar.getInstance();
String [] days = { "SUNDAY","MONDAY","TUESDAY","WEDNESDAY","THURSDAY","FRIDAY","SATURDAY" }; 
String [] days_lcase = { "Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"  }; 
String [] days_abbr = { "Sun.","Mon.","Tue.","Wed.","Thu.","Fri.","Sat." } ; 
String [] months = { "JANUARY","FEBRUARY","MARCH","APRIL","MAY","JUNE","JULY",
                    "AUGUST","SEPTEMBER","OCTOBER","NOVEMBER","DECEMBER" };
String [] months_lcase = { "January","February","March","April","May","June","July",
                    "August","September","October","November","December"  };
Date dd = new Date();
long now = (dd.getTime()/1000);
String timestr = "";
%>