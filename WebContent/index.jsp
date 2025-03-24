<%@page import="quiz.Announcement"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="quiz.*"%>
<%@ page import="java.util.*"%>

<jsp:include page="<%=Constants.HEADER_FILE%>">
	<jsp:param value="Home" name="title" />
</jsp:include>

<%
	User user = (User) session.getAttribute("user");
	if (user == null) {
		String redirectURL = "login.jsp";
		response.sendRedirect(redirectURL);
		return;
	}
%>

<div style="float: left; margin-left: 75px; margin-bottom: 100px;">
	<h1>Announcements</h1>
	<ol>
		<%
			ArrayList<Announcement> announcements = Announcement
					.getAnnouncements(5);
			for (int i = 0; i < announcements.size(); i++) {
				Announcement a = announcements.get(i);
		%>
		<li><%=a.getAnnouncementText() + " at " + a.getHumanTime()%></li>
		<%
			}
		%>
	</ol>

	<h1>Your Achievements</h1>
	<table class="border">
<tr><td class="border"><b>Your Achievements</b></td></tr>
	<%
	{
		Integer uID = user.getID();
	Connection con = Database.openConnection();
	Statement statement = Database.getStatement(con);
	ResultSet rs = null;
		if (uID != null) {
			String query = "Select name From achievements Where type = 0 AND uID="
					+ uID + ";";
			rs = statement.executeQuery(query);
			Vector<String> created = new Vector<String>();
			while (rs.next()) {
				created.add(rs.getString("name"));
			}
			int size = created.size();
			int AMATEUR_AUTHOR = 1;
			if (size >= AMATEUR_AUTHOR) {
				String title = "";
				for (int i = 0; i < AMATEUR_AUTHOR; i++) {
					title += created.get(i);
					if (i != AMATEUR_AUTHOR - 1)
						title += ", ";
				}
	%>
	<tr class="border">
		<td title="<%=title%>" class="pointer">Amateur Author</td>
	</tr>
	<%
		}
			int PROLIFIC_AUTHOR = 5;
			if (size >= PROLIFIC_AUTHOR) {
				String title = "";
				for (int i = 0; i < PROLIFIC_AUTHOR; i++) {
					title += created.get(i);
					if (i != PROLIFIC_AUTHOR - 1)
						title += ", ";
				}
	%>
	<tr class="border">
		<td title="<%=title%>" class="pointer">Prolific Author</td>
	</tr>
	<%
		}
	%>

	<%
		int PRODIGIOUS_AUTHOR = 10;
			if (size >= PRODIGIOUS_AUTHOR) {
				String title = "";
				for (int i = 0; i < PRODIGIOUS_AUTHOR; i++) {
					title += created.get(i);
					if (i != PRODIGIOUS_AUTHOR - 1)
						title += ", ";
				}
	%>
	<tr class="border">
		<td title="<%=title%>" class="pointer">Prodigious Author</td>
	</tr>
	<%
		}
	%>

	<%
		query = "Select name From achievements Where type = 1 AND uID="
					+ uID + ";";
			rs = statement.executeQuery(query);
			Vector<String> taken = new Vector<String>();
			while (rs.next()) {
				taken.add(rs.getString("name"));
			}
			size = taken.size();
			int QUIZ_MACHINE = 10;
			if (size >= QUIZ_MACHINE) {
				String title = "";
				for (int i = 0; i < QUIZ_MACHINE; i++) {
					title += taken.get(i);
					if (i != QUIZ_MACHINE - 1)
						title += ", ";
				}
	%>
	<tr class="border">
		<td title="<%=title%>" class="pointer">Quiz Machine</td>
	</tr>
	<%
		}
	%>

	<%
		user = (User) session.getAttribute("user");
		uID = user.getID();
		query = "Select name From achievements Where type = 2 AND uID=" + uID + ";";
		rs = statement.executeQuery(query);
	%>
	<%
		if (rs.next()) {
				String high = rs.getString("name");
	%>
	<tr class="border">
		<td title="<%=high%>" class="pointer">I am the Greatest</td>
	</tr>
	<%
		}
	%>

	<%
		// TO-DO: award this achievement when practice mode works
			// For achievements, finished all but this last step. Figured we'd find this while testing.
			query = "Select name From achievements Where type = 3 AND uID="
					+ uID + ";";
			rs = statement.executeQuery(query);
	%>
	<%
		if (rs.next()) {
				String practice = rs.getString("name");
	%>
	<tr class="border">
		<td title="<%=practice%>" class="pointer">Practice Makes Perfect</td>
	</tr>
	<%
		}}
	%>
</table>
<% } %>
	<h1>Your Recent Activities</h1>
	<p><a href="history.jsp">Scores Summary Page</a></p>
<%
{
		Integer uID = user.getID();
		if (uID == null) return;
		String query = "Select zID, score, possible, time, timeTaken from scores where uID=" + uID + " order by time DESC;";
		Vector<Integer> zIDs = new Vector<Integer>();
		Vector<Integer> scores = new Vector<Integer>();
		Vector<Integer> possible = new Vector<Integer>();
		Vector<String> quizNames = new Vector<String>();
		Vector<Timestamp> scoreTimes = new Vector<Timestamp>();
		Vector<Long> timeTaken = new Vector<Long>();
		Connection con = Database.openConnection();
		Statement statement = Database.getStatement(con);
		ResultSet rs = statement.executeQuery(query);
		while (rs.next()) {
			zIDs.add(rs.getInt("zID"));
			scores.add(rs.getInt("score"));
			possible.add(rs.getInt("possible"));
			scoreTimes.add(rs.getTimestamp("time"));
			timeTaken.add(rs.getLong("timeTaken"));
		}
	
		for(int i=0; i<zIDs.size(); i++){
			query = "Select name from quizzes where zID=" + zIDs.get(i) + ";";
			rs = statement.executeQuery(query);
			rs.next();
			quizNames.add(rs.getString("name"));
		}
%>
	<br>
	<table class="border">
			<tr class="border">
				<td class="wider, border"><b>Quiz Name</b></td>
				<td class="wider, border"><b>Score</b></td>
				<td class="wider, border"><b>Total</b></td>
				<td class="wider, border"><b>Time</b></td>
				<td class="wider, border"><b>TimeTaken</b></td>
			</tr>
			<%
				int max = zIDs.size() > 6 ? 6 : zIDs.size();
				for (int i = 0; i < max; i++) {
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

	<h1>Your Friends' Recent Activities</h1>
	<%
}
// YOUR FRIENDS' SCORES
Vector<Integer> frienduIDs = new Vector<Integer>();
Vector<String> friendNames = new Vector<String>();
Vector<Integer> friendScores = new Vector<Integer>();
Vector<Integer> friendPossible = new Vector<Integer>();
Vector<Double> friendTimes = new Vector<Double>();
Vector<Timestamp> friendDates = new Vector<Timestamp>();
Vector<Integer> friends = new Vector<Integer>();
Vector<Integer> friendzIDs = new Vector<Integer>();
Vector<String> friendQNames = new Vector<String>();
Object a = session.getAttribute("user");
if(a != null){
int uID = ((User)a).getID();
// get all of friends uIDs
String friendQuery = "Select * from friendships where uID=" + uID + ";";
Connection con = Database.openConnection();
Statement statement = Database.getStatement(con);
ResultSet r = statement.executeQuery(friendQuery);
ResultSet rs = null;
while(r.next()){
	friends.add(r.getInt("friendID"));
}

// query for friend's scores 
for(int i=0; i<friends.size(); i++){
	String query = "Select max(score) as score, uID, zID, possible, time, timeTaken from scores where uID=" + friends.get(i) + " group by zID order by time DESC;";
	rs = statement.executeQuery(query);
	
	while(rs.next()){
		int frienduID = rs.getInt("uID");
		frienduIDs.add(frienduID);
		friendScores.add(rs.getInt("score"));
		friendPossible.add(rs.getInt("possible"));
		friendTimes.add(Double.parseDouble((Long.toString(rs.getLong("timeTaken"))))/1000);
		friendDates.add(rs.getTimestamp("time"));
		friendzIDs.add(rs.getInt("zID"));
		// query for friends name
	}
	
	
}

for(int x=0; x<frienduIDs.size(); x++){
	String query ="select * from users where uID=" + frienduIDs.get(x) + ";";
	ResultSet result = statement.executeQuery(query);
	if(result.next()){
		friendNames.add(result.getString("username"));
	}else{
		friendNames.add("Former User");
	}
	result.close();
}	

for(int x=0; x<friendzIDs.size(); x++){
	String query ="select * from quizzes where zID=" + friendzIDs.get(x) + ";";
	ResultSet result = statement.executeQuery(query);
	if(result.next()){
		friendQNames.add(result.getString("name"));
	}else{
		friendQNames.add("Deleted Quiz");
	}
	result.close();
}
Database.closeConnections(con, statement, r, rs);
%>
<br>
<table class="border">
<tr><td  class="border"><b>User</b></td><td  class="border"><b>Quiz</b></td><td  class="border"><b>Score</b></td><td  class="border"><b>Possible</b></td><td  class="border"><b>Time</b></td><td  class="border"><b>Date</b></td></tr>
<%
int friendSize = friendScores.size() > 6 ? 6 : friendScores.size();
for(int i=0; i<friendSize; i++){ %>
<tr>
	<td  class="border"><a href="user?uid=<%=frienduIDs.get(i)%>"><%= friendNames.get(i)%></a></td>
	<td  class="border"><a href="QuizIntro?num=<%=friendzIDs.get(i)%>"><%= friendQNames.get(i)%></a></td>
	<td  class="border"><%=friendScores.get(i)%></td>
	<td  class="border"><%=friendPossible.get(i)%></td>
	<td  class="border"><%=friendTimes.get(i)%></td>
	<td  class="border"><%=friendDates.get(i)%></td></tr>
<%} 
}%>
</table>
</div>

<div style="float: right; margin-right: 75px;">
	<h1>Your Quizzes</h1>
	<ul>
		<%
			ArrayList<Quiz> userRecentlyCreatedQuizzes = user
					.getRecentlyCreatedQuizzes(5);

			for (int i = 0; i < userRecentlyCreatedQuizzes.size(); i++) {
				Quiz quiz = userRecentlyCreatedQuizzes.get(i);
		%>
		<li><a href="QuizIntro?num=<%=quiz.getID()%>"><%=quiz.getName()%></a></li>
		<%
			}
		%>
	</ul>
	<a href="CreateQuizBegin.jsp">Create a Quiz</a>
	<h1>Recent Quizzes</h1>
	<ul>
		<%
			ArrayList<Quiz> recentQuizzes = Quiz.getRecentQuizzes(5);

			for (int i = 0; i < recentQuizzes.size(); i++) {
				Quiz quiz = recentQuizzes.get(i);
		%>
		<li><a href="QuizIntro?num=<%=quiz.getID()%>"><%=quiz.getName()%></a> (<%=TimeFormat.prettify(quiz.getTime().getTime())%>)</li>
		<%
			}
		%>
	</ul>
	<h1>Popular Quizzes</h1>
	<ul>
		<%
			ArrayList<Quiz> popularQuizzes = Quiz.getPopularQuizzes(5);

			for (int i = 0; i < popularQuizzes.size(); i++) {
				Quiz quiz = popularQuizzes.get(i);
		%>
		<li><a href="QuizIntro?num=<%=quiz.getID()%>"><%=quiz.getName()%></a> (<%=quiz.getNumAttempts()%> attempts)</li>
		<%
			}
		%>
	</ul>
</div>

<jsp:include page="<%=Constants.FOOTER_FILE%>"></jsp:include>
