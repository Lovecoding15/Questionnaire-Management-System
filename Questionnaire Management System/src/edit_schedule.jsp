<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*,java.util.Date,java.text.*" %>
<%@ page import="java.io.*,java.lang.Character" %>
<%@ page import="java.sql.*,java.sql.SQLException,java.sql.DriverManager,javax.sql.DataSource" %>

<html>
	<head>

		<title>Edit Schedule</title></head>
		
		<script language="javascript">
			function getObject(obj) 
			{
				var theObj
				if (document.all) 
				{
					if (typeof obj == "string") 
					{
						return document.all(obj)
					} 
					else 
					{
						return obj.style		
					}
				}
				if (document.getElementById) 
				{
					if (typeof obj == "string") 
					{
						return document.getElementById(obj)
					} 
					else 
					{
						return obj.style
					}
				}
				return null
			}

			function validate()
			{
				var bool=true;
				var msg="Enter ";
				var j = document.forms[0].jname.value;
				for(var i=1; i<j; i++)
				{
					var k=document.getElementsByName(i);
					if(k[0].value.length==0)
					{
						msg+="Table Fields, ";
						bool=false;
						alert(msg);
						k[0].focus();
						return bool;
					}
				}
			}
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
				width:162px;
				height:131px;
				z-index:1;
			}
			#Layer2 {
				position:absolute;
				left:270px;
				top:20px;
				width:729px;
				height:161px;
				z-index:2;
			}
			#Layer3 {
				position:absolute;
				left:60px;
				top:207px;
				width:924px;
				height:28px;
				z-index:3;
			}
			.style3 {font-size: 14px;
				font-weight: bold;
			}
			.style4 {font-size: 14px}
		-->
		</style>
	</head>
	
	<body onLoad="fillYears();">
		
		<div id="Layer1"><img src="../../online/images/BITLogo.jpg" alt="logo" width="184" height="159"></div>
		
		<div id="Layer2">
			<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0" width="727" height="160" title="movie">
				<param name="movie" value="../../online/images/mov.swf">
				<param name="quality" value="high">
					<embed src="../../online/images/mov.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="727" height="160"></embed>
			</object>
		</div>
		
		<div id="Layer3">
			<table width="70%" border="0" align="left">
				<tr>
					<td width="106"><div align="right"><strong><span class="style4"><a href="../online/admin.html">Admin Home </a></span></strong></div></td>
					<td width="129"><div align="right" class="style3"><a href="../online/student_index.html">Student Home </a></div></td>
					<td width="110"><div align="right" class="style3"><a href="../online/staff_index.html">Staff Home </a></div></td>
					<td width="135"><div align="right" class="style3"><a href="../online/schedule_index.html">Schedule Home </a></div></td>
					<td width="188"><div align="right" class="style3"><a href="../online/ques_upload.jsp">Question Paper upload </a></div></td>
					<td width="80"><div align="right" class="style3"><a href="JavaScript:location.replace('login.jsp')" onClick="<% session.setAttribute("ses_usr_name",null);session.setAttribute("ses_passwd",null);%>"><strong>Logout</strong></a></div></td>
				</tr>
			</table>
		</div>
		
		<p>&nbsp;</p>
		<p>&nbsp;</p>
		<p>&nbsp;</p>
		<p>&nbsp;</p>
		<p>&nbsp;</p>
		<p>&nbsp;</p>
	
		<table width="45%" align="center">
			<tr>
				<td>	
					<fieldset><legend> Exam_Schedule Editor</legend>
						<form method="post" action="">
							<input type="hidden" name="jname">
								<table>
									<tr>
										<td>Batch: &nbsp <select name="bat"></select></td>
										<td>&nbsp&nbspDegree: &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp <select name="deg"><option value="UG">UG<option value="PG">PG</td>
									</tr> 
									<tr>
										<td>Dept: &nbsp&nbsp <select name="dept"><option value="CSE"> CSE </option><option value="IT"> IT </option></td>
										<td>&nbsp&nbspYear: &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp <select name="year"><option value="1"> 1 &nbsp &nbsp &nbsp</option><option value="2"> 2 </option><option value="3"> 3 </option><option value="4"> 4 </option></td>
									</tr>
									<tr>
										<td>Sem: &nbsp&nbsp&nbsp <select name="sem"><option value="1"> 1 </option><option value="2"> 2<option value="3"> 3  </option></td>
										<td>&nbsp&nbspExam Type: &nbsp <select name="examtype"><option value="P1">Periodicals 1<option value="P2">Periodicals 2<option value="P3">Periodicals 3<option value="M1">Model Exam<option value="UNIV">UNIVER. Exam</td>
									</tr>
									<tr> <td>&nbsp</td></tr>
									<tr>
										<td colspan="3" align="center"><input type="submit" name="load" value="Load" action=""></td>
									</tr>

									<%
										if(request.getParameter("load")!=null)
										{
											%>
												<tr> <td></td></tr>
												<tr> <td>&nbsp<font color=red>* Please maintain Date Format</font></td></tr>
												<tr><th>exam_date</th><th>sub_code</th><th>sub_name</th></tr>				    
												<TBODY ID="tableBody" align="center"></TBODY>
												<%
													String date,sem,dept,year,Deg,ex_type;
													date = request.getParameter("bat");
													Deg = request.getParameter("deg");
													sem = request.getParameter("sem");
													dept = request.getParameter("dept");
													year = request.getParameter("year");
													ex_type = request.getParameter("examtype");
													String db = date+Deg+dept+year+sem+ex_type;
													int k=0;
													Connection conn=null;
				
													try
													{
														Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
														conn = DriverManager.getConnection("jdbc:odbc:dsn","system","cutee");
						
														Statement st = conn.createStatement();
														String table = "select * from tab";
														ResultSet rs = st.executeQuery(table);
														String tem = "SCHEDULE_"+db;
														int flag = 0;
														while(rs.next())
														{
															if(rs.getString("tname").equals(tem))
															{
																flag = 1;
																table = "select * from SCHEDULE_" + db;
																rs = st.executeQuery(table);
																while(rs.next())
																{
																	k++;
																}	
																%>
																	<script language="javascript"> 
																	var today = new Date()
																	var thisYear = today.getFullYear()
																	var diff = thisYear - 2009;
																	fillYears() 
																	for(i=0;i<=diff;i++)
																	{
																		if(document.forms[0].bat.options[i].text == <%=date%>)
																			document.forms[0].bat.options[i].selected=true;
																	}	  	

																	for(i=0;i<4;i++)
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
																	var degree = "<%=Deg%>";
																	for(i=0;i<2;i++)
																	{		
																		if(document.forms[0].deg.options[i].text == degree)
																		document.forms[0].deg.options[i].selected=true;
																	}  
																	de = "<%=ex_type%>";
																	for(i=0;i<5;i++)
																	{		
																		if(document.forms[0].examtype.options[i].value == de)
																		document.forms[0].examtype.options[i].selected=true;
																	}  
			
																	var dayCounter = 1, j=1
																	var TBody = getObject("tableBody")
																	while (TBody.rows.length > 0) 
																	{
																		TBody.deleteRow(0)
																	}
																	var newR, newC
																	var done=false
																	while (!done) 
																	{
																		newR = TBody.insertRow(TBody.rows.length)
																		for (var i = 0; i < 4; i++) 
																		{
																			newC = newR.insertCell(newR.cells.length)
																			if (dayCounter == <%=k%>) 
																			{
																				done = true
																			}
																			if(i == 3)
																				newC.innerHTML = '<input type="checkbox" name='+j+' value='+j+'>'
																			else
																				newC.innerHTML = '<input type="text" name='+j+'>'
																			j++;
																		}
																		dayCounter++;
																	}
																	document.forms[0].jname.value=j
																</script>
																<tr> <td>&nbsp</td></tr>
																<tr><td colspan=3 align="center"><input type="submit" name="update" value="Update" onClick="return validate();">&nbsp&nbsp&nbsp&nbsp<input type="submit" name="delete1" value="Delete Particular"></td></tr>
																<tr> <td>&nbsp</td></tr>
																<tr><td colspan=3 align="center"><input type="submit" name="delete" value="Delete Entire Schedule"></td></tr>
																<%	
																	rs = st.executeQuery(table);
																	int b = 1;
																	while(rs.next())
																	{
																		String e_date = rs.getString("exam_date");
																		String s_code = rs.getString("sub_code");
																		String s_name=rs.getString("sub_name");		
																		%>
																			<script language="javascript">
																				var b = <%=b%>
																				var k1;
																				k1 = document.getElementsByName(b);
																				k1[0].value = "<%=e_date%>"
																				b++;
																				k1 = document.getElementsByName(b);
																				k1[0].value = "<%=s_code%>"
																				b++;	
																				k1 = document.getElementsByName(b);
																				k1[0].value = "<%=s_name%>"
																			</script>
																		<%	
																		b = b+4; 
																	}	

															}
														}				
														if(flag==0)
															%> <script> alert("Record Not found") </script> <%
														rs.close();
														conn.close();
													}                  
													catch (SQLException ex) 
													{
														out.println("SQLException: " + ex.getMessage());
														out.println("SQLState: " + ex.getSQLState());
														out.println("VendorError: " + ex.getErrorCode());
													}  
										} 
										else if(request.getParameter("update")!=null)
										{
											String date,sem,dept,year,degree,ex_type;
											int jname;
											date = request.getParameter("bat");
											degree = request.getParameter("deg");
											sem = request.getParameter("sem");
											dept = request.getParameter("dept");
											year = request.getParameter("year");
											ex_type = request.getParameter("examtype");
											jname=Integer.parseInt(request.getParameter("jname"));
											String db = date+degree+dept+year+sem+ex_type;
											Connection conn=null;
				
											try
											{
												Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
												conn = DriverManager.getConnection("jdbc:odbc:dsn","system","cutee");
												Statement st = conn.createStatement();
												ResultSet rs = null;
												PreparedStatement sch = null;
												String data;
												String table = "select * from tab";
												rs=st.executeQuery(table);
												int flag =0;
												String tem = "SCHEDULE_"+db;
												while(rs.next())
												{
													if(rs.getString("tname").equals(tem))
													{
														flag = 1;
														String s_code="";
														String table1= "drop table SCHEDULE_" + db;
														st.executeUpdate(table1);
														table1= "drop table RESULT_" + db;
														st.executeUpdate(table1);
														table = "CREATE TABLE SCHEDULE_" + db + "(exam_date varchar(20),sub_code varchar(10),sub_name varchar(50),noq varchar(5),time varchar(5), primary key(sub_code))";
														st.executeUpdate(table);
														table = "CREATE TABLE RESULT_" + db + "(roll varchar(20), name varchar(50), primary key(roll))";
														st.executeUpdate(table);
				
														for(int i=1; i <jname ;)
														{
															String s_date = request.getParameter(Integer.toString(i));
															i++;
															s_code = request.getParameter(Integer.toString(i));
															i++;
															String s_name = request.getParameter(Integer.toString(i));
															i=i+2;
															data = "insert into SCHEDULE_"+ db +"(exam_date,sub_code,sub_name) values('"+s_date+"','"+s_code+"','"+s_name+"')";
															st.executeUpdate(data);
															data = "alter table RESULT_" + db + " add " +s_code+ " varchar(5)";
															st.executeUpdate(data);
														}	
														sch = conn.prepareStatement("select * from student where dept=? and year=?");
														sch.setString(1,dept);
														sch.setString(2,year);
														rs=sch.executeQuery();
														while(rs.next())
														{
															data = "insert into RESULT_"+ db +" (roll,name) values('"+rs.getString("id")+"','"+rs.getString("name")+"')";
															st.executeUpdate(data);
														}
														for(int i=2; i < jname; i=i+4)
														{
															s_code = request.getParameter(Integer.toString(i));
															data = "update RESULT_"+ db +" set "+s_code+"='nil'";
															st.executeUpdate(data);
														}
														%>
															<script language="JavaScript" type="text/javascript">alert("Schedule Updated");</script>
														<%
													}
												}	
												if(flag == 0)
													%> <script> alert("Schedule has not been created yet.. Please create it first !") </script> <%
												rs.close();
												sch.close();
												conn.close();
											}
											catch (SQLException ex) 
											{
												out.println("SQLException: " + ex.getMessage());
												out.println("SQLState: " + ex.getSQLState());
												out.println("VendorError: " + ex.getErrorCode());
											}  
										} 
										else if(request.getParameter("delete")!=null)
										{
											String date,sem,dept,year,degree,ex_type;
											date = request.getParameter("bat");
											degree = request.getParameter("deg");
											sem = request.getParameter("sem");
											dept = request.getParameter("dept");
											year = request.getParameter("year");
											ex_type = request.getParameter("examtype");
		
											String db = date+degree+dept+year+sem+ex_type;
											Connection conn=null;
				
											try
											{
												Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
												conn = DriverManager.getConnection("jdbc:odbc:dsn","system","cutee");
												Statement st = conn.createStatement();
												ResultSet rs = null;
												PreparedStatement sch = null;
												String table = "select * from tab";
												rs=st.executeQuery(table);
												int flag =0;
												String tem = "SCHEDULE_"+db;
												while(rs.next())
												{
													if(rs.getString("tname").equals(tem))
													{
														flag = 1;
														String table1= "drop table SCHEDULE_" + db;
														st.executeUpdate(table1);	
														table1= "drop table RESULT_" + db;
														st.executeUpdate(table1);
														%>
															<script language="JavaScript" type="text/javascript">alert("Schedule Deleted");</script>
														<%
														break;
													}
												}
												if(flag == 0)
													%> <script> alert("Schedule has not been created yet.. Please create it first !") </script> <%
												rs.close();
												sch.close();
												conn.close();
											}
											catch (SQLException ex) 
											{
												out.println("SQLException: " + ex.getMessage());
												out.println("SQLState: " + ex.getSQLState());
												out.println("VendorError: " + ex.getErrorCode());
											}  
										}
										else if(request.getParameter("delete1")!=null)
										{
											String date,sem,dept,year,degree,ex_type;
											date = request.getParameter("bat");
											degree = request.getParameter("deg");
											sem = request.getParameter("sem");
											dept = request.getParameter("dept");
											year = request.getParameter("year");
											ex_type = request.getParameter("examtype");
	
											String db = date+degree+dept+year+sem+ex_type;
											Connection conn=null;
	
											try
											{
												Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
												conn = DriverManager.getConnection("jdbc:odbc:dsn","system","cutee");
												Statement st = conn.createStatement();
												ResultSet rs = null;
												PreparedStatement sch = null;
												String table = "select * from tab";
												rs=st.executeQuery(table);
												int flag =0;
												String tem = "SCHEDULE_"+db;
												while(rs.next())
												{
													if(rs.getString("tname").equals(tem))
													{
														flag = 1;
														int jname=Integer.parseInt(request.getParameter("jname"));
														String check;
														for(int i=1; i<jname;)
														{
															if(i%4 == 0)
															{
																check = request.getParameter(Integer.toString(i));
																if(check != null)
																{
																	String s_code = request.getParameter(Integer.toString(i-2));
																	sch = conn.prepareStatement("delete from " +tem+ " where sub_code=?");
																	sch.setString(1,s_code);
																	sch.executeUpdate();
																	sch = conn.prepareStatement("delete from RESULT_" +db);
																	sch.executeUpdate();
																	String data = "alter table RESULT_" + db + " drop column " +s_code;
																	st.executeUpdate(data);
																	sch = conn.prepareStatement("select * from student where dept=? and year=?");
																	sch.setString(1,dept);
																	sch.setString(2,year);
																	rs=sch.executeQuery();
																	while(rs.next())
																	{
																		data = "insert into RESULT_"+ db +" (roll,name) values('"+rs.getString("id")+"','"+rs.getString("name")+"')";
																		st.executeUpdate(data);
																	}
																}
															}
															i++;
														}
														jname=Integer.parseInt(request.getParameter("jname"));
														for(int i=1; i<jname;)
														{
															if(i%4 == 0)
															{
																check = request.getParameter(Integer.toString(i));
																if(check == null)
																{
																	String s_code = request.getParameter(Integer.toString(i-2));
																	String data = "update RESULT_"+ db +" set "+s_code+"='nil'";
																	st.executeUpdate(data);
																}
															}
															i++;
														}
															%> <script> alert("Schedule Updated !") </script> <%
													}
												}
												if(flag == 0)
													%> <script> alert("Schedule has not been created yet.. Please create it first !") </script> <%
												rs.close();
												sch.close();
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
					</fieldset>
				</td>
			</tr>
		</table>
	</body>
</html>