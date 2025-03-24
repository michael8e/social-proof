<%@ page import="quiz.*"%>
<%@ page import="java.util.*"%>
<jsp:include page="<%=Constants.HEADER_FILE%>">
	<jsp:param value="Home" name="title" />
</jsp:include>

<%
	User user = (User) session.getAttribute("user");
	if (user == null) {
%>
<h1>You must be logged in to view this page!</h1>
<jsp:include page="<%=Constants.FOOTER_FILE%>" />
<%
	return;
	}

	HashMap<Integer, User> friends = user.getFriends();
	if (friends.isEmpty()) {
%>
<h1>You don't have any friends to send messages to.</h1>
<jsp:include page="<%=Constants.FOOTER_FILE%>" />
<%
	return;
	}
%>
<h1>Compose</h1>
<form action="message" method="post">
	<select name="toID">
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

<jsp:include page="<%=Constants.FOOTER_FILE%>" />