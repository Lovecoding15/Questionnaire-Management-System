<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.Date,java.text.*,java.sql.*,java.sql.SQLException,java.sql.DriverManager,javax.sql.DataSource" %>

<html>
	<head>
		
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<title> Exam Page </title>
		
	</head>
	<%
		String ex_type = request.getParameter("ex_type");
		session.setAttribute("ses_ex_type",ex_type);
	%>
	
	<FRAMESET ROWS="150,*">
		<FRAME scrolling=no NAME="Ad" SRC="ad.html">
		<FRAMESET COLS="20%,*,20%">
			<FRAME scrolling=no name="display" SRC="display.html">
			<FRAME NAME="Content" SRC="exam.jsp">
			<FRAME scrolling=no name="timer" SRC="timer.html">
		</FRAMESET>
	</FRAMESET>
</html>