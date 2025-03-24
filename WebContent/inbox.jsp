<%@ page import="quiz.*"%>
<%@ page import="java.util.*"%>
<jsp:include page="<%=Constants.HEADER_FILE%>">
	<jsp:param value="Inbox" name="title" />
</jsp:include>
<%
	String responseMessage = (String) session.getAttribute("message");
	if (responseMessage != null) {
		session.removeAttribute("message");
%>
<p style="margin-bottom: 0px;"><%=responseMessage%></p>
<%
	}
%>

<%
	User user = (User) session.getAttribute("user");
	if (user == null) {
%>
<h1>You must be logged in to view this page!</h1>
<%
	} else {

		HashMap<Integer, User> friendRequests = user
				.getFriendRequests();
		ArrayList<Message> messages = user.getMessages();
		ArrayList<Challenge> challenges = user.getChallenges();
		%>
<h1>Challenges</h1>
<%
			if (challenges.isEmpty()) {
		%>
<p>You have no challenges right now.</p>
<%
			} else {
					for (Challenge challenge : challenges) {
		%>
<div class="message-container">
	<p>
		<a href="user?uid=<%=challenge.getSender().getID()%>"> <%=challenge.getSender().getUsername()%></a>
		has challenged you to beat their highest score on <a
			href="QuizIntro?num=<%=challenge.getQuiz().getID()%>"><%=challenge.getQuiz().getName()%></a>.
	</p>
	<div class="message-content"><%=challenge.getMessage()%></div>
	<p>
		<a href="QuizIntro?num=<%=challenge.getQuiz().getID()%>">Take the quiz!</a> <span
			style="margin-left: 7px; margin-right: 7px;"> | </span> <a
			href="message?request=<%=Constants.IGNORE_CHALLENGE%>&cID=<%=challenge.getID()%>">Delete</a>
	</p>
</div>
<%
			}
				}
		%>
<h1 style="margin-bottom: 5px;">Messages</h1>
<a href="compose.jsp">Compose</a>
<%
	if (messages.isEmpty()) {
%>
<p>You have no messages right now.</p>
<%
	}
		for (Message message : messages) {
%>
<div class="message-container">
	<pre class="message-content"><%=message.getMessage()%></pre>
	<p style="margin-bottom: 7px;">
		from <a href="user?uid=<%=message.getSender().getID()%>"> <%=message.getSender().getUsername()%></a>
		on
		<%=TimeFormat.prettify(message.getTimestamp()
							.getTime())%></p>
	<span><a
		href="message?request=<%=Message.MARK_AS_READ%>&mID=<%=message.getID()%>">Mark
			as Read</a></span>

</div>
<%
	}
%>

<h1>Friend Requests</h1>
<%
	if (friendRequests.isEmpty()) {
%>
<p>You have no friend requests right now.</p>
<%
	} else {
%>
<ul>
	<%
		for (Integer requesterID : friendRequests.keySet()) {
	%>
	<li><a href="user?uid=<%=requesterID%>"><%=friendRequests.get(requesterID).getUsername()%></a>
		- <a
		href="request?request=<%=Constants.ACCEPT_REQUEST%>&friendid=<%=requesterID%>">Accept</a>
		| <a
		href="request?request=<%=Constants.REJECT_REQUEST%>&friendid=<%=requesterID%>">Reject</a></li>
	<%
		}
	%>
</ul>
<%
	}
	}
%>
<jsp:include page="<%=Constants.FOOTER_FILE%>" />