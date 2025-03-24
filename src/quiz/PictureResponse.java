package quiz;

import java.util.ArrayList;

public class PictureResponse extends Question {
	public PictureResponse(String question, ArrayList<String> answers) {
		super(question, answers);
	}
	
	@Override
	public int getType() {
		return 3;
	}	
	
}
//
//Question q = quiz.getQuestion(0);
//if (q.getType() == 1) {
//	QuestionResponse qr = (QuestionResponse)q
//}
