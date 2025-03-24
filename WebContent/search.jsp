<%@ page import="java.util.*"%>
<%@ page import="quiz.*"%>

<jsp:include page="<%=Constants.HEADER_FILE%>">
	<jsp:param value="Search Results" name="title" />
</jsp:include>

<%
	User user = (User) session.getAttribute("user");
	if (user == null) {
		String redirectURL = "login.jsp";
		response.sendRedirect(redirectURL);
		return;
	}
	
	HashMap<Integer, User> users = (HashMap<Integer, User>) request
			.getAttribute("users");
	ArrayList<Quiz> quizzes = (ArrayList<Quiz>) request
			.getAttribute("quizzes");

	if (users != null && users.isEmpty() && quizzes != null
			&& quizzes.isEmpty()) {
%>
<h1>No results found.</h1>
<%
	}
	if (users != null && !users.isEmpty()) {
%>
<h1>Users</h1>
<ul>
	<%
		for (Integer uID : users.keySet()) {
	%>
	<li><a href="user?uid=<%=uID%>"><%=users.get(uID).getUsername()%></a></li>
	<%
		}
		}
	%>
</ul>

<%
	if (quizzes != null && !quizzes.isEmpty()) {
%>
<h1>Quizzes</h1>
<ul>
	<%
		for (Quiz quiz : quizzes) {
	%>
	<li><a href="QuizIntro?num=<%=quiz.getID()%>"><b> <%=quiz.getName()%>
		</b></a> - <%=quiz.getDescription()%></li>
	<%
		}
		}
	%>
</ul>

<jsp:include page="<%=Constants.FOOTER_FILE%>"></jsp:include>