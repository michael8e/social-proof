<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="quiz.Database"%>
<%@ page import="java.util.Date"%>
<%@ page import="quiz.*"%>

<jsp:include page="<%=Constants.HEADER_FILE%>">
	<jsp:param value="Take Quiz" name="title" />
</jsp:include>
<html>

<body>

	<%
		Connection con = Database.openConnection();
		Statement s = Database.getStatement(con);

		User user = (User) session.getAttribute("user");
		if (user == null) {
			String redirectURL = "login.jsp";
			response.sendRedirect(redirectURL);
		}

		int zID = (Integer) request.getAttribute("zID");
		String name = (String) request.getAttribute("name");
		String description = (String) request.getAttribute("description");
		int uID = (Integer) request.getAttribute("uID");
		Timestamp time = (Timestamp) request.getAttribute("time");

		// query for quiz creater's name
		String createQuery = "Select * from users where uID =" + uID + ";";
		ResultSet cs = s.executeQuery(createQuery);
		String createName = "Former User";
		Boolean formerUser = true;
		if (cs.next()) {
			createName = cs.getString("username");
			formerUser = false;
		}
	%>

	<p>
		<b>Quiz ID: </b>
		<%=zID%></p>
	<p>
		<b>Quiz Name: </b>
		<%=name%></p>
	<p>
		<b>Quiz Description: </b>
		<%=description%></p>
	<%
		if (formerUser) {
	%>
	<p>
		<b>Quiz Creator: </b><%=createName%></p>
	<%
		} else {
	%>
	<p>
		<b>Quiz Creator: </b><a href="user?uid=<%=uID%>"><%=createName%></a>
	</p>
	<%
		}
	%>
	<p>
		<b>Quiz Time Created: </b>
		<%=time%></p>

	<form action="GetQuiz">
		<input type="hidden" name="num" value="<%=zID%>"> <input type="submit"
			value="Begin">
	</form>

	<%
		String avgQuery = "Select avg(score) as score, max(possible) as possible, avg(timeTaken) as timeTaken from scores where zID="
				+ zID + ";";
		ResultSet rs = s.executeQuery(avgQuery);
		rs.next();
		double avgScore = rs.getDouble("score");
		double timeTaken = rs.getDouble("timeTaken");
		timeTaken = timeTaken / 1000;
		int possible = rs.getInt("possible");
	%>
	<br>
	<table>
		<tr>
			<td colspan="3"><b>Summary Statistics</b></td>
		</tr>
		<tr>
			<td><b>Avg. Score</b></td>
			<td><b>Possible</b></td>
			<td><b>Avg. Time</b></td>
		</tr>
		<tr>
			<td><%=avgScore%></td>
			<td><%=possible%></td>
			<td><%=timeTaken%></td>
		</tr>
	</table>

	<br>
	<table>
		<tr>
			<td colspan="4"><b>Your Past Performances</b></td>
		</tr>
		<tr>
			<td><b>Score</b></td>
			<td><b>Possible</b></td>
			<td><b>Time</b></td>
			<td><b>Date</b></td>
		</tr>
		<%
			Object o = session.getAttribute("user");
			if (o != null) {
				user = (User) o;
				Integer youruID = user.getID();

				Vector<Integer> yourScores = new Vector<Integer>();
				Vector<Integer> yourTotal = new Vector<Integer>();
				Vector<Double> yourPace = new Vector<Double>();
				Vector<Timestamp> yourTimes = new Vector<Timestamp>();

				String yourQuery = "Select * from scores where uID = "
						+ youruID + " and zID=" + zID + " order by time DESC;";
				rs = s.executeQuery(yourQuery);
				while (rs.next()) {
					yourScores.add(rs.getInt("score"));
					yourTotal.add(rs.getInt("possible"));
					yourTimes.add(rs.getTimestamp("time"));
					yourPace.add(((double) rs.getLong("timeTaken")) / 1000);
				}

				int yourCount = yourScores.size() < 6 ? yourScores.size() : 6;
				for (int i = 0; i < yourCount; i++) {
		%>
		<tr>
			<td><%=yourScores.get(i)%></td>
			<td><%=yourTotal.get(i)%></td>
			<td><%=yourPace.get(i)%></td>
			<td><%=yourTimes.get(i)%></td>
		</tr>
		<%
			}
			} else {
		%>
		<tr>
			<td><a href="login.jsp">Login</a></td>
		</tr>
		<%
			}
		%>
	</table>
	<br>

	<table>
		<tr>
			<td colspan="5"><b>Top Performers</b></td>
		</tr>
		<tr>
			<td><b>User</b></td>
			<td><b>Score</b></td>
			<td><b>Possible</b></td>
			<td><b>Time</b></td>
			<td><b>Date</b></td>
		</tr>
		<%
			Vector<Integer> topuID = new Vector<Integer>();
			Vector<String> topName = new Vector<String>();
			Vector<Integer> topScore = new Vector<Integer>();
			Vector<Integer> topTotal = new Vector<Integer>();
			Vector<Timestamp> topTimes = new Vector<Timestamp>();
			Vector<Double> topPace = new Vector<Double>();

			String topQuery = "Select uID, max(score) as score, max(possible) as possible, time, timeTaken from scores where zID="
					+ zID
					+ " group by uID order by score DESC, ABS(timeTaken) ASC;";
			rs = s.executeQuery(topQuery);
			while (rs.next()) {
				topuID.add(rs.getInt("uID"));
				topScore.add(rs.getInt("score"));
				topTotal.add(rs.getInt("possible"));
				topTimes.add(rs.getTimestamp("time"));
				topPace.add(((double) rs.getLong("timeTaken")) / 1000);
			}

			for (int i = 0; i < topuID.size(); i++) {
				int u = topuID.get(i);
				topQuery = "Select username from users where uID =" + u + ";";
				rs = s.executeQuery(topQuery);
				if (rs.next()) {
					topName.add(rs.getString("username"));
				} else {
					if (u == -1)
						topName.add("Anonymous");
					else
						topName.add("Deleted User");
				}
			}

			int nameSize = topName.size() < 6 ? topName.size() : 6;
			for (int i = 0; i < nameSize; i++) {
		%>
		<tr>
			<td><a href="user?uid=<%=topuID.get(i)%>"><%=topName.get(i)%></a></td>
			<td><%=topScore.get(i)%></td>
			<td><%=topTotal.get(i)%></td>
			<td><%=topPace.get(i)%></td>
			<td><%=topTimes.get(i)%></td>
		</tr>
		<%
			}
		%>
	</table>
	<br>

	<table>
		<tr>
			<td colspan="5"><b>High Scores</b></td>
		</tr>
		<tr>
			<td><b>User</b></td>
			<td><b>Score</b></td>
			<td><b>Possible</b></td>
			<td><b>Time</b></td>
			<td><b>Date</b></td>
		</tr>
		<%
			ArrayList<Integer> uIDs = new ArrayList<Integer>();
			ArrayList<String> usernames = new ArrayList<String>();
			ArrayList<Integer> scores = new ArrayList<Integer>();
			ArrayList<Integer> total = new ArrayList<Integer>();
			ArrayList<Timestamp> highTimes = new ArrayList<Timestamp>();
			ArrayList<Double> highPace = new ArrayList<Double>();

			String query = "Select * from scores where zID = " + zID
					+ " order by score DESC, abs(timeTaken) ASC;";
			rs = s.executeQuery(query);
			while (rs.next()) {
				uIDs.add(rs.getInt("uID"));
				scores.add(rs.getInt("score"));
				total.add(rs.getInt("possible"));
				highTimes.add(rs.getTimestamp("time"));
				highPace.add(((double) rs.getLong("timeTaken")) / 1000);
			}

			for (int i = 0; i < uIDs.size(); i++) {
				String q = "Select username from users where uID="
						+ uIDs.get(i) + ";";
				rs = s.executeQuery(q);
				if (rs.next()) {
					usernames.add(rs.getString("username"));
				} else {
					usernames.add("Deleted User");
				}
			}

			int size = uIDs.size();
			int count = size > 6 ? 6 : size;

			for (int i = 0; i < count; i++) {
		%>
		<tr>
			<td><a href="user?uid=<%=uIDs.get(i)%>"><%=usernames.get(i)%></a></td>
			<td><%=scores.get(i)%></td>
			<td><%=total.get(i)%></td>
			<td><%=highPace.get(i)%></td>
			<td><%=highTimes.get(i)%></td>
		</tr>
		<%
			}
		%>
	</table>
	<br>

	<table>
		<tr>
			<td colspan="5"><b>Top Scores in Last 15 Mins.</b></td>
		</tr>
		<tr>
			<td><b>User</b></td>
			<td><b>Score</b></td>
			<td><b>Possible</b></td>
			<td><b>Time</b></td>
			<td><b>Date</b></td>
		</tr>

		<%
			Vector<Boolean> recent = new Vector<Boolean>();
			int big = scores.size();

			Calendar now = Calendar.getInstance();
			now.add(Calendar.MINUTE, -15);

			for (int i = 0; i < big; i++) {
				Timestamp t = highTimes.get(i);

				if (t.after(now.getTime())) {
					recent.add(true);
				} else {
					recent.add(false);
				}
			}

			int fifteenSize = 0;
			for (int i = 0; i < scores.size(); i++) {
				if (recent.get(i) && fifteenSize < 6) {
					fifteenSize += 1;
		%>
		<tr>
			<td><a href="user?uid=<%=uIDs.get(i)%>"><%=usernames.get(i)%></a></td>
			<td><%=scores.get(i)%></td>
			<td><%=total.get(i)%></td>
			<td><%=highPace.get(i)%></td>
			<td><%=highTimes.get(i)%></td>
		</tr>
		<%
			}
			}
		%>
	</table>


	<br>
	<table>
		<tr>
			<td colspan="5"><b>Recent Scores (Good & Bad)</b></td>
		</tr>
		<tr>
			<td><b>User</b></td>
			<td><b>Score</b></td>
			<td><b>Possible</b></td>
			<td><b>Time</b></td>
			<td><b>Date</b></td>
		</tr>
		<%
			ArrayList<Integer> neutraluIDs = new ArrayList<Integer>();
			ArrayList<String> neutralNames = new ArrayList<String>();
			ArrayList<Integer> neutralScores = new ArrayList<Integer>();
			ArrayList<Integer> neutralPossible = new ArrayList<Integer>();
			ArrayList<Timestamp> neutralTimes = new ArrayList<Timestamp>();
			ArrayList<Double> neutralPace = new ArrayList<Double>();

			query = "Select * from scores where zID = " + zID
					+ " order by time DESC;";
			rs = s.executeQuery(query);
			while (rs.next()) {
				neutraluIDs.add(rs.getInt("uID"));
				neutralScores.add(rs.getInt("score"));
				neutralPossible.add(rs.getInt("possible"));
				neutralTimes.add(rs.getTimestamp("time"));
				neutralPace.add((rs.getDouble("timeTaken")) / 1000);
			}

			for (int i = 0; i < neutraluIDs.size(); i++) {
				String q = "Select username from users where uID="
						+ neutraluIDs.get(i) + ";";
				rs = s.executeQuery(q);
				if (rs.next()) {
					neutralNames.add(rs.getString("username"));
				} else {
					neutralNames.add("Deleted User");
				}
			}

			size = neutraluIDs.size();
			count = size > 6 ? 6 : size;

			for (int i = 0; i < size; i++) {
		%>
		<tr>
			<td><a href="user?uid=<%=neutraluIDs.get(i)%>"><%=neutralNames.get(i)%></a></td>
			<td><%=neutralScores.get(i)%></td>
			<td><%=neutralPossible.get(i)%></td>
			<td><%=neutralPace.get(i)%></td>
			<td><%=neutralTimes.get(i)%></td>
		</tr>
		<%
			}
		%>
	</table>
	<%
		HashMap<Integer, User> friends = user.getFriends();
		if (!friends.isEmpty()) {
	%>
	<h4>Challenge a friend to take this quiz!</h4>
	<form action="message" method="post">
		<input style="display: none;" name="request"
			value="<%=Constants.SEND_CHALLENGE%>"></input> <input style="display: none;"
			name="zID" value="<%=zID%>"></input> <select name="toID">
			<%
					for (Integer friendID : friends.keySet()) {
			%>
			<option value="<%=friendID%>"><%=friends.get(friendID).getUsername()%></option>
			<%
				}
			%>
		</select> <br> <br>

		<textarea name="content" style="width: 500px"></textarea>
		<h1>
			<input type="submit">
		</h1>
	</form>
	<%
		}
	%>
</body>
</html>
<jsp:include page="<%=Constants.FOOTER_FILE%>"></jsp:include>