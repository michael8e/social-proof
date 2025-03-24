<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="quiz.Database"%>
<%@ page import="java.util.*"%>
<%@ page import="quiz.Constants"%>
<%@ page import="quiz.TimeFormat"%>
<%@ page import="quiz.User"%>

<jsp:include page="<%=Constants.HEADER_FILE%>">
	<jsp:param value="History" name="title" />
</jsp:include>

<%
	// make sure the user is signed in 
	User user = (User) session.getAttribute("user");
	if(user == null){
		String redirectURL = "login.jsp";
		response.sendRedirect(redirectURL);
	}

	// establish a connection
	Connection con = null;
	Statement statement = null;
	try {
		con = Database.openConnection();
		statement = Database.getStatement(con);
	} catch (SQLException e) {
		e.printStackTrace();
		return;
	}

	
	Object o = session.getAttribute("user");

	if(o != null){
		
		user = (User) session.getAttribute("user");
		Integer uID = user.getID();

		if (uID == null) return;
		String query = "Select zID, score, possible, time, timeTaken from scores where uID=" + uID + " order by time DESC;";
		con = Database.openConnection();
		Statement s = Database.getStatement(con);

		Vector<Integer> zIDs = new Vector<Integer>();
		Vector<Integer> scores = new Vector<Integer>();
		Vector<Integer> possible = new Vector<Integer>();
		Vector<String> quizNames = new Vector<String>();
		Vector<Timestamp> scoreTimes = new Vector<Timestamp>();
		Vector<Long> timeTaken = new Vector<Long>();

		ResultSet rs = s.executeQuery(query);
		while (rs.next()) {
			zIDs.add(rs.getInt("zID"));
			scores.add(rs.getInt("score"));
			possible.add(rs.getInt("possible"));
			scoreTimes.add(rs.getTimestamp("time"));
			timeTaken.add(rs.getLong("timeTaken"));
		}
	
		for(int i=0; i<zIDs.size(); i++){
			query = "Select name from quizzes where zID=" + zIDs.get(i) + ";";
			rs = s.executeQuery(query);
			rs.next();
			quizNames.add(rs.getString("name"));
		}
%>

	<h4>Scores Summary Page</h4>
	
	<table class="border">
			<tr class="border">
				<td class="wider, border"><b>Quiz Name</b></td>
				<td class="wider, border"><b>Score</b></td>
				<td class="wider, border"><b>Total</b></td>
				<td class="wider, border"><b>Time</b></td>
				<td class="wider, border"><b>TimeTaken</b></td>
			</tr>
			<%
				for (int i = 0; i < zIDs.size(); i++) {
			%>
			<tr class="border">
				<td class="border"><a href="QuizIntro?num=<%=zIDs.get(i)%>"><%=quizNames.get(i)%></a></td>
				<td class="border"><%=scores.get(i)%></td>
				<td class="border"><%=possible.get(i)%></td>
				<td class="border"><%=scoreTimes.get(i)%></td>
				<td class="border"><%=((double)timeTaken.get(i))/1000%></td>
			</tr>
			<%
				}
			%>
	</table>
<%}else{%>
	<h4>Your Recent Scores</h4>
	<p><a href="login.jsp">Login</a></p>
<%}

	Database.closeConnections(con, statement);
%>



<jsp:include page="<%=Constants.FOOTER_FILE%>"></jsp:include>




