<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.Date,java.text.*,java.sql.*,java.sql.SQLException,java.sql.DriverManager,javax.sql.DataSource" %>

<html>
	<head>
		
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		
		<title> Exam Page </title>
		
		<SCRIPT LANGUAGE="JavaScript">

			function click(e) 
			{
                oncontextmenu='return false';
            }
            document.onmousedown=click;          
                          
            function handleKeyDown() 
			{
                event.keyCode=0;
                event.returnValue=false;   
            }
            document.onkeydown = handleKeyDown;             
        </SCRIPT>
	</head>
	
	<%
		String user_name=(String) session.getAttribute("ses_usr_name");
		String pass_word=(String) session.getAttribute("ses_passwd");
		String ex_type=(String) session.getAttribute("ses_ex_type");
		boolean pass = true;
		String date,y,deg="",dept="",year="",sem="",t,subject_code="",subject_name="",t1="",time="",marks="",t2="";
		int noq=0;
		int flag = 0,exists = 0,checked=0;	
		Date d = new Date();
		Format formatter;
		formatter = new SimpleDateFormat("dd-MMM-yy");
		date = formatter.format(d);
		formatter = new SimpleDateFormat("yyyy");
		y = formatter.format(d);
		PreparedStatement stu = null,sch = null, stmt=null,stmt1=null,res_stmt=null;
		ResultSet rs = null,rs1=null,rs2=null,rs3=null,res_rs=null;
		Connection conn=null;
	
        	try
        	{
	                Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
	            	conn = DriverManager.getConnection("jdbc:odbc:dsn","system","cutee");
		                      
			stu = conn.prepareStatement("select * from student where id=? and passwd=?");
			stu.setString(1,user_name);
		    	stu.setString(2,pass_word);
            		rs=stu.executeQuery();
		        if(rs.next())
	                {
				deg =rs.getString("degree");
				dept=rs.getString("dept");
				year=rs.getString("year");
				sem =rs.getString("sem");
        		}

			while(pass)
			{
			if(checked == 1)
				pass = false;

			t = "SCHEDULE_"+y+deg+dept+year+sem+ex_type;
			t2 = "RESULT_"+y+deg+dept+year+sem+ex_type;
		
	  	        stu = conn.prepareStatement("select * from tab");
        		rs=stu.executeQuery();
		        while(rs.next())
            		{
				if(rs.getString("tname").equals(t))
				{
					flag = 1;
					checked = 1;
					if(checked == 1)
						pass = false;

					sch = conn.prepareStatement("select * from "+t+" where exam_date=?");
				    	sch.setString(1,date);
				        rs1=sch.executeQuery();
			                if(rs1.next())
		                        {  
 						subject_code=rs1.getString(2);
						subject_name=rs1.getString(3);
						subject_code = subject_code.toUpperCase();
						marks = rs1.getString(4);
						noq = Integer.parseInt(marks);
						time = rs1.getString(5);
					        session.setAttribute("ses_sub_code",subject_code);
					        session.setAttribute("ses_noq",marks);
						%>
						<script type="text/javascript">
							top.frames['display'].document.dis.sem.value = "<%=sem%>"; 
							top.frames['display'].document.dis.date.value = "<%=date%>"; 
							top.frames['display'].document.dis.s_code.value = "<%=subject_code%>"; 
							top.frames['display'].document.dis.s_name.value = "<%=subject_name%>"; 
							top.frames['display'].document.dis.marks.value = "<%=marks%>"; 
							top.frames['timer'].document.max_time.time.value = "<%=time%>"; 
						</script>

						<%
						//question display
						t1 = "QUES_"+y+deg+dept+year+sem+ex_type;
						t1 = t1+subject_code;
					    	stmt = conn.prepareStatement("select * from tab");
			            		rs2=stmt.executeQuery();
					    	while(rs2.next())
					    	{
							if(rs2.getString("tname").equals(t1))
							{
							        exists = 1;
								res_stmt = conn.prepareStatement("select * from "+t2+" where roll=?");
								res_stmt.setString(1,user_name);
								res_rs=res_stmt.executeQuery();
								if(res_rs.next())
								{
									if(res_rs.getString(subject_code).equals("nil"))
									{	
									%>
										<body onload="init(),validateRadio()" oncontextmenu="return false" ondragstart="return false" onselectstart="return false">
										<form method="post">
									<%
		
									//random generation
									int a[] = new int[noq];
									int k=0;
									for(int i=0;i<noq;i++)
										a[i]=0;
									for(int i=1;k<noq;i++) 
									{
										int flag1 = 0;
										int temp = (int) (Math.random() * noq);
										for(int j=0; j<k; j++)
										{
											if(a[j]==temp)
											{
												flag1 = 1;
												break;						
											}
										}
										if(flag1==0)
										{
											a[k] = temp;
											k++;
										}
									}
									for(int i=1; i<=noq; i++)
									{
										session.setAttribute("ses_que"+Integer.toString(i),Integer.toString(a[i-1]));	
									}
		               				                try
						                        {	
					        	                	stmt1 = conn.prepareStatement("select * from "+t1);	
								    		for(int i=1;i<=noq;i++)
								    		{
											int flag2 = 0;
							         		        rs3=stmt1.executeQuery();
						                                        while(rs3.next() & flag2==0)
						        	                        {
												int tem = rs3.getInt("sno");
												if(tem==(a[i-1]+1))
												{
													String ans_temp = rs3.getString("ans");
											        	if(ans_temp.equals("A"))
														ans_temp = "c1";
													else if(ans_temp.equals("B"))
														ans_temp = "c2";
													else if(ans_temp.equals("C"))
														ans_temp = "c3";
													else
														ans_temp = "c4";
							 				   	        %> 
														<br /><div style="postion:absolute; background-color:pink">
 												        	<p> <font family="comic sans ms" color="teal" size="7"><%out.print(i+".  ");%> </font><font family="comic sans ms" size="4"> <%out.print(rs3.getString("ques"));%> </font> </p>	
											         		<input type="radio" name="q<%=i%>" value="c1" > <font family="comic sans ms" size="4"> <% out.println(rs3.getString("c1"));%></font> <br />
											         		<input type="radio" name="q<%=i%>" value="c2" > <font family="comic sans ms" size="4"><% out.println(rs3.getString("c2"));%></font> <br />
										                 		<input type="radio" name="q<%=i%>" value="c3" > <font family="comic sans ms" size="4"><% out.println(rs3.getString("c3"));%></font> <br />
												 		<input type="radio" name="q<%=i%>" value="c4" > <font family="comic sans ms" size="4"><% out.println(rs3.getString("c4"));%></font> <br />
												 		<input type="hidden" name="ans<%=i%>" value="<%=ans_temp%>" > <br /></div>
								      			    		<% 				
													flag2 = 1;
										    		}
					             	    				}
						            			}
							    		}
					            			catch (SQLException ex) 
						        		{
						            			out.println("SQLException1: " + ex.getMessage());
					        	    			out.println("SQLState: " + ex.getSQLState());
					                			out.println("VendorError: " + ex.getErrorCode());
					            			}
									%>   
										<br />
						 				<p align="center"> <input type="button" name="evaluate" value="Submit" onClick="return validRadio()" > </p>
									<%
									}
									else
						  				%> <P ALIGN="CENTER" style="position:absolute; left:500; top:100"> <h1> YOU WROTE THE EXAM ALREADY ! THANK U !! </h1> </P> <%						
								}
							}
				        	}
					    	if(exists == 0)
					  		%> <P ALIGN="CENTER" style="position:absolute; left:50; top:100"> <h1> QUESTION PAPER HAS NOT BEEN UPLOADED ! ! </h1> </P> <%
					}
		            		else
		            		{
						%> <P ALIGN="CENTER" style="position:absolute; left:50; top:100"> <h1> NO EXAMS TODAY ! </h1> </P> <%	                           
		            		}
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
			if(flag==0)
				%> <P ALIGN="CENTER" style="position:absolute; left:50; top:100"> <h1> EXAMS HAS NOT BEEN SCHEDULED FOR YOU.. TRY LATER ! </h1> </P> <%	                          			
			rs.close();
			rs1.close();
			rs2.close();
			rs3.close();
			res_rs.close();
			stu.close();
			sch.close();
			stmt.close();
			stmt1.close();
			res_stmt.close();
			conn.close();
        	}
        	catch (SQLException ex) 
        	{
	        	out.println("SQLException: " + ex.getMessage());
            		out.println("SQLState: " + ex.getSQLState());
            		out.println("VendorError: " + ex.getErrorCode());
        	}   
	%>
			        
	<script language="javascript">
		var mins
		var secs;
	
		function cd() 
		{
			mins = 1 * m("1"); 
			secs = 0 + s(":01"); 
			redo();
		}
	
		function m(obj) 
		{
			for(var i = 0; i < obj.length; i++) 
			{
				if(obj.substring(i, i + 1) == ":")
				break;
			}
			return(obj.substring(0, i));
		}
	
		function s(obj) 
		{
			for(var i = 0; i < obj.length; i++) 
			{
				if(obj.substring(i, i + 1) == ":")
				break;
			}
			return(obj.substring(i + 1, obj.length));
		}

		function dis(mins,secs) 
		{
			var disp;
			if(mins <= 9) 
				disp = " 0";
			else 
				disp = " ";
			disp += mins + ":";
			if(secs <= 9) 
				disp += "0" + secs;
			else 
				disp += secs;
			return(disp);
		}
		
		function redo() 
		{
			secs--;
			if(secs == -1) 
			{
				secs = 59;
				mins--;
			}
			top.frames['timer'].document.cd.disp.value = dis(mins,secs); 
			if((mins == 0) && (secs == 0)) 
				evaluateRadio(); 
			else 
				cd = setTimeout("redo()",1000);
		}
	
		function init() 
		{
			cd();
		}
	
		var q_ans,q_rem,i,j,bOneChecked,aRadios;
		function validateRadio()
		{ 
			q_ans=0,q_rem=0;
			for (i = 1; i <= <%=noq%>; i++)
			{
				bOneChecked = false;
				aRadios = document.getElementsByName('q' + i);
				for (j = 0; j < aRadios.length; j++) 
				{
					if (aRadios[j].checked) 
					{
						bOneChecked = true;
						q_ans = q_ans+1;
					}
				} 
				if (!bOneChecked) 
				{
					q_rem = q_rem+1;
				}
			}
			top.frames['timer'].document.ques.q_ans.value = q_ans; 
			top.frames['timer'].document.ques.q_rem.value = q_rem; 
			setTimeout("validateRadio()",500);
		}
	
		function validRadio()
		{ 
			var msg = "Answer : "
			var flagg = 0;
			for (var i = 1; i <= <%=noq%>; i++)
			{
				var bOneChecked = false;
				var aRadios = document.getElementsByName('q' + i);
				for (var j = 0; j < aRadios.length; j++) 
				{
					if (aRadios[j].checked) 
						bOneChecked = true;
				} 
				if (!bOneChecked) 
				{
					msg = msg + i +", ";
					flagg = 1;
				}
			}
			if(flagg == 1)
			{
				alert(msg)
				return false
			}
			else
				evaluateRadio()
		}

		function evaluateRadio()
		{
			var ans;
			var c=0;
			var i;
			var an = new Array();
			for (i = 1; i <= <%=noq%>; i++)
			{
				var aRadios = document.getElementsByName('q' + i);
				var k1=document.getElementsByName('ans' + i);
				var verify = 0;
				for (var j = 0; j < aRadios.length; j++) 
				{
					if(aRadios[j].checked)
					{
						an[i] = aRadios[j].value;
						verify = 1;
						if(aRadios[j].value == k1[0].value)
						{
							c++;
						}
					}
				}
				if(verify == 0)
					an[i] = "00";
			}
			var ref = "./result.jsp?&c="+c.toString()+"&an="
			for (i = 1; i <= <%=noq%>; i++)
			{
				ref = ref + an[i].toString()
			}
			document.location.href = ref;
		}
	</script>
	</form>
	</body>
</html>