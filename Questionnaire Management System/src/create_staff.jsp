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
		
		<title>Staff Creation</title>

		<style type="text/css">
		<!--
			#Layer1 {
				position:absolute;
				left:274px;
				top:271px;
				width:362px;
				height:216px;
				z-index:1;
			}
			#Layer2 {
				position:absolute;
				left:38px;
				top:209px;
				width:862px;
				height:25px;
				z-index:2;
			}
			.style3 {
				font-size: 14px;
				font-weight: bold;
			}
			.style4 {font-size: 14px}
			#Layer3 {
				position:absolute;
				left:70px;
				top:20px;
				width:184px;
				height:155px;
				z-index:3;
			}
			#Layer4 {
				position:absolute;
				left:270px;
				top:20px;
				width:539px;
				height:155px;
				z-index:4;
			}
			#Layer5 {
				position:absolute;
				left:86px;
				top:272px;
				width:467px;
				height:217px;
				z-index:5;
			}
			.style5 {
				color: #000066;
				font-size: 18px;
			}
			#Layer6 {
				position:absolute;
				left:586px;
				top:273px;
				width:273px;
				height:251px;
				z-index:6;
			}
		-->
		</style>
	</head>
	
	<body>
		
		<div id="Layer2">
			<table border="0" align="left">
				<tr>
					<td width="110"><div align="right"><strong><span class="style4"><a href="../online/admin.html">Admin Home </a></span></strong></div></td>
					<td width="120"><div align="right" class="style3"><a href="../online/student_index.html">Student Home </a></div></td>
					<td width="100"><div align="right" class="style3"><a href="../online/staff_index.html">Staff Home</a></div></td>
					<td width="125"><div align="right" class="style3"><a href="../online/schedule_index.html">Schedule Home</a></div></td>
					<td width="176"><div align="right" class="style3"><a href="../online/ques_upload.jsp">Question Paper upload </a></div></td>
					<td width="80"><div align="right" class="style3"><a href="JavaScript:location.replace('login.jsp')" onclick="<% session.setAttribute("ses_usr_name",null);session.setAttribute("ses_passwd",null);%>"><strong>Logout</strong></a></div></td>
				</tr>
			</table>
		</div>
		
		<div id="Layer3"><img src="../online/images/BITLogo.jpg" alt="logo" width="183" height="158" /></div>
		
		<div id="Layer4">
			<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0" width="700" height="163" title="mov">
				<param name="movie" value="../online/images/mov.swf" />
				<param name="quality" value="high" />
					<embed src="../online/images/mov.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="700" height="163"></embed>
			</object>
		</div>
		
		<div id="Layer5">
			<table width="80%" align="right"><tr><td>
			<fieldset>
				<legend><strong>Upload File</strong></legend>
				<form action="" method="post" name="frm" id="frm">
					<table>
						<tr>
							<td>Select File to Upload</td>
							<td><input type="text" name="file"></td>
							<td><input name="button" type="button" onclick="document.dummy.browse.click();this.form.file.value=document.dummy.browse.value;" value="browse" /></td>
						</tr>
						<tr>
							<td>No of Staffs</td>
							<td><input type="text" name="nos" width="40" /></td>
						</tr>
						<tr>
							<td><input type="submit" name="upload" value="Submit" onclick="return validate();"/></td>
						</tr>
					</table>
				</form>
			</fieldset></td></tr></table>
			<form name="dummy" id="dummy">
				<input type="file" name="browse" style="display:none;" />
			</form>
			<%  
				int i,j,no=0;
				if(request.getParameter("upload")!=null)
				{
					String s[]=new String[50];
					String NOS="",name="";
	
					name=request.getParameter("file");
					NOS=request.getParameter("nos");
					no=Integer.parseInt(NOS);
					try
					{
						Class.forName("sun.jdbc.odbc.JdbcOdbcDriver").newInstance();
						Connection con= DriverManager.getConnection("jdbc:odbc:dsn", "system", "cutee");
						PreparedStatement ps=null;
						String command="insert into staff(id,passwd) values(?,?)";
			
						InputStream myxls = new FileInputStream(name);
						HSSFWorkbook wb     = new HSSFWorkbook(myxls);
						for(i=0;i<no;i++)
						{
							HSSFSheet sheet = wb.getSheetAt(0);     
							HSSFRow row = sheet.getRow(i); 
		
							for(j=0;j<1;j++)
							{
								HSSFCell cell   = row.getCell((short)j);
								s[j]=cell.getStringCellValue();  
							}
							ps=con.prepareStatement(command);
							ps.setString(1,s[0]);
							ps.setString(2,s[0]);
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
		</div>
			
		<div id="Layer6">
			<fieldset>
				<legend><strong>Add a Particular</strong></legend>
				<form action="" method="post" name="frm1" id="frm1">
					<table>
						<tr>
							<td>ID</td>
							<td><label>
								<input name="id" type="text" id="id" width="40" />
							</label></td>
						</tr>
						<tr>
							<td><input name="upload2" type="submit" value="Submit" onclick="return validate1();" /></td>
						</tr>
					</table>
				</form>

				<%
					if(request.getParameter("upload2")!=null)
					{
						String id="";
						id=request.getParameter("id");

						try
						{
							Class.forName("sun.jdbc.odbc.JdbcOdbcDriver").newInstance();
							Connection con= DriverManager.getConnection("jdbc:odbc:dsn", "system", "cutee");
							PreparedStatement ps=null;
							String command="insert into staff(id,passwd) values(?,?)";
							ps=con.prepareStatement(command);
							ps.setString(1,id);
							ps.setString(2,id);	
							ps.executeUpdate();
							%>
								<script language="JavaScript" type="text/javascript">alert("Record Uploaded");</script>
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
			</fieldset>
		</div>
			
		<script language="javascript">
			function validate()
			{
				var bool=true;
				var fd=window.document.forms[0];
				var msg="Enter ";
				if(fd.file.value.length==0)
				{
					msg+="FilePath, ";
					fd.file.focus()
					bool=false;
					alert(msg);
					return bool;
				}
				if(fd.nos.value.length==0)
				{
					msg+="No Of Staffs,";
					fd.nos.focus()
					bool=false;
					alert(msg);
					return bool;
				}
				return bool;
			}
			function validate1()
			{
				var bool=true;
				var fd=window.document.frm1;
				var msg="Enter ";
				if(fd.id.value.length==0)
				{
					msg+="ID,";
					fd.id.focus()
					bool=false;
					alert(msg);
					return bool;
				}
				return bool;
			}
		</script>
	</body>
</html>