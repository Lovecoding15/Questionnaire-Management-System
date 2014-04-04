<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*,java.lang.Character" %>
<%@ page import="java.sql.*,java.sql.SQLException,java.sql.DriverManager,javax.sql.DataSource" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@ page import="java.io.*" %>

<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		
		<title>Create Student</title>

		<style type="text/css">
		<!--
			#Layer1 {
				position:absolute;
				left:308px;
				top:303px;
				width:421px;
				height:202px;
				z-index:1;
			}
			#Layer2 {
				position:absolute;
				left:70px;
				top:18px;
				width:217px;
				height:173px;
				z-index:2;
			}
			#Layer3 {
				position:absolute;
				left:275px;
				top:18px;
				width:639px;
				height:172px;
				z-index:3;
			}
			.style3 {	font-size: 14px;
				font-weight: bold;
			}
			.style4 {font-size: 14px}
			#Layer4 {
				position:absolute;
				left:47px;
				top:289px;
				width:452px;
				height:211px;
				z-index:4;
			}
			#Layer5 {
				position:absolute;
				left:740px;
				top:506px;
				width:87px;
				height:49px;
				z-index:5;
			}
		-->
		</style>
	</head>

	<body >

		<script language="javascript">
			function validate()
			{
				var bool=true;
				var fd=window.document.forms[0];
				var msg="Enter ";
				if(fd.file.value.length==0)
				{
					msg+="FilePath, ";
					document.forms[0].file.focus()
					bool=false;
					alert(msg);
					return bool;
				}
				if(fd.nos.value.length==0)
				{
					msg+="No Of Students,";
					document.forms[0].nos.focus()
					bool=false;
					alert(msg);
					return bool;
				}
				return bool;
			}
			function validate1()
			{
				var bool=true;
				var fd=window.document.forms[1];
				var msg="Enter ";
				if(fd.rno.value.length==0)
				{
					msg+="RollNo,";
					document.forms[1].rno.focus()
					bool=false;
					alert(msg);
					return bool;		
				}
				if(fd.name.value.length==0)
				{
					msg+="Name, ";
					document.forms[1].name.focus()
					bool=false;
					alert(msg);
					return bool;
				}
				return bool;
			}
		</script>

		<div id="Layer2"><img src="../online/images/BITLogo.jpg" alt="logo" width="217" height="171" /></div>
		
		<div id="Layer3">
			<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0" width="700" height="173" title="mov">
				<param name="movie" value="images/mov.swf" />
				<param name="quality" value="high" />
					<embed src="images/mov.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="700" height="173"></embed>
			</object>
		</div>
		
		<p>&nbsp;</p>
		<p>&nbsp;</p>
		<p>&nbsp;</p>
		<p>&nbsp;</p>
		<p>&nbsp;</p>
		
		<div id="layer" align="left">
			<table width="60%" border="0">
				<tr>
					<td width="135"><div align="right"><strong><span class="style4"><a href="../online/admin.html">Admin Home </a></span></strong></div></td>
					<td width="100"><div align="right" class="style3"><a href="../online/student_index.html">Student Home</a></div></td>
					<td width="85"><div align="right" class="style3"><a href="../online/staff_index.html">Staff Home</a></div></td>
					<td width="135"><div align="right"><a href="../online/schedule_index.html"><strong>Schedule Home </strong></a></div></td>
					<td width="150"><div align="right" class="style3"><a href="../online/ques_upload.jsp">Question Paper upload </a></div></td>
					<td width="50"><div align="right" class="style3"><a href="JavaScript:location.replace('login.jsp')" onclick="<% session.setAttribute("ses_usr_name",null);session.setAttribute("ses_passwd",null);%>"><strong>Logout</strong></a><a href="../online/schedule_index.jsp"></a></div></td>
				</tr>
			</table>
		</div>
		<p>&nbsp;</p>
		<table width="60%" align="center">
			<tr>
				<td>
					<table width="35%">
						<tr><td>
						<fieldset>
							<legend>Upload Student File</legend>
							<form action="" method="post" name="frm" id="frm">
								<table border="0" width="100%">
									<tr>
										<td>Degree</td>
										<td><label>
											<select name="deg" size="1">
												<option>UG</option>
												<option>PG</option>
											</select>		
										</label></td>
									</tr>
									<tr>
										<td>Department</td>
										<td><label>
											<select name="dep" size="1">
												<option>IT</option>
												<option>EEE</option>
												<option>ECE</option>
												<option>CSE</option>
												<option>CIVIL</option>
											</select>
										</label></td>
									</tr>
									<tr>
										<td>Year</td>
										<td><label>
											<select name="year" size="1">
												<option>1</option>
												<option>2</option>
												<option>3</option>
												<option>4</option>
											</select>
										</label></td>
									</tr>
									<tr>
										<td>Sem</td>
										<td><label>
											<select name="sem" size="1">
												<option>1</option>
												<option>2</option>
												<option>3</option>
											</select>
										</label></td>
									</tr>
									<tr>
										<td>Select File to Upload</td>
										<td><input type="text" name="file"></td>
										<td><input name="button" type="button" onclick="document.dummy.browse.click();this.form.file.value=document.dummy.browse.value;" value="browse" /></td>
									</tr>
									<tr>
										<td>No of Students</td>
										<td><input type="text" name="nos" width="40" /></td>
									</tr>
									<tr>
										<td><input type="submit" name="upload" onclick="return validate();" value="Submit"/></td>
									</tr>
								</table>
							</form>
						</fieldset>
						</td></tr></table></td>
						<%  
							if(request.getParameter("upload")!=null)
							{
								int i,j,no=0;
								String s[]=new String[10];
								String Deg="",Dept="",Year="",Sem="",NOS="",name="";
	
								name=request.getParameter("file");
								Dept=request.getParameter("dep");
								Deg=request.getParameter("deg");
								Sem=request.getParameter("sem");
								Year=request.getParameter("year");
								NOS=request.getParameter("nos");
								no=Integer.parseInt(NOS);
	
								try
								{
									Class.forName("sun.jdbc.odbc.JdbcOdbcDriver").newInstance();
									Connection con= DriverManager.getConnection("jdbc:odbc:dsn", "system", "cutee");
									PreparedStatement ps=null;
									String command="insert into student(id,name,dept,year,sem,degree,passwd) values(?,?,?,?,?,?,?)";
			
									InputStream myxls = new FileInputStream(name);
									HSSFWorkbook wb = new HSSFWorkbook(myxls);
	
									for(i=0;i<no;i++)
									{
										HSSFSheet sheet = wb.getSheetAt(0);     
										HSSFRow row = sheet.getRow(i); 
						
										for(j=0;j<2;j++)
										{
											HSSFCell cell   = row.getCell((short)j);
											s[j]=cell.getStringCellValue();  
										}
										ps=con.prepareStatement(command);
										ps.setString(1,s[0]);
										ps.setString(2,s[1]);
										ps.setString(3,Dept);
										ps.setString(4,Year);
										ps.setString(5,Sem);
										ps.setString(6,Deg);
										ps.setString(7,s[0]);
										ps.executeUpdate();
									}
									%>
										<script language="JavaScript" type="text/javascript">alert("File Uploaded");</script>
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
					<table width="35%">
						<tr><td>
						<fieldset>
							<legend>Add Particular Data</legend>
							<form action="" method="post" name="frm1" id="frm">
								<table width="100%">
									<tr>
										<td>Roll No</td>
										<td><input type="text" name="rno"></td>
									</tr>
									<tr>
										<td>Name</td>
										<td><input type="text" name="name"></td>
									</tr> 
									<tr>
										<td>Degree</td>
										<td><label>
											<select name="dg" size="1">
												<option>UG</option>
												<option>PG</option>
											</select>
										</label></td>
									</tr>
									<tr>
										<td>Department</td>
										<td><label>
											<select name="dept" size="1">
												<option>IT</option>
												<option>EEE</option>
												<option>ECE</option>
												<option>CSE</option>
												<option>CIVIL</option>
											</select>
										</label></td>
									</tr>
									<tr>
										<td>Year</td>
										<td><label>
											<select name="yr" size="1">
												<option>1</option>
												<option>2</option>
												<option>3</option>
												<option>4</option>
											</select>
										</label></td>
									</tr>
									<tr>
										<td>Sem</td>
										<td><label>
											<select name="sm" size="1">
												<option>1</option>
												<option>2</option>
												<option>3</option>
											</select>
										</label></td>
									</tr>	
									<tr>
										<td><input type="submit" name="upload2" value="Submit" onclick="return validate1();" /></td>
									</tr>
								</table>
							</form>
						</fieldset>
						</td></tr></table></td></tr></table>
						<%  
							if(request.getParameter("upload2")!=null)
							{
								String Deg="",Dept="",Year="",Sem="",Rno="",name="";
								name=request.getParameter("name");
								Dept=request.getParameter("dept");
								Deg=request.getParameter("dg");
								Sem=request.getParameter("sm");
								Year=request.getParameter("yr");
								Rno=request.getParameter("rno");
								try
								{
									Class.forName("sun.jdbc.odbc.JdbcOdbcDriver").newInstance();
									Connection con= DriverManager.getConnection("jdbc:odbc:dsn", "system", "cutee");
									PreparedStatement ps=null;
									String command="insert into student(id,name,dept,year,sem,degree,passwd) values(?,?,?,?,?,?,?)";
									ps=con.prepareStatement(command);
									ps.setString(1,Rno);
									ps.setString(2,name);
									ps.setString(3,Dept);
									ps.setString(4,Year);
									ps.setString(5,Sem);
									ps.setString(6,Deg);
									ps.setString(7,Rno);
									ps.executeUpdate();
									%>
										<script language="JavaScript" type="text/javascript">alert("Record Updated");</script>
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
	
		<div id="Layer5">
			<form name="dummy" id="dummy">
				<input type="file" name="browse" style="display:none;" />
			</form>
		</div>
	</body>
</html>