<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*,java.lang.Character" %>
<%@ page import="java.sql.*,java.sql.SQLException,java.sql.DriverManager,javax.sql.DataSource" %>
<%@ page import="java.io.*" %>

<html>
	<head>
	
		<title> Edit Student </title>
		
		<style type="text/css">
		<!--
			#Layer1 {
				position:absolute;
				left:70px;
				top:21px;
				width:187px;
				height:142px;
				z-index:1;
			}
			#Layer2 {
				position:absolute;
				left:275px;
				top:21px;
				width:688px;
				height:163px;
				z-index:2;
			}
			#Layer3 {
				position:absolute;
				left:23px;
				top:290px;
				width:950px;
				height:227px;
				z-index:3;
			}
			#Layer4 {
				position:absolute;
				left:13px;
				top:198px;
				width:928px;
				height:37px;
				z-index:4;
			}
			.style3 {font-size: 14px;
				font-weight: bold;
			}
			.style4 {font-size: 14px}
		-->
		</style>
	</head>
	
	<body OnLoad="document.forms[0].id.focus();">
		
		<div id="Layer1"><img src="../../online/images/BITLogo.jpg" alt="logo" width="216" height="162" /></div>
		
		<div id="Layer2">
			<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0" width="700" height="161" title="mov">
				<param name="movie" value="../../online/images/mov.swf" />
				<param name="quality" value="high" />
					<embed src="../../online/images/mov.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="700" height="161"></embed>
			</object>
		</div>

		<p> &nbsp</p>
		<p> &nbsp</p>
		<p> &nbsp</p>
		<p> &nbsp</p>
		<p> &nbsp</p>
		<p> &nbsp</p>
		<p> &nbsp</p>

		<form>
		<table width="60%" align="center">
			<tr>
				<td>
					<table width="70%">
						<tr><td>
						<fieldset>
							<legend>To Delete Whole Database</legend>
								click here: &nbsp &nbsp
								<input type="submit" name="delete" value="Delete"/>
						</fieldset>
						</td></tr></table></td>
						<%  
										if(request.getParameter("delete")!=null)
										{
											try
											{
												Class.forName("sun.jdbc.odbc.JdbcOdbcDriver").newInstance();
												Connection con= DriverManager.getConnection("jdbc:odbc:dsn", "system", "cutee");
												PreparedStatement ps=null;
												String command="truncate table student";
												ps=con.prepareStatement(command);
												ps.executeUpdate();
												%>
													<script language="JavaScript" type="text/javascript">alert("Records Deleted");</script>
												<%
												ps.close();
												con.close();
											}
											catch(SQLException ex)
											{
												out.println("SQL EXCEPTION:" + ex.getMessage());
												out.println("SQL state:" + ex.getSQLState());
												out.println("SQL code:" + ex.getErrorCode());
											}
										}
						%>
				<td>
					<table width="70%">
						<tr><td>
						<fieldset>
							<legend>Edit/Delete a Particular Data</legend>
								<table width="100%">
									<tr>
										<td>Enter the student id:</td>
										<td><input type="text" name="id" value=""/></td>
									</tr>
									<tr>
										<td align=right colspan=2><input type="submit" name="load" value="Load" onclick="return validate1();"/></td>
									</tr>
								</table>
						</fieldset>
						</td></tr></table></td></tr></table>
						<%  
										if(request.getParameter("delete")!=null)
										{
											try
											{
												Class.forName("sun.jdbc.odbc.JdbcOdbcDriver").newInstance();
												Connection con= DriverManager.getConnection("jdbc:odbc:dsn", "system", "cutee");
												PreparedStatement ps=null;
												String command="truncate table student";
												ps=con.prepareStatement(command);
												ps.executeUpdate();
												%>
													<script language="JavaScript" type="text/javascript">alert("Records Deleted");</script>
												<%
												ps.close();
												con.close();
											}
											catch(SQLException ex)
											{
												out.println("SQL EXCEPTION:" + ex.getMessage());
												out.println("SQL state:" + ex.getSQLState());
												out.println("SQL code:" + ex.getErrorCode());
											}
										}
										else if(request.getParameter("load")!=null)
										{
											try
											{
												String id=request.getParameter("id");
												Class.forName("sun.jdbc.odbc.JdbcOdbcDriver").newInstance();
												Connection con= DriverManager.getConnection("jdbc:odbc:dsn", "system", "cutee");
												PreparedStatement ps=null;
												ResultSet rs = null;
												String command="select * from student where id=?";
												ps=con.prepareStatement(command);
												ps.setString(1,id);
												rs=ps.executeQuery();
												%>
													<script language="JavaScript" type="text/javascript">
														var s = "<%=id%>";
														document.forms[0].id.value = s;
													</script>
												<%
												if(rs.next())
												{	
													%>
														<tr>
															<td>id</td>
															<td>name</td>
														</tr>
														<tr>
															<td><input name="text" type="text" value="<%=rs.getString("id")%>" readonly="true" /></td>
															<td><input type="text" name="n1" value="<%=rs.getString("name")%>" /></td>
														</tr>
														<tr>
															<td align=center><input type="submit" value="Update" name="update" onclick="return validate();" /></td>
															<td align=center><input type="submit" value="Delete" name="delete1"  /></td>
														</tr>
													<%	
												}
												else
												{
													%>
														<script language="JavaScript" type="text/javascript">
															alert("Record not found")
															document.forms[0].id.value="";
															document.forms[0].id.focus()
														</script>
													<%
												}
												rs.close();
												ps.close();
												con.close();	
											}
											catch(SQLException ex)
											{
												out.println("SQL EXCEPTION:" + ex.getMessage());
												out.println("SQL state:" + ex.getSQLState());
												out.println("SQL code:" + ex.getErrorCode());
											}	
										}
										else if(request.getParameter("update")!=null)
										{
											try
											{
												String id=request.getParameter("id");
												String name=request.getParameter("n1");
				
												Class.forName("sun.jdbc.odbc.JdbcOdbcDriver").newInstance();
												Connection con= DriverManager.getConnection("jdbc:odbc:dsn", "system", "cutee");
												PreparedStatement ps=null;
												String command="update student set name=? where id=?";
												ps=con.prepareStatement(command);
												ps.setString(1,name);
												ps.setString(2,id);
												ps.executeUpdate();
												%>
													<script language="JavaScript" type="text/javascript">
														alert("Record Updated");
													</script>
												<%
												ps.close();
												con.close();
											}
											catch(SQLException ex)
											{
												out.println("SQL EXCEPTION:" + ex.getMessage());
												out.println("SQL state:" + ex.getSQLState());
												out.println("SQL code:" + ex.getErrorCode());
											}
										}
										else if(request.getParameter("delete1")!=null)
										{
											try
											{
												String id=request.getParameter("id");
												Class.forName("sun.jdbc.odbc.JdbcOdbcDriver").newInstance();
												Connection con= DriverManager.getConnection("jdbc:odbc:dsn", "system", "cutee");
												PreparedStatement ps=null;
												String command="delete from student where id=?";
												ps=con.prepareStatement(command);
												ps.setString(1,id);
												ps.executeUpdate();
												%>
													<script language="JavaScript" type="text/javascript">alert("Record Deleted");</script>
												<%
												ps.close();
												con.close();
											}
											catch(SQLException ex)
											{
												out.println("SQL EXCEPTION:" + ex.getMessage());
												out.println("SQL state:" + ex.getSQLState());
												out.println("SQL code:" + ex.getErrorCode());
											}
										}
						%>

		
		<div id="Layer4">
			<table border="0" align="left">
				<tr>
					<td width="135"><div align="right"><strong><span class="style4"><a href="../online/admin.html">Admin Home </a></span></strong></div></td>
					<td width="100"><div align="right" class="style3"><a href="../online/staff_index.html">Staff Home </a></div></td>
					<td width="125"><div align="right" class="style3"><a href="../online/student_index.html">Student Home </a></div></td>
					<td width="150"><div align="right"><a href="../online/schedule_index.html"><strong>Schedule Home </strong></a></div></td>
					<td width="180"><div align="right" class="style3"><a href="../online/ques_upload.jsp">Question Paper upload </a></div></td>
					<td width="90"><div align="right" class="style3"><a href="JavaScript:location.replace('login.jsp')" onclick="<% session.setAttribute("ses_usr_name",null);session.setAttribute("ses_passwd",null);%>"><strong>Logout</strong></a><a href="../online/schedule_index.jsp"></a></div></td>
				</tr>
			</table>
		</div>
		
		<p>&nbsp;</p>
		
		<script language="javascript">
			function validate()
			{
				var bool=true;
				var fd=window.document.forms[0];
				var msg="Enter ";
				if(fd.n1.value.length==0)
				{
					msg+="Name, ";
					document.forms[0].n1.focus()
					bool=false;
					alert(msg);
					return bool;
				}
				return bool;
			}
			function validate1()
			{
				var bool=true;
				var fd=window.document.forms[0];
				var msg="Enter ";
				if(fd.id.value.length==0)
				{
					msg+="ID, ";
					document.forms[0].id.focus()
					bool=false;
					alert(msg);
					return bool;
				}
				return bool;
			}
		</script>
	</body>
</html>