<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.Date,java.text.*,java.sql.*,java.sql.SQLException,java.sql.DriverManager,javax.sql.DataSource" %>

<html>
	<head>
		
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		
		<title> Results </title>
		
		<script type="text/javascript">
			function result()
			{
				var query = unescape(window.location)
				var cValue =query.substring(query.indexOf("c=") + 2,query.indexOf("&an="));
				document.forms[0].correct_ans.value = cValue;
				document.forms[0].score.value = cValue;
			}

			function logout()
			{
				window.close();
			}
		</script>
	</head>
	
	<body onload="result()">
		<%
			String result = request.getParameter("c");
			String user_name = (String) session.getAttribute("ses_usr_name");
			String sub_code = (String) session.getAttribute("ses_sub_code");
			String ex_type = (String) session.getAttribute("ses_ex_type");

			String y="",deg="",dept="",year="",semes="";
			String temp="";
			int checked = 0;
			boolean pass = true;
		
			Date d = new Date();
			Format formatter;
			formatter = new SimpleDateFormat("yyyy");
			y = formatter.format(d);
		
			PreparedStatement stu = null;
			ResultSet rs = null;
			Connection conn=null;

	        try
	        {
	            Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
	            conn = DriverManager.getConnection("jdbc:odbc:dsn","system","cutee");
	                     
			    stu = conn.prepareStatement("select * from student where id=?");
			    stu.setString(1,user_name);
	            rs=stu.executeQuery();
	            if(rs.next())
	            {
					dept=rs.getString("dept");
					year=rs.getString("year");
					deg=rs.getString("degree");
					semes=rs.getString("sem");
	            }
			while(pass)
			{
				if(checked == 1)
					pass = false;

				temp = y+deg+dept+year+semes+ex_type;
				String t = "RESULT_"+y+deg+dept+year+semes+ex_type;

		  	        stu = conn.prepareStatement("select * from tab");
	        		rs=stu.executeQuery();
			        while(rs.next())
	            		{
					if(rs.getString("tname").equals(t))
					{
						checked = 1;
						if(checked == 1)
							pass = false;
		
					        stu = conn.prepareStatement("update " +t+ " set " +sub_code+ "=? where roll=?");
					        stu.setString(1,result);
					        stu.setString(2,user_name);
			            		stu.executeUpdate();
					}
				}
				if(checked == 0)
				{
					int con = Integer.parseInt(y);
					con=con-1;
					y = Integer.toString(con);
					checked = 1;
				}	
			}
			} 
			catch (SQLException ex) 
	        {
				out.println("SQLException: " + ex.getMessage());
	       	    out.println("SQLState: " + ex.getSQLState());
	            out.println("VendorError: " + ex.getErrorCode());
	        }
		%>
		<form>
			<p align="center">
			<table>
				<tr>
					<td>
						<table border=1>
							<tr>
								<td> Correct Answers: </td><td> <input type="text" readonly="true" name="correct_ans">
							</tr>
							<tr>
								<td> Score: </td><td> <input type="text" readonly="true" name="score">
							</tr>
						</table>
					</td>
					<td align="center">
						<input type="button" name="user_log" value="Logout" onclick="logout();"/>
					</td>
				</tr>
			</table>
			</p>
			<hr />
			<br /><br />
			<p> <font size=4> Check for Correct Answers here..! </font> </p>
		</form>
		<%
			temp = temp+sub_code;
			String marks = (String) session.getAttribute("ses_noq");			
			int noq = Integer.parseInt(marks);
			int ques[] = new int[noq];
			for(int i=1; i<=noq; i++)
			{
				String ques_temp = (String) session.getAttribute("ses_que"+Integer.toString(i));							
				ques[i-1] = Integer.parseInt(ques_temp);
			}
			String an = request.getParameter("an");
			String ans[] = new String[noq];
			for(int i=0,j=1; j<=noq; i=i+2,j++)
			{
				ans[j-1] = an.substring(i,i+2);
			}
		        try
		        {	
	        	    stu = conn.prepareStatement("select * from QUES_"+temp);	
			    for(int i=1;i<=noq;i++)
			    {
				int flag2 = 0;
	         		rs=stu.executeQuery();
				while(rs.next() & flag2==0)
 	        	        {
					int tem = rs.getInt("sno");
					if(tem==(ques[i-1]+1))
					{
						String ans_temp = rs.getString("ans");
						if(ans_temp.equals("A"))
							ans_temp = "c1";
						else if(ans_temp.equals("B"))
							ans_temp = "c2";
						else if(ans_temp.equals("C"))
							ans_temp = "c3";
						else
							ans_temp = "c4";
						String corans_temp = rs.getString(ans_temp);
						%>
							<div>
					        	<p> <font family="comic sans ms" size="5"><%out.print(i+".  ");%> </font><font family="comic sans ms" size="4"> <%out.print(rs.getString("ques"));%> </font> </p>	
							<b> <font family="comic sans ms" size="4">Correct Answer: </font></b> <font family="comic sans ms" size="4"><% out.println(corans_temp);%> </font> <%
							if(ans[i-1].equals(ans_temp))
							{
								%>  <br><font family="comic sans ms" size="4"><b> Your Answer: </b> </font> <font family="comic sans ms" color="green" size="4"><%
								out.println(corans_temp);  %> </font> <%
							}
							else if(ans[i-1].equals("00"))
							{
								%>  <br><font family="comic sans ms" size="4"><b> Your Answer: </b> </font> <font family="comic sans ms" size="4"><% 
								out.println("---"); %> </font> <%
							}
							else
							{
								%>  <br><font family="comic sans ms" size="4"><b> Your Answer: </b> </font> <font family="comic sans ms" color="red" size="4"><% 
								out.println(rs.getString(ans[i-1])); %> </font> <%
							}
							%> </div> <br /><%
							flag2 = 1;
				      }
				}
			    }
			    rs.close();
			    stu.close();
			    conn.close();
			}   
			catch (SQLException ex) 
			{
				out.println("SQLException1: " + ex.getMessage());
				out.println("SQLState: " + ex.getSQLState());
				out.println("VendorError: " + ex.getErrorCode());
			}
		%>
		<br>
		<form>
			<div align="center">
				<input type="button" name="user_log" value="Logout" onclick="logout();"/>
			</div>
		</form>
	</body>
</html>