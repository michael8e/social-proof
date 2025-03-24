<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="quiz.Constants"%>
<%@ page import="java.sql.*"%>
<%@ page import="quiz.Database"%>
<%@ page import="java.util.*"%>
<%@ page import="quiz.Constants"%>
<%@ page import="quiz.TimeFormat"%>
<%@ page import="quiz.User"%>
<jsp:include page="<%=Constants.HEADER_FILE%>">
	<jsp:param value="Home" name="title" />
</jsp:include>

<style>
input#input {
	width: 300px;
}
</style>


	<h1>Administrative Page</h1>
	<%
	Connection con = null;
	Statement statement = null;
	try {
		con = Database.openConnection();
		statement = Database.getStatement(con);
	} catch (SQLException e) {
		e.printStackTrace();
		return;
	}
	
	String queryUsers = "Select count(*) as count from users;";
	String queryTaken = "Select count(*) as count from scores;";
	int totalUsers = 0;
	int totalTaken = 0;

	try {
		ResultSet rs = statement.executeQuery(queryUsers);
		rs.next();
		totalUsers = rs.getInt("count");
		rs = statement.executeQuery(queryTaken);
		rs.next();
		totalTaken = rs.getInt("count");
	} catch (SQLException e) {
		e.printStackTrace();
		return;
	}
	
	%>
	<p><b>Site Statistics:</b>
		<br>&nbsp;&nbsp;Total Users: <b><%=totalUsers %></b>
		<br>&nbsp;&nbsp;Total Quiz Attempts: <b><%=totalTaken %></b>
	</p>
	
	<p>Add an announcement:</p>
	<form action="AdminAnnouncement" method="post">
		<input type="text" id="input" name="announcement"> <input
			type="submit" name="Post">
	</form>
	
	
	<%
	String query = "Select username, uID from users;";
	ResultSet rs = statement.executeQuery(query);
	Vector<String>names = new Vector<String>();
	Vector<Integer>uIDs = new Vector<Integer>();
	
	while(rs.next()){
		names.add(rs.getString("username"));
		uIDs.add(rs.getInt("uID"));
	}
	%>
	<p>Remove a user:</p>
	<form action="AdminUser" method="post">
		<select name="removeUser">
		<%for(int i=0; i<uIDs.size(); i++){ %>
 	 		<option value="<%=uIDs.get(i)%>"><%=names.get(i) %></option>
 	 	<%} %>
		</select>
		<input type="submit" name="Remove">
	</form>
	

	<%
	query = "Select uID, username from users";
	rs = statement.executeQuery(query);
	Vector<String> everyone = new Vector<String>();
	uIDs = new Vector<Integer>();
	while(rs.next()){
		everyone.add(rs.getString("username"));
		uIDs.add(rs.getInt("uID"));
	}
	%>
	
	<p>Add an administrator:</p>
	<form action="AdminNew" method="post">
		<select name="newAdmin">
		<%for(int i=0; i<everyone.size(); i++){ %>
 	 		<option value="<%=uIDs.get(i)%>"><%=everyone.get(i) %></option>
 	 	<%} %>
		</select>
		<input type="submit" name="Add">
	</form>
	
	<%
	
	query = "Select uID from administrators";
	rs = statement.executeQuery(query);
	uIDs = new Vector<Integer>();
	while(rs.next()){
		uIDs.add(rs.getInt("uID"));
	}
	
	names = new Vector<String>();
	for(int i=0; i<uIDs.size(); i++){
		int uID = uIDs.get(i);
		query = "Select username from users where uID=" + uID + ";";
		rs = statement.executeQuery(query);
		if(!rs.next()){
			names.add("Former User");
		}else{
			names.add(rs.getString("username"));
		}
		
	}
	%>
	
	<p>Remove an administrator:</p>
	<form action="AdminRemove" method="post">
		<select name="removeAdmin">
		<%for(int i=0; i<names.size(); i++){ %>
 	 		<option value="<%=uIDs.get(i)%>"><%=names.get(i) %></option>
 	 	<%} %>
		</select>
		<input type="submit" name="Remove">
	</form>	
	
	
	<%
	
	query = "Select name, zID from quizzes;";
	rs = statement.executeQuery(query);
	Vector<String>quizzes = new Vector<String>();
	Vector<Integer>zIDs = new Vector<Integer>();
	
	while(rs.next()){
		quizzes.add(rs.getString("name"));
		zIDs.add(rs.getInt("zID"));
	}
	
	%>
	
	<p>Remove quiz history:</p>
	<form action="AdminQuiz" method="post">
		<select name="removeQuiz">
		<%for(int i=0; i<zIDs.size(); i++){ %>
 	 		<option value="<%=zIDs.get(i)%>"><%=quizzes.get(i) %></option>
 	 	<%} %>
		</select>
		<input type="submit" name="Remove">
	</form>


<%
	query = "Select name, zID from quizzes;";
	rs = statement.executeQuery(query);
	quizzes = new Vector<String>();
	zIDs = new Vector<Integer>();
	
	while(rs.next()){
		quizzes.add(rs.getString("name"));
		zIDs.add(rs.getInt("zID"));
	}
	
	%>
	<p>Remove a quiz and all its components:</p>
	<form action="AdminEntireQuiz" method="post">
		<select name="removeQuiz">
		<%for(int i=0; i<zIDs.size(); i++){ %>
 	 		<option value="<%=zIDs.get(i)%>"><%=quizzes.get(i) %></option>
 	 	<%} %>
		</select>
		<input type="submit" name="Remove">
	</form>


	<% Database.closeConnections(con, statement, rs); %>

<jsp:include page="<%=Constants.FOOTER_FILE%>"></jsp:include>