<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.Date,java.text.*,java.sql.*,java.sql.SQLException,java.sql.DriverManager,javax.sql.DataSource" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@ page import="java.io.*" %>

<html>
	<head>
		
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		
		<title> StaffHome </title>
		
		<script type="text/javascript">
			function fillYears() 
			{
				var today = new Date()
				var thisYear = today.getFullYear()
				var yearChooser = document.forms[0].chooseYear
				for (i = 2009; i <= thisYear; i++) {
					yearChooser.options[yearChooser.options.length] = new Option(i, i)
				}
			}
		</script>
	</head>
	
	<body onLoad="fillYears();">
		<fieldset>
			<legend class="style1">Generate student report</legend>
			<form name="frm" id="frm" method="post">
	  	  	<table>
				<tr>
					<td>Batch:&nbsp<SELECT NAME="chooseYear"></SELECT></td>
					<td>&nbspDegree:&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<select name="deg"><option value="UG">UG<option value="PG">PG</td>
				</tr>
	                       	<tr>
					<td>Dept:&nbsp&nbsp<select name="dept"><option value="CSE"> CSE &nbsp &nbsp</option><option value="IT"> IT </option></td>
					<td>&nbspYear:&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<select name="year"><option value="1"> 1 &nbsp &nbsp</option><option value="2"> 2 </option><option value="3"> 3 </option><option value="4"> 4 </option></td>
				</tr> 
				<tr>
					<td>Sem:&nbsp&nbsp&nbsp<select name="sem"><option value="1"> 1 </option><option value="2">2<option value="3"> 3 </option></td>
					<td>&nbspExam Type:&nbsp<select name="examtype"><option value="P1">Periodicals1<option value="P2">Periodicals2<option value="P3">Periodicals3<option value="M1">Model Exam<option value="UNIV">UNIVERSITY EXAM</td>
					<td>&nbsp&nbsp&nbsp<input type="submit" name="get_subcode" Value="Submit"></td>
				</tr>
		<%
			if(request.getParameter("get_subcode")!=null)
			{
				%>
			       		<tr>
					        <td>Subject_Code:&nbsp<select name="sub_code"> 
				<%
				int count=0,flag=0;
				String batch,deg,dept,year,sem,ex_type,temp;
				batch = request.getParameter("chooseYear");
				deg = request.getParameter("deg");
				dept = request.getParameter("dept");
				year = request.getParameter("year");
				sem = request.getParameter("sem");
				ex_type = request.getParameter("examtype");
				Connection conn=null;
				
	
					%>
												<script language="JavaScript">
																	var today = new Date()
																	var thisYear = today.getFullYear()
																	var diff = thisYear - 2009;
																	fillYears() 
																	for(i=0;i<=diff;i++)
																	{
																		if(document.forms[0].chooseYear.options[i].text == <%=batch%>)
																			document.forms[0].chooseYear.options[i].selected=true;
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
												de = "<%=ex_type%>";
												for(i=0;i<5;i++)
												{
													if(document.forms[0].examtype.options[i].value == de)
														document.forms[0].examtype.options[i].selected=true;
												}
												de = "<%=deg%>";
												for(i=0;i<2;i++)
												{
													if(document.forms[0].deg.options[i].text == de)
														document.forms[0].deg.options[i].selected=true;
												}
											</script>
					<%
						try
						{
						        Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
					                conn = DriverManager.getConnection("jdbc:odbc:dsn","system","cutee");
							PreparedStatement stu = null;
							ResultSet rs=null,rs1=null;
	
						temp = batch+deg+dept+year+sem+ex_type;
						String t = "SCHEDULE_"+temp;

				  	        stu = conn.prepareStatement("select * from tab");
			        		rs=stu.executeQuery();
					        while(rs.next())
			            		{
							if(rs.getString("tname").equals(t))
							{
								flag=1;
								        Statement st = conn.createStatement();
								        String table = "select * from SCHEDULE_" + temp;
								        rs1 = st.executeQuery(table);
				
									while(rs1.next())
									{
										count++;
										String sub = rs1.getString("sub_code");
										session.setAttribute("ses_sub"+Integer.toString(count),sub);
										%> <option> <%=sub%> </option> <%
									} %> <option> ALL </option></td><td>&nbsp&nbsp&nbsp<input type="submit" name="get_result" Value="Load"></td></tr><script language="javascript">document.forms[0].get_subcode.hidden="true"</script> <%
									session.setAttribute("ses_count",Integer.toString(count));
							}
						}
						if(flag==0)
							%> <script> alert("Schedule has not been created") </script> <%
						rs.close();
						rs1.close();
						stu.close();
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
		<br /><hr /><br /><br />
		<%
			if(request.getParameter("get_result")!=null)
			{
				String batch,deg,dept,year,sem,ex_type,temp,sub_code;
				batch = request.getParameter("chooseYear");
				deg = request.getParameter("deg");
				dept = request.getParameter("dept");
				year = request.getParameter("year");
				sem = request.getParameter("sem");
				ex_type = request.getParameter("examtype");
				sub_code = request.getParameter("sub_code");
				
				java.util.Date dote = new java.util.Date();
				String filename="";

				HSSFWorkbook hwb = new HSSFWorkbook();
				HSSFSheet sheet = hwb.createSheet("new sheet");
				
				HSSFRow rowhead = sheet.createRow((short)2);
				rowhead.createCell((short) 1).setCellValue("Batch:");
				rowhead.createCell((short) 2).setCellValue(batch);

				rowhead = sheet.createRow((short)3);
				rowhead.createCell((short) 1).setCellValue("Degree:");
				rowhead.createCell((short) 2).setCellValue(deg);

				rowhead = sheet.createRow((short)4);
				rowhead.createCell((short) 1).setCellValue("Dept:");
				rowhead.createCell((short) 2).setCellValue(dept);

				rowhead = sheet.createRow((short)5);
				rowhead.createCell((short) 1).setCellValue("Year:");
				rowhead.createCell((short) 2).setCellValue(year);

				rowhead = sheet.createRow((short)6);
				rowhead.createCell((short) 1).setCellValue("Sem:");
				rowhead.createCell((short) 2).setCellValue(sem);

				rowhead = sheet.createRow((short)7);
				rowhead.createCell((short) 1).setCellValue("Exam Type:");
				rowhead.createCell((short) 2).setCellValue(ex_type);

				rowhead = sheet.createRow((short)10);
				rowhead.createCell((short) 1).setCellValue("Roll No");
				rowhead.createCell((short) 2).setCellValue("Name");
				int index=11;

       				temp = "RESULT_"+batch+deg+dept+year+sem+ex_type;
				
				%>
												<script language="JavaScript">
																	var today = new Date()
																	var thisYear = today.getFullYear()
																	var diff = thisYear - 2009;
																	fillYears() 
																	for(i=0;i<=diff;i++)
																	{
																		if(document.forms[0].chooseYear.options[i].text == <%=batch%>)
																			document.forms[0].chooseYear.options[i].selected=true;
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
												de = "<%=ex_type%>";
												for(i=0;i<5;i++)
												{
													if(document.forms[0].examtype.options[i].value == de)
														document.forms[0].examtype.options[i].selected=true;
												}
												de = "<%=deg%>";
												for(i=0;i<2;i++)
												{
													if(document.forms[0].deg.options[i].text == de)
														document.forms[0].deg.options[i].selected=true;
												}
											</script>
				<%

				Connection conn=null;
			        try
			        {
				        Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
			                conn = DriverManager.getConnection("jdbc:odbc:dsn","system","cutee");
		                    
				        Statement st = conn.createStatement();
					if(sub_code.equals("ALL"))
					{
						filename = "e:\\"+batch+deg+dept+year+sem+ex_type+"_ALL.xls" ;
						String cout=(String) session.getAttribute("ses_count");
						int nos_count = Integer.parseInt(cout);
					        String table = "select * from " + temp;
					        ResultSet rs = st.executeQuery(table);
						%>
						<div align="center">
							<table border=1 width="80%">
								<caption> <strong> Results </strong> </caption>
								<thead>
									<tr>
										<th> Roll No </th>
										<th> Name </th>
										<%
											for(int i=1;i<=nos_count;i++)
											{
												int c = i+2;
												rowhead.createCell((short) c).setCellValue((String) session.getAttribute("ses_sub"+Integer.toString(i)));
												%><th> <%=(String) session.getAttribute("ses_sub"+Integer.toString(i))%> </th> <%
											}
										%>
									</tr>
								</thead>
								<tbody>
					        <%

					        rs = st.executeQuery(table);
						while(rs.next())
						{
							String rolln = rs.getString("roll");
							String nam = rs.getString("name");
							HSSFRow row = sheet.createRow((short)index);
							row.createCell((short) 1).setCellValue(rolln);
							row.createCell((short) 2).setCellValue(nam);
								%> <tr>
								<td> <%=rolln %></td>
								<td> <%=nam%> </td>
								<%for(int i=1;i<=nos_count;i++)
								{
									int c = i+2;
									String subject = rs.getString((String) session.getAttribute("ses_sub"+Integer.toString(i)));
									row.createCell((short) c).setCellValue(subject);
									%><td> <%=subject%> </td><%
								}
							%> </tr> <%
							index++;
						} 
						%> 
						</tbody>
						</table>
						</div>
						rs.close();
						<%
					}	
					else
					{
						filename = "e:\\"+batch+deg+dept+year+sem+ex_type+"_"+sub_code+".xls" ;
					        String table = "select roll,name,"+sub_code+ " from " + temp;
					        ResultSet rs = st.executeQuery(table);
						rowhead.createCell((short) 3).setCellValue(sub_code);
					
						%>
						<div align="center">
							<table border=1 width="80%">
								<caption> <strong> Results </strong> </caption>
								<thead>
									<tr>
										<th> Roll No </th>
										<th> Name </th>
										<th> <%=sub_code%> </th>
									</tr>
								</thead>
								<tbody>
					        <%
						rs = st.executeQuery(table);
						while(rs.next())
						{
							String rolln = rs.getString("roll");
							String nam = rs.getString("name");
							String subject = rs.getString(sub_code);
							HSSFRow row = sheet.createRow((short)index);
							row.createCell((short) 1).setCellValue(rolln);
							row.createCell((short) 2).setCellValue(nam);
							row.createCell((short) 3).setCellValue(subject);
							%> <tr>
								<td> <%=rolln%> </td>
								<td> <%=nam%> </td>
								<td> <%=subject%> </td>
							</tr> <%
							index++;
						} 
						%> 
						</tbody>
						</table>
						</div>
						<%
						rs.close();
					}
					st.close();
					conn.close();
				}
			        catch (SQLException ex) 
			        {
			        	out.println("SQLException: " + ex.getMessage());
			                out.println("SQLState: " + ex.getSQLState());
			                out.println("VendorError: " + ex.getErrorCode());
			        }  
				
				FileOutputStream fileOut = new FileOutputStream(filename);
				hwb.write(fileOut);
				fileOut.close();	
			}
		%>
	</body>
</html>
