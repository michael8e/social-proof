<%@ page import="quiz.*" %> 
<jsp:include page="<%=Constants.HEADER_FILE%>">
	<jsp:param value="Making a Quiz" name="title" />
</jsp:include>
<html>   
<body>
<h1>Create a New Quiz</h1>
<form action="CreateQuiz1" method="post">
<p>Quiz Name: <input type="text" name="name"></p>
<p>Quiz Description: <input type="text" name="description"></p>
<p>Random Question Order: <input type="radio" name="random" value="yes">Yes
<input type="radio" name="random" value="no"checked>No </p>
<p>Each Question on a Different Page?: <input type="radio" name="multiple" value="yes">Yes
<input type="radio" name="multiple" value="no"checked>No </p>
<p>If so would you like immediate correction?: <input type="radio" name="immediate" value="yes">Yes
<input type="radio" name="immediate" value="no"checked>No </p>
<input type="submit" name="Begin">
</form>
</body>
</html>
<jsp:include page="<%=Constants.FOOTER_FILE%>"></jsp:include>