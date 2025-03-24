package quiz;

import java.util.ArrayList;

public class MultipleChoice extends Question{
	int correctAnsIndex;
	public MultipleChoice(String question, ArrayList<String> answers, int index) {
		super(question, answers);
		correctAnsIndex = index;
	}
	
	@Override
	public int getType() {
		return 2;
	}	
	
	public int correctAnswer() {
		return correctAnsIndex;
	}
}
