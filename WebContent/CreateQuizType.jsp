<%@ page import="quiz.*" %> 
<jsp:include page="<%=Constants.HEADER_FILE%>">
	<jsp:param value="Choose a Question Type" name="title" />
</jsp:include>
<html>
<body>

<p>Choose question type</p>
<form action="CreateQuiz2" method="post">

<p><input type="radio" name="type" value="1" checked>Text Response</p>
<p><input type="radio" name="type" value="2">Fill in the Blank</p>
<p><input type="radio" name="type" value="3">Multiple Choice</p>
<p><input type="radio" name="type" value="4">Picture Response</p>
<!--<p><input type="radio" name="type" value="5">Multi-Text-Box Answer</p>
<p><input type="radio" name="type" value="6">Multi-Choice Multi-Answer</p>
<p><input type="radio" name="type" value="7">Matching</p>
--><p><input type="submit" value="Next"></p>


</form>


</body>
</html>
<jsp:include page="<%=Constants.FOOTER_FILE%>"></jsp:include>