<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*,java.lang.Character" %>
<%@ page import="java.sql.*,java.sql.SQLException,java.sql.DriverManager,javax.sql.DataSource" %>

<html>
	<head>
		
		<title> Login Page </title>
		
		<%	
			session.setAttribute("ses_usr_name","");
			session.setAttribute("ses_passwd","");
		%>

		<style type="text/css">
		<!--
			#Layer1 {
				position:absolute;
				left:50px;
				top:50px;
				width:200px;
				height:173px;
				z-index:1;
			}
			#Layer2 {
				position:absolute;
				left:258px;
				top:50px;
				width:678px;
				height:178px;
				z-index:2;
			}
			#Layer3 {
				position:absolute;
				left:657px;
				top:252px;
				width:276px;
				height:125px;
				z-index:3;
			}
		-->
		</style>
	</head>
	
	<body OnLoad="document.forms[0].id.focus();">
	
		<div id="Layer1"><img src="images/BITLogo.jpg" alt="logo" width="201" height="174" /></div>
		
		<div id="Layer2">
			<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0" width="700" height="176" title="mov">
				<param name="movie" value="images/mov.swf" />
				<param name="quality" value="high" />
					<embed src="images/mov.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="700" height="176"></embed>
			</object>
		</div>
	
		<div id="Layer3">
		
		<fieldset>
			<legend> <strong>User Log</strong>  </legend>
				<form action="" method="post" name="frm2" id="frm2">
					<table width="217" align="right">
						<tr>
							<td width="764"><div align="left"><strong>UserID:</strong></div></td>
							<td width="144"><input type="text" name="id"   value="" /></td>
						</tr>
						<tr>
							<td><div align="right"><strong>Password</strong>:</div></td>
							<td><input type="password" name="pass" value="" /></td>
						</tr>
						<tr>
							<td colspan="2" align="center">
								<div align="right">
									<input type="submit" name="user_log" value="login" onclick="return validate();"/>
								</div>
							</td>
						</tr>
					</table>
				</form>
			</fieldset>
			<%
				if(request.getParameter("user_log")!=null)
				{
					String usr_name="",pas_word="";
					int i=0;
					usr_name=request.getParameter("id");
					pas_word=request.getParameter("pass");
					char c=usr_name.charAt(0);

					try 
					{
						Class.forName("sun.jdbc.odbc.JdbcOdbcDriver").newInstance();
						Connection con= DriverManager.getConnection("jdbc:odbc:dsn", "system", "cutee");
						ResultSet rs=null;
						if(Character.isDigit(c))
						{
							PreparedStatement  stmt=con.prepareStatement("select * from student where id=? and passwd=?");
							stmt.setString(1,usr_name);
							stmt.setString(2,pas_word);
							rs=stmt.executeQuery();
							while(rs.next())
							{
								session.setAttribute("ses_usr_name",usr_name);
								session.setAttribute("ses_passwd",pas_word);
								response.sendRedirect("studenthome.html");
							}
						}
						else if(Character.isLetter(c))
						{ 	
							if(usr_name.equals("admin"))
							{		
								PreparedStatement  stmt1=con.prepareStatement("select * from staff where id=? and passwd=?");
								stmt1.setString(1,usr_name);
								stmt1.setString(2,pas_word);
								rs=stmt1.executeQuery();
								while(rs.next())
								{
									session.setAttribute("ses_usr_name",usr_name);
									session.setAttribute("ses_passwd",pas_word);
									response.sendRedirect("admin.html");
								}
							}
							else
							{
								PreparedStatement  stmt1=con.prepareStatement("select * from staff where id=? and passwd=?");
								stmt1.setString(1,usr_name);
								stmt1.setString(2,pas_word);
								rs=stmt1.executeQuery();
								while(rs.next())
								{
									session.setAttribute("ses_usr_name",usr_name);
									session.setAttribute("ses_passwd",pas_word);
									response.sendRedirect("staffhome.jsp");
								}
							}
					
						}
						%>
						<script language="JavaScript" type="text/javascript">
							alert("Invalid Username/password. Please Re-enter");
							document.forms[0].id.value="<%=usr_name%>"
							document.forms[0].id.focus();
						</script>
						<%
						rs.close();
						con.close();
					}	 
					catch (SQLException e) 
					{
						out.println("SQLException: " + e.getMessage());
						out.println("SQLState: " + e.getSQLState());
						out.println("VendorError: " + e.getErrorCode());  
					}
				}
			%>
		</div>
		<script language="javascript">
			function validate()
			{
				var bool=true;
				var fd=window.document.forms[0];
				var msg="Enter ";
				if(fd.id.value.length==0)
				{
					msg+="UserName, ";
					document.forms[0].id.focus()
					bool=false;
					alert(msg);
					return bool;
				}
				if(fd.pass.value.length==0)
				{
					msg+="PassWord,";
					document.forms[0].pass.focus()
					bool=false;
					alert(msg);
					return bool;
				}
				return bool;
			}
		</script>
	</body>
</html>