<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="quiz.Database"%>
<%@ page import="quiz.Constants"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Welcome</title>
</head>

<style>
.needBorder {
	border: 1px solid black;
	border-collapse: collapse;
}

.wider {
	width: 70px;
}
</style>

<jsp:include page="<%=Constants.HEADER_FILE%>" />

<%
	Integer uID = (Integer) session.getAttribute("uID");
	if (uID == null) return;
	String query = "Select zID, score, possible from scores where zID=" + uID + ";";
	Connection con = Database.openConnection();
	Statement s = Database.getStatement(con);

	Vector<Integer> zIDs = new Vector<Integer>();
	Vector<Integer> scores = new Vector<Integer>();
	Vector<Integer> possible = new Vector<Integer>();

	ResultSet rs = s.executeQuery(query);
	while (rs.next()) {
		zIDs.add(rs.getInt("zID"));
		scores.add(rs.getInt("score"));
		possible.add(rs.getInt("possible"));
	}
%>
<body>
	<%
		String message = (String) getServletContext().getAttribute("error");
		if (message != null) {
	%>
	<p>
		<%=message%>
	</p>
	<%
		}
	%>
	<p>
		Hi,
		<%=getServletContext().getAttribute("userName")%>!
	</p>

	<table>
		<tr>
			<td>uID: <%=getServletContext().getAttribute("uID")%></td>
			<td><a href="AdminBegin">Admin Page</a></td>
			<td><a href="index.jsp">Quizzes</a></td>
		</tr>
	</table>

	<br>
	<table class="needBorder">
		<tr class="needBorder">
			<td colspan="3"><b>Score History</b></td>
		</tr>
		<tr>
			<td class="wider">Quiz ID</td>
			<td class="wider">Score</td>
			<td class="wider">Total</td>
		</tr>
		<%
			for (int i = 0; i < zIDs.size(); i++) {
		%>
		<tr>
			<td><%=zIDs.get(i)%></td>
			<td><%=scores.get(i)%></td>
			<td><%=possible.get(i)%></td>
		</tr>
		<%
			}
		%>

	</table>
</body>
</html>