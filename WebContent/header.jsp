<%@page import="quiz.Constants"%>
<%@page import="quiz.User"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="stylesheet.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>${param.title} - <%=Constants.QUIZ_SITE_TITLE%></title>
<link rel="icon" href="/favicon.ico" type="image/x-icon" />
</head>
<body>
	<div class="page-container" style="margin-top: 50px; margin-bottom: 5px;">
		<a class="header-title" href="<%=Constants.INDEX%>">QuizFeed</a>
	</div>
	<div class="navbar">
		<div class="page-container">
			<div class="nav-left">
				<form action="search" method="get">
					<input type="text" name="query" placeholder="Search" class="search-field"></input>
				</form>
			</div>
			<div class="nav-right">
				<%
					User user = (User) session.getAttribute("user");
					if (user == null) {
				%>
				<a class="nav-item" href="login">Login</a> <a class="nav-item" href="signup">Sign
					Up</a>
				<%
					} else {
				%>
				<a class="nav-item" href="user?uid=<%=user.getID()%>"><%=user.getUsername()%></a>
				<%
					if (user.isAdmin()) {
				%>
				<a class="nav-item" href="AdminPage.jsp">Administration</a>
				<%
					}
				%>
				<a class="nav-item" href="inbox.jsp">Inbox (<%=user.getNotificationCount()%>)
				</a> <a class="nav-item" href="logout">Logout</a>
				<%
					}
				%>
			</div>
		</div>
	</div>
	<div class="page-container">