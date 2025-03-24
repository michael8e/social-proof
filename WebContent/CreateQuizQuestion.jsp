<%@ page import="quiz.*" %>    
<jsp:include page="<%=Constants.HEADER_FILE%>">
	<jsp:param value="Create a Quiz Question" name="title" />
</jsp:include>
<html>
<body>

<% int zID = (Integer)request.getSession().getAttribute("quizNumber"); %>
<% int type = (Integer)request.getSession().getAttribute("type"); %>

<form action="CreateQuiz3" method="post">
<%if(type == Constants.TEXT_RESPONSE){ %>
	<p>Text Response</p>
	<p>Question: <input type="text" name="question"></p>
	<p>Answer: <input type="text" name="answer"></p>
<%} %>
<%if(type == Constants.FILL_IN_BLANK){ %>
	<p>Fill in the Blank</p>
	<p>Question before blank: <input type="text" name="question"></p>
	<p>Blank/Answer: <input type="text" name="answer"></p>
	<p>Question after blank: <input type="text" name="question*"></p>
<%} %>
<%if(type == Constants.MULT_CHOICE){ %>
	<p>Multiple Choice</p>
	<p>Question: <input type="text" name="question"></p>
	<p>Option 1: <input type="text" name="answer1"></p>
	<p>Option 2: <input type="text" name="answer2"></p>
	<p>Option 3: <input type="text" name="answer3"></p>
	<p>Option 4: <input type="text" name="answer4"></p>
	<p>Correct Option Number: <input type="radio" name="correctAnswer" value="1" checked>1
		<input type="radio" name="correctAnswer" value="2">2
		<input type="radio" name="correctAnswer" value="3">3
		<input type="radio" name="correctAnswer" value="4">4
	</p>
<%} %>
<%if(type == Constants.PICTURE_RESPONSE){ %>
	<p>Picture</p>
	<p>Photo Url: <input type="text" name="question"></p>
	<p>Answer: <input type="text" name="answer"></p>
<%} %>
<%if(type == Constants.MULTI_TEXT_RESPONSE){ %>
	<p>Question: <input type="text" name="question"></p>
	<p>Answer: <input type="text" name="answer"></p>
<%} %>
<%if(type == Constants.MULTI_CHOICE_ANSWER){ %>
	<p>Question: <input type="text" name="question"></p>
	<p>Answer: <input type="text" name="answer"></p>
<%} %>
<%if (type == Constants.MATCHING){ %>
	<p>Question: <input type="text" name="question"></p>
	<p>Answer: <input type="text" name="answer"></p>
<%} %>

<input type="radio" name="status" value="continue"checked>Make Another Question
<input type="radio" name="status" value="finish">Finish the Quiz!
<input type="submit" value="Submit">
</form>

</body>
</html>
<jsp:include page="<%=Constants.FOOTER_FILE%>"></jsp:include>