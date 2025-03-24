<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="quiz.Constants"%>

<jsp:include page="<%=Constants.HEADER_FILE%>">
	<jsp:param value="Sign Up" name="title" />
</jsp:include>
<%
		String errorMessage = (String) request.getAttribute("error");
		if (errorMessage != null) {
	%>
<p>
	<%=errorMessage%>
</p>
<%
		}
	%>
	
	<h1>Sign Up</h1>

<form action="signup" method="post">
	<p>
		Username: <input type="text" name="username">
	</p>
	<p>
		Password: <input type="password" name="password">
	</p>
	<p>
		<input type="submit" name="Submit">
	</p>
</form>

<p>
	<a href="index.jsp">Home</a>
</p>

<jsp:include page="<%=Constants.FOOTER_FILE%>" />