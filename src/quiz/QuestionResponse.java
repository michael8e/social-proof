package quiz;

import java.util.ArrayList;

public class QuestionResponse extends Question{
	public QuestionResponse(String question, ArrayList<String> answers) {
		super(question, answers);
	}
	
	@Override
	public int getType() {
		return 0;
	}	
}

