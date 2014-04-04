<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="java.util.Date,java.text.*,java.sql.*,java.sql.SQLException,java.sql.DriverManager,javax.sql.DataSource" %>
<%@ page import="java.io.*,java.lang.Character" %>
<%@ page import="java.io.FileInputStream.*" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFRow"%>

<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Upload Question </title>
		
		<script language="javascript">
			function fillYears() 
			{
				var today = new Date()
				var thisYear = today.getFullYear()
				var yearChooser = document.forms[0].bat
				for (i = 2009; i <= thisYear; i++) {
					yearChooser.options[yearChooser.options.length] = new Option(i, i)
				}
			}
		</script>

		<style type="text/css">
		<!--
			#Layer1 {
				position:absolute;
				left:70px;
				top:20px;
				width:174px;
				height:164px;
				z-index:1;
			}
			#Layer2 {
				position:absolute;
				left:275px;
				top:20px;
				width:718px;
				height:172px;
				z-index:2;
			}
			#Layer3 {
				position:absolute;
				left:150px;
				top:289px;
				width:942px;
				height:200px;
				z-index:3;
			}
			.style1 {
				color: #000099;
				font-size: 18px;
			}
			#Layer4 {
				position:absolute;
				left:70px;
				top:212px;
				width:940px;
				height:32px;
				z-index:4;
			}
			.style3 {font-size: 14px;
				font-weight: bold;
			}
			.style4 {font-size: 14px}
		-->
		</style>
	</head>

	<body onLoad="fillYears();">
		<script>
			function validate()
			{
				var bool=true;
				var k=document.forms[0].k.value
				for(var i=1;i<k;i++)
				{
					var file=document.getElementsByName('file'+i);
					if((file[0].value.length!=0 ))
					{
						var noq = document.getElementsByName('noq'+i);
						if(noq[0].value.length==0 )
						{
							alert("Enter No Of Questions to be inserted..!");
							bool=false;
							noq[0].focus();
							return bool;
						}
					}
				}
			}
		</script>

		<div id="Layer1"><img src="images/BITLogo.jpg" alt="logo" width="186" height="174" /></div>

		<div id="Layer2">
			<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0" width="716" height="170" title="mov">
				<param name="movie" value="images/mov.swf" />
				<param name="quality" value="high" />
					<embed src="images/mov.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="716" height="170"></embed>
			</object>
		</div>

		<div id="Layer3">
		<table width="75%" align="center">
			<tr><td>
			<fieldset>
				<legend class="style1">Question Upload</legend>
				<form action="" method="post">
					<table>
						<tr>
							<td>Batch: &nbsp 
								<select name="bat"></select>
							</td>
							<td>&nbspDegree:
							&nbsp
								<select name="deg">
									<option value="UG">UG</option>
									<option value="PG">PG</option>
								</select>
							</td>
							<td>&nbspDepartment:
							&nbsp
								<select name="dept">
									<option value="CSE">CSE</option>
									<option value="IT">IT</option>
								</select>
							</td>
						</tr>
						<tr>
							<td>Year:
							&nbsp&nbsp
								<select name="year">
									<option value="1">1</option>
									<option value="2">2</option>
									<option value="3">3</option>
									<option value="4">4</option>
									<option value="5">5</option>
								</select>
							</td>
							<td>&nbspSemester:
							&nbsp
								<select name="sem">
									<option value="1">1</option>
									<option value="2">2</option>
									<option value="3">3</option>
								</select>
							</td>
							<td>&nbspExam Type:
							&nbsp
								<select name="ex_type">
									<option value="P1">Periodicals 1</option>
									<option value="P2">Periodicals 2</option>
									<option value="P3">Periodicals 3</option>
									<option value="M">Model Exam</option>
									<option value="UNIV">University Exam</option>
								</select>
							</td> 
						</tr>
						<tr> <td> &nbsp </td> </tr>
						<tr>							<td align="center" colspan=3><input type="submit" name="load" value="Load" /></td></tr>
						<%
							if(request.getParameter("load")!=null)
							{
								String date,sem,dept,year,deg,ex_type;
								int l=1,k=1,m=1;
								date = request.getParameter("bat");
								sem = request.getParameter("sem");
								dept = request.getParameter("dept");
								year = request.getParameter("year");
								deg = request.getParameter("deg");
								ex_type = request.getParameter("ex_type");
								String db = date+deg+dept+year+sem+ex_type;

								Connection conn=null;
								try
								{
									Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
									conn = DriverManager.getConnection("jdbc:odbc:dsn","system","cutee");
									ResultSet rs1,rs2;
									Statement st = conn.createStatement();
									Statement st1 = conn.createStatement();
									Statement st2 = conn.createStatement();
									String table = "select * from tab";
									ResultSet rs = st.executeQuery(table);
									String tem = "SCHEDULE_" + db;
									int exists=0;
									while(rs.next())
									{
										if(rs.getString("tname").equals(tem))
										{
											exists=1;
											table = "select * from " +tem;
											rs1 = st1.executeQuery(table);
											%>
												<script language="JavaScript">
																	var today = new Date()
																	var thisYear = today.getFullYear()
																	var diff = thisYear - 2009;
																	fillYears() 
																	for(i=0;i<=diff;i++)
																	{
																		if(document.forms[0].bat.options[i].text == <%=date%>)
																			document.forms[0].bat.options[i].selected=true;
																	}	  	
												for(i=0;i<5;i++)
												{
													if(document.forms[0].year.options[i].text == <%=year%>)
														document.forms[0].year.options[i].selected=true;
												}
												var s = "<%=sem%>";
												for(i=0;i<3;i++)
												{
													if(document.forms[0].sem.options[i].text == s)
														document.forms[0].sem.options[i].selected=true;
												}
												var de = "<%=dept%>";
												for(i=0;i<2;i++)
												{
													if(document.forms[0].dept.options[i].text == de)
														document.forms[0].dept.options[i].selected=true;
												}
												de = "<%=ex_type%>";
												for(i=0;i<5;i++)
												{
													if(document.forms[0].ex_type.options[i].value == de)
														document.forms[0].ex_type.options[i].selected=true;
												}
												de = "<%=deg%>";
												for(i=0;i<2;i++)
												{
													if(document.forms[0].deg.options[i].text == de)
														document.forms[0].deg.options[i].selected=true;
												}
											</script>
										<tr><td> &nbsp </td></tr>
												<tr>
													<th width="27%"> Subject_Code </th>
													<th width="33%"> File Path </th>
													<th width="20%"> No of Ques. </th>
													<th width="20%"> Timing (in Mins)</th>				
												</tr>
												<%
													while(rs1.next())
													{
														String s_code = rs1.getString("sub_code");
														s_code = s_code.toUpperCase();
														%>
															<tr>
																<td align="center"><input type="text" readonly="true" name="s_code<%=m%>" value="<%=s_code%>" /></td>
															<%
																String x = "QUES_"+db+s_code;
																int flag = 0;
																table = "SELECT * FROM tab";
																rs2 = st2.executeQuery(table);
																while(rs2.next())
																{
																	if(rs2.getString("tname").equals(x))
																	{
																		flag = 1;
																		%>
																			<td align="center"><strong>LOADED</strong>&nbsp&nbsp<input type="checkbox" name="<%=l%>" value="<%=m%>" /></td><td align="center">---</td><td align="center">---</td>
																		</tr>
																		<%
																		l++;
																		break;
																	}
																}
																if(flag == 0)
																{
																	%>
																		<td align="center"><input type="text" name="file<%=k%>"/><input name="button<%=k%>" type="button" onclick="document.dummy.browse.click();this.form.file<%=k%>.value=document.dummy.browse.value;" value="browse" id="b<%=k%>" /></td><td align="center"><input type="text" name="noq<%=k%>" value="" size=4></td><td align="center"><input type="text" name="time<%=k%>" value="" size=4><input type="hidden" name="h<%=k%>" value="<%=m%>"/></td></tr>
																	<%
																	k++;
																}
																m++;
														}
													%>
												<tr><td> &nbsp </td></tr>
												<tr>
													<td colspan=4 align="center"><input type="submit" name="update" value="Update" onClick="return validate()";>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<input type="submit" name="delete" value="Delete"></td>
												</tr>
										<tr>
											<td><input type="hidden" name="l" value="<%=l%>"/></td>
											<td><input type="hidden" name="k" value="<%=k%>"/></td>
										</tr>
										<%
											break;
										}
									}
									if(exists==0)
									{
										%>
											<script language="JavaScript" type="text/javascript">alert("Schedule has not been created.. Please create it!");</script>
										<%
									}
									st.close();
									st1.close();
									st2.close();
									conn.close();
								}
								catch(SQLException ex)
								{
									out.println("SQL EXCEPTION:" + ex.getMessage());
									out.println("SQL state:" + ex.getSQLState());
									out.println("SQL code:" + ex.getErrorCode());
								}
							}
							if(request.getParameter("update")!=null)
							{
								String date,sem,dept,year,deg,ex_type;
								date = request.getParameter("bat");
								sem = request.getParameter("sem");
								deg = request.getParameter("deg");
								ex_type = request.getParameter("ex_type");
								dept = request.getParameter("dept");
								year = request.getParameter("year");
								String db = date+deg+dept+year+sem+ex_type;
								String s[]=new String[50];

								String file="",su_code;
								String noq,time;
								int k=Integer.parseInt(request.getParameter("k"));
								for(int z = 1; z<k; z++)
								{
									file = request.getParameter("file"+Integer.toString(z));
									if(file != "")
									{
										noq = request.getParameter("noq"+Integer.toString(z));
										time = request.getParameter("time"+Integer.toString(z));
										String svalue = request.getParameter("h"+Integer.toString(z));
										su_code = request.getParameter("s_code"+svalue);
										try
										{
											Class.forName("sun.jdbc.odbc.JdbcOdbcDriver").newInstance();
											Connection con= DriverManager.getConnection("jdbc:odbc:dsn", "system", "cutee");
											PreparedStatement ps=null;
											String command="create table QUES_" +db+su_code+ "(sno varchar(3), ques varchar(500), c1 varchar(100), c2 varchar(100), c3 varchar(100), c4 varchar(100), ans varchar(3), primary key(sno))";
											ps = con.prepareStatement(command);
											ps.executeUpdate();

											command = "update SCHEDULE_" +db+ " set noq=?,time=? where sub_code=?";
											ps = con.prepareStatement(command);
											ps.setString(1,noq);
											ps.setString(2,time);
											ps.setString(3,su_code);
											ps.executeUpdate();

											command="insert into QUES_" +db+su_code+ " values(?,?,?,?,?,?,?)";

											InputStream myxls = new FileInputStream(file);
											HSSFWorkbook wb     = new HSSFWorkbook(myxls);
											int noqInt = Integer.parseInt(noq);
											for(int i=0;i<noqInt;i++)
											{
												HSSFSheet sheet = wb.getSheetAt(0);
												HSSFRow row = sheet.getRow(i);

												for(int j=0;j<6;j++)
												{
													HSSFCell cell   = row.getCell((short)j);
													s[j]=cell.getStringCellValue();
												}
												ps=con.prepareStatement(command);
												ps.setString(1,Integer.toString(i+1));
												ps.setString(2,s[0]);
												ps.setString(3,s[1]);
												ps.setString(4,s[2]);
												ps.setString(5,s[3]);
												ps.setString(6,s[4]);
												ps.setString(7,s[5]);
												ps.executeUpdate();
											}
											%>
												<script language="JavaScript" type="text/javascript">alert("Question Paper Updated");</script>
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
								}
							}
							if(request.getParameter("delete")!=null)
							{
								String date,sem,dept,year,deg,ex_type;

								date = request.getParameter("bat");
								sem = request.getParameter("sem");
								deg = request.getParameter("deg");
								ex_type = request.getParameter("ex_type");
								dept = request.getParameter("dept");
								year = request.getParameter("year");
								String db = date+deg+dept+year+sem+ex_type;
								int l=Integer.parseInt(request.getParameter("l"));
								String check;
								Connection conn=null;
			
								try
								{
									Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
									conn = DriverManager.getConnection("jdbc:odbc:dsn","system","cutee");
									Statement st = conn.createStatement();
									ResultSet rs = null;
									PreparedStatement sch = null;
	
									for(int z = 1; z<l; z++)
									{
										check = request.getParameter(Integer.toString(z));
										if(check != null)
										{
											String s_code = request.getParameter("s_code"+check);
											sch = conn.prepareStatement("drop table QUES_" +db+s_code);
											sch.executeUpdate();
										}
									}
									%> 
										<script> alert("Question Paper Deleted !") </script> 
									<%
									conn.close();
								}
								catch (SQLException ex)
								{
									out.println("SQLException: " + ex.getMessage());
									out.println("SQLState: " + ex.getSQLState());
									out.println("VendorError: " + ex.getErrorCode());
								}
							}
						%>	
					</table>
				</form>
			</fieldset></td></tr></table>
			<form name="dummy" id="dummy">
				<input type="file" name="browse" style="display:none;" />
			</form>
		</div>
		
		<div id="Layer4">
			<table width="60%" border="0" align="left">
				<tr>
					<td width="124"><div align="right"><strong><span class="style4"><a href="../online/admin.html">Admin Home </a></span></strong></div></td>
					<td width="151"><div align="right" class="style3"><a href="../online/student_index.html">Student Home </a></div></td>
					<td width="130"><div align="right" class="style3"><a href="../online/staff_index.html">Staff Home </a></div></td>
					<td width="150"><div align="right" class="style3"><a href="../online/schedule_index.html">Schedule Home </a></div></td>
					<td width="80"><div align="right" class="style3"><a href="JavaScript:location.replace('login.jsp')" onclick="<% session.setAttribute("ses_usr_name",null);session.setAttribute("ses_passwd",null);%>"><strong>Logout</strong></a></div></td>
				</tr>
			</table>
		</div>
		
		<p>&nbsp;</p>
	</body>
</html>