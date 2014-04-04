<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*,java.lang.Character" %>
<%@ page import="java.sql.*,java.sql.SQLException,java.sql.DriverManager,javax.sql.DataSource" %>
<%@ page import="java.io.*" %>

<html>
	<head>
		<title> Edit Staff </title>

		<style type="text/css">
		<!--
			#Layer1 {
				position:absolute;
				left:70px;
				top:20px;
				width:188px;
				height:148px;
				z-index:1;
			}
			#Layer2 {
				position:absolute;
				left:275px;
				top:20px;
				width:712px;
				height:158px;
				z-index:2;
			}
			#Layer3 {
				position:absolute;
				left:15px;
				top:277px;
				width:961px;
				height:166px;
				z-index:3;
			}
			#Layer4 {
				position:absolute;
				left:14px;
				top:197px;
				width:955px;
				height:31px;
				z-index:4;
			}
			.style3 {font-size: 14px;
				font-weight: bold;
			}
			.style4 {font-size: 14px}
		-->
		</style>
	</head>
	
	<body>
		
		<div id="Layer1"><img src="../../online/images/BITLogo.jpg" alt="logo" width="213" height="158" /></div>
		
		<div id="Layer2">
			<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0" width="709" height="158" title="mov">
				<param name="movie" value="../../online/images/mov.swf" />
				<param name="quality" value="high" />
					<embed src="../../online/images/mov.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="709" height="158"></embed>
			</object>
		</div>
		
		<div id="Layer3">
			<form>
				<table width="70%" align="right">
					<tr>
						<td>
							<table width="85%" align="center"><tr><td align="center">
							<fieldset><legend><b>To Delete the Whole Database</b></legend>
								click here: &nbsp &nbsp 
								<input type="submit" name="delete" value="Delete"/>
							</fieldset> </td></tr></table>
						</td>
						<td>
							<table width="90%" align="center"><tr><td>
							<fieldset><legend><b>Edit/Delete a Particular</b></legend>
								<table>
									<tr>
										<td>Enter the staff id:</td>
										<td><input type="text" name="id" value=""/></td>
									</tr>
									<tr>
										<td align=right colspan=2><input type="submit" name="delete1" value="Delete" onclick="return validate();"/></td>
									</tr>
									<%
										if(request.getParameter("delete")!=null)
										{
											try
											{
												Class.forName("sun.jdbc.odbc.JdbcOdbcDriver").newInstance();
												Connection con= DriverManager.getConnection("jdbc:odbc:dsn", "system", "cutee");
												PreparedStatement ps=null;
												String command="truncate table staff";
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
										else if(request.getParameter("delete1")!=null)
										{
											try
											{
												String id=request.getParameter("id");
												Class.forName("sun.jdbc.odbc.JdbcOdbcDriver").newInstance();
												Connection con= DriverManager.getConnection("jdbc:odbc:dsn", "system", "cutee");
												PreparedStatement ps=null;
												ResultSet rs=null;
												String command="select * from staff where id=?";
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
													command="delete from staff where id=?";
													ps=con.prepareStatement(command);
													ps.setString(1,id);
													ps.executeUpdate();	
													%>
														<script language="JavaScript" type="text/javascript">alert("Record Deleted");		               
															document.forms[0].id.value = "";		
															document.forms[0].id.focus();
														</script>                        
													<%
												}
												else
												{
													%>
														<script language="JavaScript" type="text/javascript">
															alert("Record not found")
															document.forms[0].id.value = "";		
															document.forms[0].id.focus();
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
									%>
								</table>
							</fieldset></td></tr></table>
						</td>
					</tr>
				</table>
			</form>
		</div>
		
		<div id="Layer4">
			<table align="left" border="0">
				<tr>
					<td width="130"><div align="right"><strong><span class="style4"><a href="../online/admin.html">Admin Home </a></span></strong></div></td>
					<td width="110"><div align="right" class="style3"><a href="../online/staff_index.html">Staff Home </a></div></td>
					<td width="125"><div align="right" class="style3"><a href="../online/student_index.html">Student Home </a></div></td>
					<td width="145"><div align="right"><a href="../online/schedule_index.html"><strong>Schedule Home</strong></a></div></td>
					<td width="175"><div align="right" class="style3"><a href="../online/ques_upload.jsp">Question Paper upload </a></div></td>
					<td width="80"><div align="right" class="style3"><a href="JavaScript:location.replace('login.jsp')" onclick="<% session.setAttribute("ses_usr_name",null);session.setAttribute("ses_passwd",null);%>"><strong>Logout</strong></a><a href="../online/schedule_index.jsp"></a></div></td>
				</tr>
			</table>
		</div>
		
		<script language="javascript">
			function validate()
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
